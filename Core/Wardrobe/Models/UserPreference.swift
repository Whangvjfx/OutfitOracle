import Foundation

/// 用户体质冷热偏好
public enum ThermalPreference: String, Codable, CaseIterable, Identifiable, Sendable {
    case chillsEasily = "偏怕冷 (加衣倾向)"
    case neutral = "标准体质 (适中)"
    case sweatsEasily = "偏怕热 (轻薄倾向)"

    public var id: String { rawValue }

    public var temperatureOffset: Double {
        switch self {
        case .chillsEasily: return -2.5
        case .neutral: return 0.0
        case .sweatsEasily: return 2.5
        }
    }
}

/// 综合用户偏好配置
public struct UserProfilePreference: Codable, Sendable {
    public var thermalPreference: ThermalPreference
    public var genderPreference: GenderCategory

    public init(
        thermalPreference: ThermalPreference = .neutral,
        genderPreference: GenderCategory = .men
    ) {
        self.thermalPreference = thermalPreference
        self.genderPreference = genderPreference
    }
}
