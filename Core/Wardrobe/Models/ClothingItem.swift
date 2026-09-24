import Foundation
import SwiftData

/// SwiftData 衣橱单品数据模型 (iOS 17+)
@Model
public final class ClothingItem {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var categoryRaw: String
    public var minApparentTemp: Double   // 最低适用体感温度 (°C)
    public var maxApparentTemp: Double   // 最高适用体感温度 (°C)
    public var iconName: String          // SF Symbol 图标名 或 资产图片标识
    public var warmthScore: Int          // 保暖度评分 (1 ~ 5)
    public var isWaterproof: Bool        // 是否防水/抗雨
    public var isWindproof: Bool         // 是否防风
    public var isDefaultItem: Bool       // 是否为系统内置预置单品
    public var createdAt: Date

    public var category: ClothingCategory {
        get { ClothingCategory(rawValue: categoryRaw) ?? .inner }
        set { categoryRaw = newValue.rawValue }
    }

    public init(
        id: UUID = UUID(),
        name: String,
        category: ClothingCategory,
        minApparentTemp: Double,
        maxApparentTemp: Double,
        iconName: String,
        warmthScore: Int = 3,
        isWaterproof: Bool = false,
        isWindproof: Bool = false,
        isDefaultItem: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.categoryRaw = category.rawValue
        self.minApparentTemp = minApparentTemp
        self.maxApparentTemp = maxApparentTemp
        self.iconName = iconName
        self.warmthScore = warmthScore
        self.isWaterproof = isWaterproof
        self.isWindproof = isWindproof
        self.isDefaultItem = isDefaultItem
        self.createdAt = createdAt
    }

    /// 检查该单品是否适配指定的体感温度
    public func isSuitable(for apparentTemp: Double) -> Bool {
        return apparentTemp >= minApparentTemp && apparentTemp <= maxApparentTemp
    }
}
