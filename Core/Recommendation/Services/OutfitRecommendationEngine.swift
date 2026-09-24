import Foundation

/// 核心穿搭推荐引擎 (Outfit Recommendation Engine)
public final class OutfitRecommendationEngine: Sendable {
    
    public init() {}

    /// 核心计算推荐方案
    /// - Parameters:
    ///   - weather: 天气快照
    ///   - preference: 用户个人冷热体质偏好
    ///   - wardrobe: 可用衣橱单品池
    ///   - shuffleSeed: 随机种子序号（用于支持“换一批”刷新功能）
    public func generateOutfit(
        for weather: WeatherSnapshot,
        preference: ThermalPreference = .neutral,
        wardrobe: [ClothingItem],
        shuffleSeed: Int = 0
    ) -> OutfitPlan {
        // 1. 体感温度校准（根据冷热偏好进行平移）
        let calibratedTemp = weather.apparentTemperature + preference.temperatureOffset
        let level = DressingLevel.from(apparentTemperature: calibratedTemp)

        // 2. 温差与特殊气候判定
        let diurnalRange = weather.dailyHigh - weather.dailyLow
        let isLargeDiurnalRange = diurnalRange >= 9.0
        let isRainy = weather.precipitationChance >= 0.35
        let isWindy = weather.windSpeed >= 5.0

        // 3. 构建贴心建议文本
        var adviceParts: [String] = []
        if isLargeDiurnalRange {
            adviceParts.append("今日温差达 \(Int(round(diurnalRange)))°C（最高 \(Int(round(weather.dailyHigh)))°C / 最低 \(Int(round(weather.dailyLow)))°C），推荐洋葱穿衣法，备好易穿脱外套。")
        }
        if isRainy {
            adviceParts.append("降水概率 \(Int(weather.precipitationChance * 100))%，外出备好雨伞并优先选防泼水外衣。")
        }
        if isWindy {
            adviceParts.append("风力较强(\(String(format: "%.1f", weather.windSpeed))m/s)，外层衣物注重防风御寒。")
        }
        if adviceParts.isEmpty {
            adviceParts.append("全天气温适中，体感约 \(String(format: "%.1f", calibratedTemp))°C，请随心出行。")
        }
        let adviceSummary = adviceParts.joined(separator: " ")

        // 4. 按层级筛选适穿候选单品
        let inners = selectCandidates(category: .inner, temp: calibratedTemp, wardrobe: wardrobe)
        let mids = selectCandidates(category: .midLayer, temp: calibratedTemp, wardrobe: wardrobe)
        let outers = selectCandidates(category: .outer, temp: calibratedTemp, wardrobe: wardrobe)
        let bottoms = selectCandidates(category: .bottom, temp: calibratedTemp, wardrobe: wardrobe)
        let accessories = wardrobe.filter { $0.category == .accessory }

        // 5. 根据穿衣等级匹配最终层叠单品组合
        let innerItem = pickItem(from: inners, fallbackCategory: .inner, wardrobe: wardrobe, seed: shuffleSeed)

        var midLayerItem: ClothingItem? = nil
        var outerItem: ClothingItem? = nil

        switch level {
        case .freezing:
            // 极寒：必选中层 + 必选加厚外套
            midLayerItem = pickItem(from: mids, fallbackCategory: .midLayer, wardrobe: wardrobe, seed: shuffleSeed)
            outerItem = pickItem(from: outers, fallbackCategory: .outer, wardrobe: wardrobe, seed: shuffleSeed)

        case .cold:
            // 寒冷：中层 或 厚外套（若有温差或较低温则两者皆备）
            if calibratedTemp < 6.0 || isLargeDiurnalRange {
                midLayerItem = pickItem(from: mids, fallbackCategory: .midLayer, wardrobe: wardrobe, seed: shuffleSeed)
            }
            outerItem = pickItem(from: outers, fallbackCategory: .outer, wardrobe: wardrobe, seed: shuffleSeed)

        case .cool:
            // 微凉春秋：轻外套必备；若早晚温差极大备一件薄中层
            if isLargeDiurnalRange {
                midLayerItem = pickItem(from: mids, fallbackCategory: .midLayer, wardrobe: wardrobe, seed: shuffleSeed)
            }
            outerItem = pickItem(from: outers, fallbackCategory: .outer, wardrobe: wardrobe, seed: shuffleSeed)

        case .comfortable:
            // 舒适：通常单层内搭；若早晚温差大，搭配一件随身轻薄外套
            if isLargeDiurnalRange {
                outerItem = pickItem(from: outers, fallbackCategory: .outer, wardrobe: wardrobe, seed: shuffleSeed)
            }

        case .hot:
            // 炎热：无需中层与外套
            midLayerItem = nil
            outerItem = nil
        }

        let bottomItem = pickItem(from: bottoms, fallbackCategory: .bottom, wardrobe: wardrobe, seed: shuffleSeed)

        // 6. 配件智能选取（雨天选伞、极寒选围巾、炎热选遮阳帽）
        var accessoryItem: ClothingItem? = nil
        if isRainy {
            accessoryItem = accessories.first(where: { $0.isWaterproof || $0.name.contains("伞") })
        } else if level == .freezing {
            accessoryItem = accessories.first(where: { $0.name.contains("围巾") || $0.warmthScore >= 4 })
        } else if level == .hot {
            accessoryItem = accessories.first(where: { $0.name.contains("帽") })
        }

        return OutfitPlan(
            level: level,
            calculatedApparentTemp: calibratedTemp,
            inner: innerItem,
            midLayer: midLayerItem,
            outer: outerItem,
            bottom: bottomItem,
            accessory: accessoryItem,
            adviceSummary: adviceSummary
        )
    }

    // MARK: - 辅助筛选逻辑

    private func selectCandidates(category: ClothingCategory, temp: Double, wardrobe: [ClothingItem]) -> [ClothingItem] {
        return wardrobe.filter { $0.category == category && $0.isSuitable(for: temp) }
    }

    /// 从候选列表中抽取单品（支持轮询种子 seed，用于“换一批”）
    private func pickItem(from candidates: [ClothingItem], fallbackCategory: ClothingCategory, wardrobe: [ClothingItem], seed: Int) -> ClothingItem {
        if !candidates.isEmpty {
            let index = abs(seed) % candidates.count
            return candidates[index]
        }
        
        // 兜底：若当前温度区间无对应单品，取该分类最接近的单品，避免崩溃
        let allCategoryItems = wardrobe.filter { $0.category == fallbackCategory }
        if let fallback = allCategoryItems.first {
            return fallback
        }

        // 终极默认兜底对象
        return ClothingItem(
            name: "默认\(fallbackCategory.rawValue)",
            category: fallbackCategory,
            minApparentTemp: -50,
            maxApparentTemp: 50,
            iconName: fallbackCategory.sfSymbol
        )
    }
}
