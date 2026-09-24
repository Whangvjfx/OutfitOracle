import Foundation

/// 一天内分时段穿衣建议
public struct DaytimePeriodAdvice: Identifiable, Sendable {
    public let id = UUID()
    public let periodName: String      // 例如：早晨通勤、午间暖阳、傍晚归途、夜间防寒
    public let timeRange: String       // 例如：07:00 ~ 10:00
    public let iconSymbol: String      // sunrise.fill, sun.max.fill, sunset.fill, moon.stars.fill
    public let averageApparentTemp: Double // 平均体感温度
    public let dressingAction: String   // 穿衣动作：拉上外套、脱下外套仅穿短袖、添加围巾等
    public let details: String         // 详细建议

    public init(
        periodName: String,
        timeRange: String,
        iconSymbol: String,
        averageApparentTemp: Double,
        dressingAction: String,
        details: String
    ) {
        self.periodName = periodName
        self.timeRange = timeRange
        self.iconSymbol = iconSymbol
        self.averageApparentTemp = averageApparentTemp
        self.dressingAction = dressingAction
        self.details = details
    }
}

/// 一套完整的智能穿搭推荐方案
public struct OutfitPlan: Identifiable, Sendable {
    public let id = UUID()
    /// 所属穿衣等级
    public let level: DressingLevel
    /// 计算采用的基准体感温度
    public let calculatedApparentTemp: Double
    /// 匹配的内搭单品
    public let inner: ClothingItem
    /// 匹配的中层保暖单品
    public let midLayer: ClothingItem?
    /// 匹配的外套单品
    public let outer: ClothingItem?
    /// 匹配的下装单品
    public let bottom: ClothingItem
    /// 匹配的配件单品
    public let accessory: ClothingItem?
    /// 贴心穿搭指导文案
    public let adviceSummary: String
    /// 一天内各时段动态穿衣建议
    public let periodAdvices: [DaytimePeriodAdvice]

    public init(
        level: DressingLevel,
        calculatedApparentTemp: Double,
        inner: ClothingItem,
        midLayer: ClothingItem?,
        outer: ClothingItem?,
        bottom: ClothingItem,
        accessory: ClothingItem?,
        adviceSummary: String,
        periodAdvices: [DaytimePeriodAdvice] = []
    ) {
        self.level = level
        self.calculatedApparentTemp = calculatedApparentTemp
        self.inner = inner
        self.midLayer = midLayer
        self.outer = outer
        self.bottom = bottom
        self.accessory = accessory
        self.adviceSummary = adviceSummary
        self.periodAdvices = periodAdvices
    }

    /// 获取当前方案包含的所有非空单品数组
    public var allItems: [ClothingItem] {
        var items: [ClothingItem] = [inner]
        if let mid = midLayer { items.append(mid) }
        if let out = outer { items.append(out) }
        items.append(bottom)
        if let acc = accessory { items.append(acc) }
        return items
    }
}
