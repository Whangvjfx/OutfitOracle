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
    public var shuffleSeed: Int = 0

    // 单品池与推荐引擎
    public var wardrobe: [ClothingItem] = []
    private let weatherService: WeatherProvider = OpenMeteoWeatherService()
    private let engine = OutfitRecommendationEngine()

    public init() {
        self.wardrobe = WardrobeDefaults.initialItems
    }

    /// 首次加载或下拉刷新全流程
    @MainActor
    public func loadData() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        // 1. 请求定位
        locationManager.requestCurrentLocation()

        var attempts = 0
        var targetLocation: CLLocation?

        while attempts < 25 {
            try? await Task.sleep(nanoseconds: 300_000_000)
            attempts += 1

            if case .resolved(let location, _) = locationManager.state {
                targetLocation = location
                break
            } else if case .denied = locationManager.state {
                break
            }
        }

        // 兜底坐标（若模拟器或未授权，默认北京海淀）
        let finalLocation = targetLocation ?? CLLocation(latitude: 39.9847, longitude: 116.3184)
        if targetLocation == nil {
            locationManager.currentCity = "默认位置 (北京海淀)"
        }

        // 2. 获取实时气象数据
        do {
            let fetchedWeather = try await weatherService.fetchWeather(for: finalLocation)
            self.weather = fetchedWeather
            // 3. 计算生成穿搭推荐
            calculatePlan()
        } catch {
            print("获取天气失败，启用离线仿真数据兜底: \(error.localizedDescription)")
            let mock = MockWeatherService(scenario: .warmSpring)
            if let fallbackWeather = try? await mock.fetchWeather(for: finalLocation) {
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
            wardrobe: wardrobe,
            shuffleSeed: shuffleSeed
        )
    }

    /// 用户点击“换一批”
    public func shuffleOutfit() {
        shuffleSeed += 1
        calculatePlan()
    }
}
