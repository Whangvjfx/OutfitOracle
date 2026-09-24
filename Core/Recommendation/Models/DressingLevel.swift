import Foundation
import SwiftUI

/// 穿衣等级分类系统（根据体感温度 Apparent Temperature 划分）
public enum DressingLevel: String, CaseIterable, Identifiable, Sendable {
    case freezing = "极寒严冬"    // < 0°C
    case cold = "寒冷冬日"        // 0°C ~ 11°C
    case cool = "微凉春秋"        // 11°C ~ 18°C
    case comfortable = "舒适宜人" // 18°C ~ 25°C
    case hot = "炎炎夏日"         // > 25°C

    public var id: String { rawValue }

    /// 根据体感温度计算所属穿衣等级
    public static func from(apparentTemperature: Double) -> DressingLevel {
        switch apparentTemperature {
        case ..<0:
            return .freezing
        case 0..<11:
            return .cold
        case 11..<18:
            return .cool
        case 18..<25:
            return .comfortable
        default:
            return .hot
        }
    }

    /// 核心层叠方案建议
    public var layeringRule: String {
        switch self {
        case .freezing:
            return "四层防冻：保暖内衣 + 保暖毛衣/抓绒 + 加厚羽绒服 + 保暖防风裤"
        case .cold:
            return "三层御寒：长袖打底 + 卫衣/轻羽绒/毛呢大衣 + 长裤"
        case .cool:
            return "双层温控：长袖T/衬衫 + 夹克/风衣/牛仔外套 + 休闲长裤"
        case .comfortable:
            return "单层舒适：透气短袖或长袖单衣 + 舒适单裤（早晚可备轻薄开衫）"
        case .hot:
            return "轻量透气：吸汗短袖/背心 + 透气短裤/薄裙"
        }
    }

    /// 主题色彩
    public var accentColor: Color {
        switch self {
        case .freezing: return .cyan
        case .cold: return .blue
        case .cool: return .teal
        case .comfortable: return .green
        case .hot: return .orange
        }
    }

    /// 象征性天气/穿搭图标
    public var iconSymbol: String {
        switch self {
        case .freezing: return "snowflake"
        case .cold: return "thermometer.snowflake"
        case .cool: return "wind"
        case .comfortable: return "sun.max"
        case .hot: return "sun.max.trianglebadge.exclamationmark.fill"
        }
    }
}
