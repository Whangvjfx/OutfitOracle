import Foundation

/// 核心穿搭推荐引擎 (Outfit Recommendation Engine)
public final class OutfitRecommendationEngine: Sendable {
    
    public init() {}

    /// 核心计算推荐方案
    /// - Parameters:
    ///   - weather: 天气快照
    ///   - preference: 用户个人冷热体质偏好
    ///   - gender: 性别搭配倾向 (.unisex, .men, .women)
    ///   - wardrobe: 可用衣橱单品池
    ///   - shuffleSeed: 随机种子序号（用于支持“换一套”刷新功能）
    public func generateOutfit(
        for weather: WeatherSnapshot,
        preference: ThermalPreference = .neutral,
        gender: GenderCategory = .men,
        wardrobe: [ClothingItem],
        shuffleSeed: Int = 0
    ) -> OutfitPlan {
        // 1. 体感温度校准
        let calibratedTemp = weather.apparentTemperature + preference.temperatureOffset
        let level = DressingLevel.from(apparentTemperature: calibratedTemp)

        // 2. 温差与特殊气候判定
        let diurnalRange = weather.dailyHigh - weather.dailyLow
        let isLargeDiurnalRange = diurnalRange >= 8.0
        let isRainy = weather.precipitationChance >= 0.35
        let isWindy = weather.windSpeed >= 5.0

        // 3. 构建贴心建议文本
        var adviceParts: [String] = []
        if isLargeDiurnalRange {
            adviceParts.append("今日早晚温差达 \(Int(round(diurnalRange)))°C（最高 \(Int(round(weather.dailyHigh)))°C / 最低 \(Int(round(weather.dailyLow)))°C），全天务必采用洋葱叠穿法，早晚穿好外套，中午适度减衣。")
        }
        if isRainy {
            adviceParts.append("降水概率 \(Int(weather.precipitationChance * 100))%，外出请携带雨伞并选防泼水外衣。")
        }
        if isWindy {
            adviceParts.append("户外风力较大(\(String(format: "%.1f", weather.windSpeed))m/s)，外层衣物注重领口防风。")
        }
        if adviceParts.isEmpty {
            adviceParts.append("全天体感舒适(约 \(String(format: "%.1f", calibratedTemp))°C)，气候平稳宜人。")
        }
        let adviceSummary = adviceParts.joined(separator: " ")

        // 4. 按性别与适穿温度筛选候选单品
        let inners = selectCandidates(category: .inner, temp: calibratedTemp, gender: gender, wardrobe: wardrobe)
        let mids = selectCandidates(category: .midLayer, temp: calibratedTemp, gender: gender, wardrobe: wardrobe)
        let outers = selectCandidates(category: .outer, temp: calibratedTemp, gender: gender, wardrobe: wardrobe)
        let bottoms = selectCandidates(category: .bottom, temp: calibratedTemp, gender: gender, wardrobe: wardrobe)
        let accessories = wardrobe.filter { $0.category == .accessory && ($0.gender == .unisex || $0.gender == gender) }

        // 5. 根据穿衣等级匹配最终层叠单品组合
        let innerItem = pickItem(from: inners, fallbackCategory: .inner, gender: gender, wardrobe: wardrobe, seed: shuffleSeed)

        var midLayerItem: ClothingItem? = nil
        var outerItem: ClothingItem? = nil

        switch level {
        case .freezing:
            // 极寒：加厚保暖中层 + 加厚保暖外套
            midLayerItem = pickItem(from: mids, fallbackCategory: .midLayer, gender: gender, wardrobe: wardrobe, seed: shuffleSeed)
            outerItem = pickItem(from: outers, fallbackCategory: .outer, gender: gender, wardrobe: wardrobe, seed: shuffleSeed)

        case .cold:
            // 寒冷：中层 或 厚外套（温差大或低温皆备）
            if calibratedTemp < 6.0 || isLargeDiurnalRange {
                midLayerItem = pickItem(from: mids, fallbackCategory: .midLayer, gender: gender, wardrobe: wardrobe, seed: shuffleSeed)
            }
            outerItem = pickItem(from: outers, fallbackCategory: .outer, gender: gender, wardrobe: wardrobe, seed: shuffleSeed)

        case .cool:
            // 微凉春秋：轻便外套必备；早晚温差大备薄中层
            if isLargeDiurnalRange {
                midLayerItem = pickItem(from: mids, fallbackCategory: .midLayer, gender: gender, wardrobe: wardrobe, seed: shuffleSeed)
            }
            outerItem = pickItem(from: outers, fallbackCategory: .outer, gender: gender, wardrobe: wardrobe, seed: shuffleSeed)

        case .comfortable:
            // 舒适：通常单穿内搭（如短袖/衬衫）；若早晚温差大，搭配一件随身轻薄开衫或夹克
            if isLargeDiurnalRange {
                outerItem = pickItem(from: outers, fallbackCategory: .outer, gender: gender, wardrobe: wardrobe, seed: shuffleSeed)
            }

        case .hot:
            // 炎热：无需中层与外套
            midLayerItem = nil
            outerItem = nil
        }

        let bottomItem = pickItem(from: bottoms, fallbackCategory: .bottom, gender: gender, wardrobe: wardrobe, seed: shuffleSeed)

        // 6. 配件智能选取
        var accessoryItem: ClothingItem? = nil
        if isRainy {
            accessoryItem = accessories.first(where: { $0.isWaterproof || $0.name.contains("伞") })
        } else if level == .freezing {
            accessoryItem = accessories.first(where: { $0.name.contains("雷锋帽") || $0.name.contains("围巾") || $0.warmthScore >= 4 })
        } else if level == .hot {
            accessoryItem = accessories.first(where: { $0.name.contains("帽") })
        }

        // 7. 计算一天内分时段穿衣建议 (早、中、晚、夜)
        let periodAdvices = calculateDaytimePeriods(weather: weather, level: level, hasOuter: outerItem != nil, innerName: innerItem.name)

        return OutfitPlan(
            level: level,
            calculatedApparentTemp: calibratedTemp,
            inner: innerItem,
            midLayer: midLayerItem,
            outer: outerItem,
            bottom: bottomItem,
            accessory: accessoryItem,
            adviceSummary: adviceSummary,
            periodAdvices: periodAdvices
        )
    }

