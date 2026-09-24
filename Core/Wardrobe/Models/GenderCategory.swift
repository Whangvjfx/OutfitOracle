import Foundation

/// 性别偏好分类
public enum GenderCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case unisex = "通用风格"
    case men = "男士风尚"
    case women = "女士优雅"

    public var id: String { rawValue }

    public var iconSymbol: String {
        switch self {
        case .unisex: return "person.2.fill"
        case .men: return "figure.stand"
        case .women: return "figure.stand.dress"
        }
    }
}
