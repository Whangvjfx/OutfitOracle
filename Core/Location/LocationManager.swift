import Foundation
import CoreLocation
import Observation

/// 统一的定位状态枚举
public enum LocationState: Equatable, Sendable {
    case idle
    case requestingAuthorization
    case denied
    case locating
    case resolved(CLLocation, cityName: String)
    case manualSelected(CityModel)
    case failed(String)
}

/// 基于 iOS 17 @Observable 宏的现代化定位管理器（支持自动 GPS 与手动城市切换）
@Observable
public final class LocationManager: NSObject, CLLocationManagerDelegate {
    public var state: LocationState = .idle
    public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    public var lastLocation: CLLocation?
    public var currentCity: String = "哈尔滨"
    public var selectedCity: CityModel = CityDatabase.defaultHarbin
    public var isManualCity: Bool = false

    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private let userDefaultsKey = "OutfitOracle.SelectedCity"

    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        authorizationStatus = locationManager.authorizationStatus

        // 读取持久化手动城市，未设置时默认哈尔滨
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let saved = try? JSONDecoder().decode(CityModel.self, from: data) {
            self.selectedCity = saved
            self.currentCity = saved.name
            self.lastLocation = saved.clLocation
            self.isManualCity = true
        } else {
            self.selectedCity = CityDatabase.defaultHarbin
            self.currentCity = CityDatabase.defaultHarbin.name
            self.lastLocation = CityDatabase.defaultHarbin.clLocation
        }
    }

    /// 用户主动选择指定城市
    public func selectCity(_ city: CityModel) {
        self.selectedCity = city
        self.currentCity = city.name
        self.lastLocation = city.clLocation
        self.isManualCity = true
        self.state = .manualSelected(city)

        if let data = try? JSONEncoder().encode(city) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    /// 请求定位权限并获取一次精准位置
    public func requestCurrentLocation() {
        if isManualCity {
            // 如果用户已经手动选择了城市，优先保持手动城市
            state = .manualSelected(selectedCity)
            return
        }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            state = .requestingAuthorization
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            fetchLocation()
        case .denied, .restricted:
            state = .denied
            fallbackToDefaultCity()
        @unknown default:
            fallbackToDefaultCity()
        }
    }

    /// 强制重新尝试 GPS 定位
    public func retryGPSLocation() {
        self.isManualCity = false
        switch locationManager.authorizationStatus {
        case .notDetermined:
            state = .requestingAuthorization
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            fetchLocation()
        default:
            fallbackToDefaultCity()
        }
    }

    private func fetchLocation() {
        state = .locating
        locationManager.requestLocation()
    }

    private func fallbackToDefaultCity() {
        self.currentCity = selectedCity.name
        self.lastLocation = selectedCity.clLocation
        self.state = .manualSelected(selectedCity)
    }

    // MARK: - CLLocationManagerDelegate

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if !isManualCity {
                fetchLocation()
            }
        case .denied, .restricted:
            state = .denied
            fallbackToDefaultCity()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        self.isManualCity = false

        // 异步反向地理编码
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            let city = placemarks?.first?.locality 
                ?? placemarks?.first?.subAdministrativeArea 
                ?? placemarks?.first?.administrativeArea
                ?? placemarks?.first?.name 
                ?? self.selectedCity.name
            self.currentCity = city
            self.state = .resolved(location, cityName: city)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let clError = (error as? CLError)
        if clError?.code == .locationUnknown { return }
        print("定位异常，平滑回退到目标城市: \(error.localizedDescription)")
        fallbackToDefaultCity()
    }
}
