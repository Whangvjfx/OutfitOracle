import Foundation
import CoreLocation
import WeatherKit

/// 基于 Apple 官方 WeatherKit 的天气服务实现
/// 注意：WeatherKit 要求 App 具备 WeatherKit Capability（需关联已付费或具备对应权限的 Apple 开发者账号）
public final class AppleWeatherService: WeatherProvider {
    private let weatherService: WeatherService

    public init(weatherService: WeatherService = .shared) {
        self.weatherService = weatherService
    }

    public func fetchWeather(for location: CLLocation) async throws -> WeatherSnapshot {
        // 调用 WeatherKit 原生 API 批量获取当前天气、日预报与小时预报
        let weather = try await weatherService.weather(for: location)
        
        let current = weather.currentWeather
        let todayForecast = weather.dailyForecast.first
        
        // 温度统一转为摄氏度 Celsius
        let tempC = current.temperature.converted(to: .celsius).value
        let apparentTempC = current.apparentTemperature.converted(to: .celsius).value
        
        let highC = todayForecast?.highTemperature.converted(to: .celsius).value ?? tempC
        let lowC = todayForecast?.lowTemperature.converted(to: .celsius).value ?? tempC
        
        // 降水概率：优先取当日日预报，或首小时预报
        let precipChance = todayForecast?.precipitationChance ?? (weather.hourlyForecast.first?.precipitationChance ?? 0.0)
        let humidity = current.humidity
        let windSpeed = current.wind.speed.converted(to: .metersPerSecond).value
        let conditionDesc = current.condition.description
        let symbol = current.symbolName

        return WeatherSnapshot(
            temperature: tempC,
            apparentTemperature: apparentTempC,
            dailyHigh: highC,
            dailyLow: lowC,
            precipitationChance: precipChance,
            humidity: humidity,
            windSpeed: windSpeed,
            conditionDescription: conditionDesc,
            symbolName: symbol,
            updatedAt: Date()
        )
    }
}
