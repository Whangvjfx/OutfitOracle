import Foundation

/// 一套完整的智能穿搭推荐方案
public struct OutfitPlan: Identifiable, Sendable {
    public let id = UUID()
    /// 所属穿衣等级
    public let level: DressingLevel
    /// 计算采用的基准体感温度
    public let calculatedApparentTemp: Double
    /// 匹配的内搭单品
    public let inner: ClothingItem
    /// 匹配的中层保暖单品（视温度而定，炎热/舒适时可为空）
    public let midLayer: ClothingItem?
    /// 匹配的外套单品（视温度而定，炎热时可为空）
    public let outer: ClothingItem?
    /// 匹配的下装单品
    public let bottom: ClothingItem
    /// 匹配的配件单品（如雨伞、围巾、帽子）
    public let accessory: ClothingItem?
    /// 贴心穿搭指导文案（包含早晚温差提示、降水防雨提示等）
    public let adviceSummary: String

    public init(
        level: DressingLevel,
        calculatedApparentTemp: Double,
        inner: ClothingItem,
        midLayer: ClothingItem?,
        outer: ClothingItem?,
        bottom: ClothingItem,
        accessory: ClothingItem?,
        adviceSummary: String
    ) {
        self.level = level
        self.calculatedApparentTemp = calculatedApparentTemp
        self.inner = inner
        self.midLayer = midLayer
        self.outer = outer
        self.bottom = bottom
        self.accessory = accessory
        self.adviceSummary = adviceSummary
    }

    /// 获取当前方案包含的所有非空单品数组（方便 UI 列表遍历展示）
    public var allItems: [ClothingItem] {
        var items: [ClothingItem] = [inner]
        if let mid = midLayer { items.append(mid) }
        if let out = outer { items.append(out) }
        items.append(bottom)
        if let acc = accessory { items.append(acc) }
        return items
    }
}
