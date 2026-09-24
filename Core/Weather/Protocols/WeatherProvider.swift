import Foundation
import CoreLocation

/// 天气数据提供者通用协议
public protocol WeatherProvider: Sendable {
    /// 根据给定的地理经纬度获取综合天气数据
    func fetchWeather(for location: CLLocation) async throws -> WeatherSnapshot
}
