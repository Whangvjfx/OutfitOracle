import Foundation

/// 用户体质冷热偏好
public enum ThermalPreference: String, Codable, CaseIterable, Identifiable, Sendable {
    case chillsEasily = "偏怕冷 (加衣倾向)"
    case neutral = "标准体质 (适中)"
    case sweatsEasily = "偏怕热 (轻薄倾向)"

    public var id: String { rawValue }

    /// 对体感温度的算法补偿偏移量（°C）
    /// 怕冷者：体感温度向下修正，使其触发更厚的衣物档位
    /// 怕热者：体感温度向上修正，使其触发更凉快的衣物档位
    public var temperatureOffset: Double {
        switch self {
        case .chillsEasily: return -2.5
        case .neutral: return 0.0
        case .sweatsEasily: return 2.5
        }
    }
}
