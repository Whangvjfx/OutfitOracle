import Foundation
import CoreLocation
import Observation

/// 首页主控制器 ViewModel
@Observable
public final class HomeViewModel {
    // 界面显示状态
    public var isLoading: Bool = false
    public var weather: WeatherSnapshot?
    public var currentPlan: OutfitPlan?
    public var errorMessage: String?
    
    // 定位与偏好
    public let locationManager = LocationManager()
    public var preference: ThermalPreference = .neutral
    public var genderPreference: GenderCategory = .men
    public var shuffleSeed: Int = 0

    // 单品池与推荐引擎
    public var wardrobe: [ClothingItem] = []
    private let weatherService: WeatherProvider = OpenMeteoWeatherService()
    private let engine = OutfitRecommendationEngine()

    private let genderKey = "OutfitOracle.UserGender"
    private let thermalKey = "OutfitOracle.UserThermal"

    public init() {
        self.wardrobe = WardrobeDefaults.initialItems

        // 读取持久化偏好
        if let gRaw = UserDefaults.standard.string(forKey: genderKey),
           let g = GenderCategory(rawValue: gRaw) {
            self.genderPreference = g
        }
        if let tRaw = UserDefaults.standard.string(forKey: thermalKey),
           let t = ThermalPreference(rawValue: tRaw) {
            self.preference = t
        }
    }

    /// 用户切换性别风格
    public func setGenderPreference(_ gender: GenderCategory) {
        self.genderPreference = gender
        UserDefaults.standard.set(gender.rawValue, forKey: genderKey)
        calculatePlan()
    }

    /// 用户切换冷热偏好
    public func setThermalPreference(_ thermal: ThermalPreference) {
        self.preference = thermal
        UserDefaults.standard.set(thermal.rawValue, forKey: thermalKey)
        calculatePlan()
    }

    /// 用户主动选择指定城市
    @MainActor
    public func changeCity(_ city: CityModel) async {
        locationManager.selectCity(city)
        await loadWeatherForCurrentLocation()
    }

    /// 首次加载或下拉刷新全流程
    @MainActor
    public func loadData() async {
        guard !isLoading else { return }
        locationManager.requestCurrentLocation()
        await loadWeatherForCurrentLocation()
    }

    @MainActor
    private func loadWeatherForCurrentLocation() async {
        isLoading = true
        errorMessage = nil

        let targetLocation = locationManager.lastLocation ?? CityDatabase.defaultHarbin.clLocation

        do {
            let fetchedWeather = try await weatherService.fetchWeather(for: targetLocation)
            self.weather = fetchedWeather
            calculatePlan()
        } catch {
            print("在线天气获取异常，启用兜底: \(error.localizedDescription)")
            let mock = MockWeatherService(scenario: .coolAutumn)
            if let fallbackWeather = try? await mock.fetchWeather(for: targetLocation) {
                self.weather = fallbackWeather
                calculatePlan()
            }
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// 执行穿搭计算
    public func calculatePlan() {
        guard let weather = weather else { return }
        self.currentPlan = engine.generateOutfit(
            for: weather,
            preference: preference,
            gender: genderPreference,
            wardrobe: wardrobe,
            shuffleSeed: shuffleSeed
        )
    }

    /// 用户点击“换一套”
    public func shuffleOutfit() {
        shuffleSeed += 1
        calculatePlan()
    }
}
