import Foundation
import Observation
import SwiftData

/// 阶段 2 穿搭算法与衣橱模型测试 ViewModel
@Observable
public final class RecommendationTestViewModel {
    // 算法测试输入参数
    public var apparentTemperature: Double = 16.0
    public var dailyHigh: Double = 22.0
    public var dailyLow: Double = 10.0
    public var precipitationChance: Double = 0.15
    public var windSpeed: Double = 2.5
    
    // 用户偏好与随机轮换种子
    public var preference: ThermalPreference = .neutral
    public var shuffleSeed: Int = 0

    // 计算结果
    public var currentPlan: OutfitPlan?
    public var wardrobeItems: [ClothingItem] = []

    private let engine = OutfitRecommendationEngine()

    public init() {
        // 初始化载入预置衣橱单品
        self.wardrobeItems = WardrobeDefaults.initialItems
        recalculate()
    }

    /// 根据当前天气与偏好重新计算穿搭方案
    public func recalculate() {
        let simulatedWeather = WeatherSnapshot(
            temperature: apparentTemperature,
            apparentTemperature: apparentTemperature,
            dailyHigh: dailyHigh,
            dailyLow: dailyLow,
            precipitationChance: precipitationChance,
            humidity: 0.5,
            windSpeed: windSpeed,
            conditionDescription: precipitationChance > 0.4 ? "有雨" : "晴朗",
            symbolName: precipitationChance > 0.4 ? "cloud.rain.fill" : "sun.max.fill"
        )

        self.currentPlan = engine.generateOutfit(
            for: simulatedWeather,
            preference: preference,
            wardrobe: wardrobeItems,
            shuffleSeed: shuffleSeed
        )
    }

    /// 点击“换一批”功能
    public func shuffle() {
        shuffleSeed += 1
        recalculate()
    }

    /// 从 Phase 1 的真实天气同步数据并立即计算
    public func syncFromWeatherSnapshot(_ snapshot: WeatherSnapshot) {
        self.apparentTemperature = snapshot.apparentTemperature
        self.dailyHigh = snapshot.dailyHigh
        self.dailyLow = snapshot.dailyLow
        self.precipitationChance = snapshot.precipitationChance
        self.windSpeed = snapshot.windSpeed
        recalculate()
    }
}
