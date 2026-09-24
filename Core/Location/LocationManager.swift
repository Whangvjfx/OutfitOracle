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
    case failed(String)
}

/// 基于 iOS 17 @Observable 宏的现代化定位管理器
@Observable
public final class LocationManager: NSObject, CLLocationManagerDelegate {
    public var state: LocationState = .idle
    public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    public var lastLocation: CLLocation?
    public var currentCity: String = "正在定位..."

    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        authorizationStatus = locationManager.authorizationStatus
    }

    /// 请求定位权限并获取一次精准位置
    public func requestCurrentLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            state = .requestingAuthorization
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            fetchLocation()
        case .denied, .restricted:
            state = .denied
        @unknown default:
            state = .failed("未知的定位权限状态")
        }
    }

    private func fetchLocation() {
        state = .locating
        locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            fetchLocation()
        case .denied, .restricted:
            state = .denied
        case .notDetermined:
            state = .idle
        @unknown default:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location

        // 异步反向地理编码获取城市名
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            let city = placemarks?.first?.locality 
                ?? placemarks?.first?.subAdministrativeArea 
                ?? placemarks?.first?.name 
                ?? "未知地区"
            self.currentCity = city
            self.state = .resolved(location, cityName: city)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let clError = (error as? CLError)
        // 忽略临时网络定位抖动
        if clError?.code == .locationUnknown { return }
        state = .failed(error.localizedDescription)
    }
}
