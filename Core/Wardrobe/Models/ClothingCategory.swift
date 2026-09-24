import Foundation

/// 衣物层级分类枚举
public enum ClothingCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case inner = "内搭"       // T恤、保暖内衣、衬衫等贴身衣物
    case midLayer = "中层"    // 卫衣、毛衣、开衫、抓绒等保暖过渡
    case outer = "外套"       // 夹克、风衣、羽绒服、大衣等防风保暖
    case bottom = "下装"      // 短裤、牛仔裤、休闲裤、保暖裤等
    case accessory = "配件"   // 雨伞、围巾、冷帽、太阳镜等

    public var id: String { rawValue }

    public var sfSymbol: String {
        switch self {
        case .inner: return "tshirt.fill"
        case .midLayer: return "hanger"
        case .outer: return "jacket.fill"
        case .bottom: return "figure.walk"
        case .accessory: return "umbrella.fill"
        }
    }
}
