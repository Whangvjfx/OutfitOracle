import Foundation
import CoreLocation
import Observation

/// 阶段 1 天气诊断与状态管理 ViewModel
@Observable
public final class WeatherTestViewModel {
    public enum ActiveProviderType: String, CaseIterable, Identifiable {
        case openMeteo = "免费实时天气 (免账号/推荐)"
        case appleWeatherKit = "Apple WeatherKit (需开发者权限)"
        case mockData = "Mock 仿真数据 (测试/离线)"

        public var id: String { rawValue }
    }

    // 核心状态：默认选用免账号的免费实时气象服务
    public var selectedProviderType: ActiveProviderType = .openMeteo
    public var mockScenario: MockWeatherService.PresetScenario = .warmSpring
    
    public var isLoading: Bool = false
    public var weather: WeatherSnapshot?
    public var errorMessage: String?
    public var debugLogs: [String] = []

    public let locationManager = LocationManager()
    
    private let openMeteoService = OpenMeteoWeatherService()
    private let appleWeatherService = AppleWeatherService()
    private let mockWeatherService = MockWeatherService()

    public init() {
        log("OutfitOracle 天气引擎初始化完成。准备获取定位与天气...")
    }

    /// 执行定位与天气获取流程
    @MainActor
    public func startFetchingProcess() async {
        isLoading = true
        errorMessage = nil
        log("正在请求定位权限并获取当前 GPS 坐标...")
        
        locationManager.requestCurrentLocation()
        
        // 观察定位状态，轮询等待定位完成（带超时机制）
        var attempts = 0
        while attempts < 30 {
            try? await Task.sleep(nanoseconds: 300_000_000)
            attempts += 1

            switch locationManager.state {
            case .resolved(let location, let cityName):
                log("定位成功：\(cityName) (经度: \(String(format: "%.4f", location.coordinate.longitude)), 纬度: \(String(format: "%.4f", location.coordinate.latitude)))")
                await loadWeather(for: location)
                isLoading = false
                return
            case .denied:
                log("定位权限被用户拒绝，请在系统设置中允许定位。")
                errorMessage = "定位权限被拒绝，无法获取本地天气。请在系统设置中开启定位权限，或切换到 Mock 模式预览。"
                isLoading = false
                return
            case .failed(let reason):
                log("定位失败: \(reason)")
                errorMessage = "定位失败: \(reason)"
                isLoading = false
                return
            default:
                break
            }
        }

        // 超时兜底（例如模拟器未设置 Location）
        log("定位等待超时（模拟器请在 Features -> Location 中设置坐标），启用默认坐标（北京海淀区）进行测试。")
        let fallbackLocation = CLLocation(latitude: 39.9847, longitude: 116.3184)
        locationManager.currentCity = "默认位置 (北京海淀)"
        await loadWeather(for: fallbackLocation)
        isLoading = false
    }

    /// 根据坐标拉取天气
    @MainActor
    public func loadWeather(for location: CLLocation) async {
        isLoading = true
        errorMessage = nil

        let provider: WeatherProvider
        switch selectedProviderType {
        case .openMeteo:
            provider = openMeteoService
            log("正在通过免账号免费气象服务 (Open-Meteo) 抓取实时气象数据...")
        case .appleWeatherKit:
            provider = appleWeatherService
            log("正在通过 Apple WeatherKit 抓取实时气象数据...")
        case .mockData:
            mockWeatherService.scenario = mockScenario
            provider = mockWeatherService
            log("正在加载 Mock 天气场景：\(mockScenario)...")
        }

        do {
            let result = try await provider.fetchWeather(for: location)
            self.weather = result
            log("=== 天气数据拉取成功 ===")
            log("实际气温: \(String(format: "%.1f", result.temperature))°C")
            log("体感气温: \(String(format: "%.1f", result.apparentTemperature))°C")
            log("今日温差: \(String(format: "%.1f", result.dailyLow))°C ~ \(String(format: "%.1f", result.dailyHigh))°C")
            log("降水概率: \(Int(result.precipitationChance * 100))%")
            log("相对湿度: \(Int(result.humidity * 100))%")
            log("天气状况: \(result.conditionDescription) (SF Symbol: \(result.symbolName))")
        } catch {
            log("获取天气发生错误: \(error.localizedDescription)")
            
            // 友好的错误诊断提示（例如 WeatherKit 权限缺失）
            if selectedProviderType == .appleWeatherKit {
                let diagnostic = "提示：Apple WeatherKit 需要在 Apple 开发者后台开启 Capability。如果您是通过 GitHub Actions 自动化脱壳/自签打包，缺少有效签名可能导致 WeatherKit 401/403 认证失败。此时可点击上方切换为【Mock 仿真数据】继续测试业务与算法。"
                log(diagnostic)
                self.errorMessage = "\(error.localizedDescription)\n\n\(diagnostic)"
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }

    public func clearLogs() {
        debugLogs.removeAll()
    }

    private func log(_ message: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        let formatted = "[\(timestamp)] \(message)"
        debugLogs.append(formatted)
        print(formatted)
    }
}
