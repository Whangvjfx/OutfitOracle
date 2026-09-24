import Foundation
import SwiftData

/// SwiftData 衣橱单品数据模型 (iOS 17+)
@Model
public final class ClothingItem {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var categoryRaw: String
    public var genderRaw: String         // 适用性别 (通用 / 男 / 女)
    public var visualStyle: String       // 具象剪裁形态 (tshirt, shirt, sweater, hoodie, downJacket, jacket, coat, windbreaker, jeans, pants, shorts, skirt, umbrella, scarf, hat)
    public var colorHex: String          // 服装主色调 (#FFFFFF, #1F2937, #2563EB 等)
    public var minApparentTemp: Double   // 最低适用体感温度 (°C)
    public var maxApparentTemp: Double   // 最高适用体感温度 (°C)
    public var iconName: String          // SF Symbol 图标名
    public var warmthScore: Int          // 保暖度评分 (1 ~ 5)
    public var isWaterproof: Bool        // 是否防水/抗雨
    public var isWindproof: Bool         // 是否防风
    public var customCode: String        // 用户专属私服编号 (如 "66_38", "79_38")
    public var brand: String             // 品牌 (杉杉, Adidas, HLA, Skechers 等)
    public var isDefaultItem: Bool       // 是否为系统内置预置单品
    public var createdAt: Date

    public var category: ClothingCategory {
        get { ClothingCategory(rawValue: categoryRaw) ?? .inner }
        set { categoryRaw = newValue.rawValue }
    }

    public var gender: GenderCategory {
        get { GenderCategory(rawValue: genderRaw) ?? .unisex }
        set { genderRaw = newValue.rawValue }
    }

    public init(
        id: UUID = UUID(),
        name: String,
        category: ClothingCategory,
        gender: GenderCategory = .unisex,
        visualStyle: String = "tshirt",
        colorHex: String = "#3B82F6",
        minApparentTemp: Double,
        maxApparentTemp: Double,
        iconName: String,
        warmthScore: Int = 3,
        isWaterproof: Bool = false,
        isWindproof: Bool = false,
        customCode: String = "",
        brand: String = "",
        isDefaultItem: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.categoryRaw = category.rawValue
        self.genderRaw = gender.rawValue
        self.visualStyle = visualStyle
        self.colorHex = colorHex
        self.minApparentTemp = minApparentTemp
        self.maxApparentTemp = maxApparentTemp
        self.iconName = iconName
        self.warmthScore = warmthScore
        self.isWaterproof = isWaterproof
        self.isWindproof = isWindproof
        self.customCode = customCode
        self.brand = brand
        self.isDefaultItem = isDefaultItem
        self.createdAt = createdAt
    }

    /// 检查该单品是否适配指定的体感温度与性别偏好
    public func isSuitable(for apparentTemp: Double, preferredGender: GenderCategory = .unisex) -> Bool {
        let tempMatch = apparentTemp >= minApparentTemp && apparentTemp <= maxApparentTemp
        let genderMatch = (self.gender == .unisex || preferredGender == .unisex || self.gender == preferredGender)
        return tempMatch && genderMatch
    }
}
