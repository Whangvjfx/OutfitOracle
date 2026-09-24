import Foundation
import CoreLocation

/// 针对本地 SwiftUI 预览、单测、或无付费开发者账号时的 Mock 天气服务
public final class MockWeatherService: WeatherProvider {
    public enum PresetScenario {
        case freezingWinter // 极寒冬日 -3°C
        case coolAutumn     // 清爽凉秋 16°C
        case warmSpring     // 舒适春日 22°C
        case hotSummer      // 酷暑炎夏 33°C
        case rainyDay       // 阴雨潮湿 18°C
    }

    public var scenario: PresetScenario

    public init(scenario: PresetScenario = .warmSpring) {
        self.scenario = scenario
    }

    public func fetchWeather(for location: CLLocation) async throws -> WeatherSnapshot {
        // 模拟网络延迟 0.4s
        try await Task.sleep(nanoseconds: 400_000_000)

        switch scenario {
        case .freezingWinter:
            return WeatherSnapshot(
                temperature: -2.0,
                apparentTemperature: -6.5,
                dailyHigh: 1.0,
                dailyLow: -8.0,
                precipitationChance: 0.70,
                humidity: 0.85,
                windSpeed: 6.2,
                conditionDescription: "小雪寒风",
                symbolName: "snowflake"
            )
        case .coolAutumn:
            return WeatherSnapshot(
                temperature: 16.0,
                apparentTemperature: 15.0,
                dailyHigh: 19.0,
                dailyLow: 11.0,
                precipitationChance: 0.10,
                humidity: 0.55,
                windSpeed: 3.5,
                conditionDescription: "多云微风",
                symbolName: "cloud.sun.fill"
            )
        case .warmSpring:
            return WeatherSnapshot(
                temperature: 22.0,
                apparentTemperature: 22.5,
                dailyHigh: 24.0,
                dailyLow: 15.0,
                precipitationChance: 0.05,
                humidity: 0.45,
                windSpeed: 2.1,
                conditionDescription: "晴朗明媚",
                symbolName: "sun.max.fill"
            )
        case .hotSummer:
            return WeatherSnapshot(
                temperature: 34.0,
                apparentTemperature: 38.0,
                dailyHigh: 36.0,
                dailyLow: 27.0,
                precipitationChance: 0.20,
                humidity: 0.75,
                windSpeed: 1.8,
                conditionDescription: "烈日炎炎",
                symbolName: "sun.max.trianglebadge.exclamationmark.fill"
            )
        case .rainyDay:
            return WeatherSnapshot(
                temperature: 17.5,
                apparentTemperature: 16.0,
                dailyHigh: 19.0,
                dailyLow: 14.0,
                precipitationChance: 0.90,
                humidity: 0.92,
                windSpeed: 4.5,
                conditionDescription: "持续中雨",
                symbolName: "cloud.rain.fill"
            )
        }
    }
}
