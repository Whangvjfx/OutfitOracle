import Foundation
import CoreLocation

/// 针对个人开发者/脱壳/无苹果开发者账号的 100% 免费实时天气服务（无需任何 API Key，全球可用）
/// 数据源：Open-Meteo (开源气象数据，支持体感温度、日温差、降水概率)
public final class OpenMeteoWeatherService: WeatherProvider {
    
    public init() {}

    public func fetchWeather(for location: CLLocation) async throws -> WeatherSnapshot {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
        
        let current = decoded.current
        let daily = decoded.daily

        let temp = current.temperature_2m
        let apparentTemp = current.apparent_temperature
        let humidity = Double(current.relative_humidity_2m) / 100.0
        let windSpeed = current.wind_speed_10m
        
        let high = daily.temperature_2m_max.first ?? temp
        let low = daily.temperature_2m_min.first ?? temp
        let precipChance = Double(daily.precipitation_probability_max.first ?? 0) / 100.0
        
        let wmoCode = current.weather_code
        let (desc, symbol) = parseWMOCode(wmoCode)

        return WeatherSnapshot(
            temperature: temp,
            apparentTemperature: apparentTemp,
            dailyHigh: high,
            dailyLow: low,
            precipitationChance: precipChance,
            humidity: humidity,
            windSpeed: windSpeed,
            conditionDescription: desc,
            symbolName: symbol,
            updatedAt: Date()
        )
    }

    /// WMO 国际气象代码映射到中文描述与 SF Symbol 图标
    private func parseWMOCode(_ code: Int) -> (description: String, symbol: String) {
        switch code {
        case 0:
            return ("晴朗", "sun.max.fill")
        case 1:
            return ("晴间多云", "sun.max.fill")
        case 2:
            return ("多云", "cloud.sun.fill")
        case 3:
            return ("阴天", "cloud.fill")
        case 45, 48:
            return ("雾霾", "cloud.fog.fill")
        case 51, 53, 55:
            return ("细雨霏霏", "cloud.drizzle.fill")
        case 61:
            return ("小雨", "cloud.rain.fill")
        case 63:
            return ("中雨", "cloud.rain.fill")
        case 65:
            return ("大雨倾盆", "cloud.heavyrain.fill")
        case 71, 73, 75:
            return ("降雪", "snowflake")
        case 80, 81, 82:
            return ("强阵雨", "cloud.heavyrain.fill")
        case 95, 96, 99:
            return ("雷阵雨", "cloud.bolt.rain.fill")
        default:
            return ("多云", "cloud.sun.fill")
        }
    }
}

// MARK: - Open-Meteo JSON 数据传输对象 (DTO)

private struct OpenMeteoResponse: Decodable {
    let current: CurrentWeatherDTO
    let daily: DailyWeatherDTO
}

private struct CurrentWeatherDTO: Decodable {
    let temperature_2m: Double
    let relative_humidity_2m: Int
    let apparent_temperature: Double
    let precipitation: Double
    let weather_code: Int
    let wind_speed_10m: Double
}

private struct DailyWeatherDTO: Decodable {
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
    let precipitation_probability_max: [Int]
    let weather_code: [Int]
}
