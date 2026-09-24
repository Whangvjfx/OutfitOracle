import Foundation
import CoreLocation

/// 统一的天气数据模型（屏蔽 WeatherKit 与其他数据源的底层模型差异）
public struct WeatherSnapshot: Identifiable, Sendable {
    public let id = UUID()
    /// 当前温度（摄氏度）
    public let temperature: Double
    /// 体感温度（Apparent Temperature / Feels Like，用于核心穿衣判定）
    public let apparentTemperature: Double
    /// 今日最高气温
    public let dailyHigh: Double
    /// 今日最低气温
    public let dailyLow: Double
    /// 降水概率 (0.0 ~ 1.0)
    public let precipitationChance: Double
    /// 湿度 (0.0 ~ 1.0)
    public let humidity: Double
    /// 风速 (米/秒 或 km/h，此处存为 m/s)
    public let windSpeed: Double
    /// 天气状况描述（例如：晴、多云、小雨等）
    public let conditionDescription: String
    /// 对应的 SF Symbol 图标名称（如 "sun.max.fill", "cloud.rain.fill"）
    public let symbolName: String
    /// 数据更新时间
    public let updatedAt: Date

    public init(
        temperature: Double,
        apparentTemperature: Double,
        dailyHigh: Double,
        dailyLow: Double,
        precipitationChance: Double,
        humidity: Double,
        windSpeed: Double,
        conditionDescription: String,
        symbolName: String,
        updatedAt: Date = Date()
    ) {
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.dailyHigh = dailyHigh
        self.dailyLow = dailyLow
        self.precipitationChance = precipitationChance
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.conditionDescription = conditionDescription
        self.symbolName = symbolName
        self.updatedAt = updatedAt
    }
}
