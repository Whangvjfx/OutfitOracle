import Foundation
import CoreLocation

/// 逐小时天气数据
public struct HourlyWeather: Identifiable, Sendable {
    public let id = UUID()
    public let time: Date
    public let hourString: String
    public let temperature: Double
    public let apparentTemperature: Double
    public let symbolName: String
    public let conditionDescription: String
    public let precipitationChance: Double

    public init(
        time: Date,
        hourString: String,
        temperature: Double,
        apparentTemperature: Double,
        symbolName: String,
        conditionDescription: String,
        precipitationChance: Double
    ) {
        self.time = time
        self.hourString = hourString
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.symbolName = symbolName
        self.conditionDescription = conditionDescription
        self.precipitationChance = precipitationChance
    }
}

/// 统一的天气数据模型（包含实时、日统计与24小时逐小时预报）
public struct WeatherSnapshot: Identifiable, Sendable {
    public let id = UUID()
    /// 当前温度（摄氏度）
    public let temperature: Double
    /// 体感温度（Apparent Temperature，用于核心穿衣判定）
    public let apparentTemperature: Double
    /// 今日最高气温
    public let dailyHigh: Double
    /// 今日最低气温
    public let dailyLow: Double
    /// 降水概率 (0.0 ~ 1.0)
    public let precipitationChance: Double
    /// 湿度 (0.0 ~ 1.0)
    public let humidity: Double
    /// 风速 (m/s)
    public let windSpeed: Double
    /// 天气状况描述
    public let conditionDescription: String
    /// 对应的 SF Symbol 图标名称
    public let symbolName: String
    /// 24小时逐小时预报列表
    public let hourlyList: [HourlyWeather]
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
        hourlyList: [HourlyWeather] = [],
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
        self.hourlyList = hourlyList
        self.updatedAt = updatedAt
    }
}