    // MARK: - 24小时与一天内分时段动态穿衣建议计算

    private func calculateDaytimePeriods(weather: WeatherSnapshot, level: DressingLevel, hasOuter: Bool, innerName: String) -> [DaytimePeriodAdvice] {
        let low = weather.dailyLow
        let high = weather.dailyHigh
        
        // 估算或根据 hourly 计算各时段体感
        let morningTemp = (low * 0.7 + high * 0.3)
        let noonTemp = high
        let eveningTemp = (low * 0.4 + high * 0.6)
        let nightTemp = low

        var periods: [DaytimePeriodAdvice] = []

        // 1. 早晨通勤 (07:00 ~ 10:00)
        let morningAction = hasOuter ? "晨起凉爽有风，出门请穿好外套，拉好拉链" : "早起稍凉，建议单穿长袖打底"
        periods.append(
            DaytimePeriodAdvice(
                periodName: "早晨通勤",
                timeRange: "07:00 ~ 10:00",
                iconSymbol: "sunrise.fill",
                averageApparentTemp: morningTemp,
                dressingAction: morningAction,
                details: "气温较低(约\(Int(round(morningTemp)))°C)，避免迎风直吹受凉。"
            )
        )

        // 2. 午间暖阳 (11:00 ~ 15:00)
        let noonAction = hasOuter ? "午间升温，可解开或脱下外套，露出内搭(\(innerName))" : "全天最温暖时刻，单穿即可，舒适透气"
        periods.append(
            DaytimePeriodAdvice(
                periodName: "午间暖阳",
                timeRange: "11:00 ~ 15:00",
                iconSymbol: "sun.max.fill",
                averageApparentTemp: noonTemp,
                dressingAction: noonAction,
                details: "体感回升至\(Int(round(noonTemp)))°C，阳光充足，活动时避免出汗闷热。"
            )
        )

        // 3. 傍晚归途 (17:00 ~ 20:00)
        let eveningAction = hasOuter ? "太阳落山气温快速下降，出门归途请重新穿上外套" : "傍晚起风，注意防微凉"
        periods.append(
            DaytimePeriodAdvice(
                periodName: "傍晚归途",
                timeRange: "17:00 ~ 20:00",
                iconSymbol: "sunset.fill",
                averageApparentTemp: eveningTemp,
                dressingAction: eveningAction,
                details: "降温至\(Int(round(eveningTemp)))°C左右，特别是下班/放学途中容易受风寒。"
            )
        )

        // 4. 夜间静谧 (21:00 ~ 06:00)
        periods.append(
            DaytimePeriodAdvice(
                periodName: "夜间静谧",
                timeRange: "21:00 ~ 06:00",
                iconSymbol: "moon.stars.fill",
                averageApparentTemp: nightTemp,
                dressingAction: "全天最低温(\(Int(round(nightTemp)))°C)，夜间外出需加倍保暖",
                details: "深夜气温触底，居家休息注意室内保暖与关窗。"
            )
        )

        return periods
    }

    // MARK: - 辅助筛选逻辑

    private func selectCandidates(category: ClothingCategory, temp: Double, gender: GenderCategory, wardrobe: [ClothingItem]) -> [ClothingItem] {
        return wardrobe.filter { item in
            item.category == category && item.isSuitable(for: temp, preferredGender: gender)
        }
    }

    private func pickItem(from candidates: [ClothingItem], fallbackCategory: ClothingCategory, gender: GenderCategory, wardrobe: [ClothingItem], seed: Int) -> ClothingItem {
        if !candidates.isEmpty {
            let index = abs(seed) % candidates.count
            return candidates[index]
        }
        
        let allCategoryItems = wardrobe.filter { $0.category == fallbackCategory && ($0.gender == .unisex || $0.gender == gender) }
        if let fallback = allCategoryItems.first {
            return fallback
        }

        return ClothingItem(
            name: "精选\(fallbackCategory.rawValue)",
            category: fallbackCategory,
            gender: gender,
            minApparentTemp: -50,
            maxApparentTemp: 50,
            iconName: fallbackCategory.sfSymbol
        )
    }
}
