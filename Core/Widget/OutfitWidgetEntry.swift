import Foundation
import WidgetKit
import SwiftUI

/// 桌面小组件时间线数据实体 (TimelineEntry)
public struct OutfitWidgetEntry: TimelineEntry, Sendable {
    public let date: Date
    public let cityName: String
    public let temperature: Double
    public let apparentTemperature: Double
    public let dailyHigh: Double
    public let dailyLow: Double
    public let symbolName: String
    public let conditionDescription: String
    public let dressingLevelName: String
    public let dressingLevelAccentHex: String
    public let outfitItemNames: [String]
    public let outfitItemSymbols: [String]
    public let adviceSummary: String

    public init(
        date: Date = Date(),
        cityName: String = "北京",
        temperature: Double = 20.0,
        apparentTemperature: Double = 19.5,
        dailyHigh: Double = 23.0,
        dailyLow: Double = 12.0,
        symbolName: String = "sun.max.fill",
        conditionDescription: String = "晴朗",
        dressingLevelName: String = "微凉春秋",
        dressingLevelAccentHex: String = "#008080",
        outfitItemNames: [String] = ["长袖打底衫", "工装夹克", "直筒牛仔裤"],
        outfitItemSymbols: [String] = ["tshirt.fill", "jacket.fill", "figure.walk"],
        adviceSummary: String = "早晚温差较大，建议备好轻便外套。"
    ) {
        self.date = date
        self.cityName = cityName
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.dailyHigh = dailyHigh
        self.dailyLow = dailyLow
        self.symbolName = symbolName
        self.conditionDescription = conditionDescription
        self.dressingLevelName = dressingLevelName
        self.dressingLevelAccentHex = dressingLevelAccentHex
        self.outfitItemNames = outfitItemNames
        self.outfitItemSymbols = outfitItemSymbols
        self.adviceSummary = adviceSummary
    }

    /// 占位预览示例
    public static var placeholder: OutfitWidgetEntry {
        OutfitWidgetEntry()
    }
}
