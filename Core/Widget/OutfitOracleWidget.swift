import WidgetKit
import SwiftUI
import CoreLocation

/// WidgetKit 时间线提供者
public struct OutfitTimelineProvider: TimelineProvider {
    private let weatherService = OpenMeteoWeatherService()
    private let engine = OutfitRecommendationEngine()

    public init() {}

    public func placeholder(in context: Context) -> OutfitWidgetEntry {
        OutfitWidgetEntry.placeholder
    }

    public func getSnapshot(in context: Context, completion: @escaping (OutfitWidgetEntry) -> Void) {
        completion(OutfitWidgetEntry.placeholder)
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<OutfitWidgetEntry>) -> Void) {
        Task {
            // 使用默认位置或从共享 UserDefaults / AppGroup 中读取最后已知坐标
            let location = CLLocation(latitude: 39.9847, longitude: 116.3184)
            let currentDate = Date()
            
            do {
                let weather = try await weatherService.fetchWeather(for: location)
                let plan = engine.generateOutfit(
                    for: weather,
                    preference: .neutral,
                    wardrobe: WardrobeDefaults.initialItems,
                    shuffleSeed: 0
                )

                let names = plan.allItems.map { $0.name }
                let symbols = plan.allItems.map { $0.iconName.isEmpty ? $0.category.sfSymbol : $0.iconName }

                let entry = OutfitWidgetEntry(
                    date: currentDate,
                    cityName: "北京",
                    temperature: weather.temperature,
                    apparentTemperature: weather.apparentTemperature,
                    dailyHigh: weather.dailyHigh,
                    dailyLow: weather.dailyLow,
                    symbolName: weather.symbolName,
                    conditionDescription: weather.conditionDescription,
                    dressingLevelName: plan.level.rawValue,
                    dressingLevelAccentHex: "#008080",
                    outfitItemNames: names,
                    outfitItemSymbols: symbols,
                    adviceSummary: plan.adviceSummary
                )

                // 每 1 小时自动请求刷新一次天气与穿搭
                let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate.addingTimeInterval(3600)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                // 失败时使用兜底数据，半小时后重试
                let fallback = OutfitWidgetEntry(date: currentDate)
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate) ?? currentDate.addingTimeInterval(1800)
                let timeline = Timeline(entries: [fallback], policy: .after(nextUpdate))
                completion(timeline)
            }
        }
    }
}

/// 桌面小组件入口声明
public struct OutfitOracleWidget: Widget {
    public let kind: String = "OutfitOracleWidget"

    public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OutfitTimelineProvider()) { entry in
            OutfitWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("OutfitOracle 穿搭")
        .description("在桌面上随时查看当地天气与智能衣着搭配。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
