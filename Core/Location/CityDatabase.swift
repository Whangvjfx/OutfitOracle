import Foundation
import CoreLocation

/// 城市数据结构实体
public struct CityModel: Identifiable, Hashable, Sendable, Codable {
    public let id: String
    public let name: String
    public let province: String
    public let region: String
    public let latitude: Double
    public let longitude: Double
    public let pinyin: String
    public let isHot: Bool

    public var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    public init(
        id: String = UUID().uuidString,
        name: String,
        province: String,
        region: String,
        latitude: Double,
        longitude: Double,
        pinyin: String,
        isHot: Bool = false
    ) {
        self.id = id
        self.name = name
        self.province = province
        self.region = region
        self.latitude = latitude
        self.longitude = longitude
        self.pinyin = pinyin
        self.isHot = isHot
    }
}

/// 全国主要城市数据库
public struct CityDatabase {
    /// 默认主打推荐城市：黑龙江省哈尔滨市
    public static let defaultHarbin = CityModel(
        name: "哈尔滨",
        province: "黑龙江",
        region: "东北地区",
        latitude: 45.7569,
        longitude: 126.6424,
        pinyin: "haerbin hrb",
        isHot: true
    )

    public static let allCities: [CityModel] = [
        // --- 东北地区（特别强化） ---
        defaultHarbin,
        CityModel(name: "齐齐哈尔", province: "黑龙江", region: "东北地区", latitude: 47.3543, longitude: 123.9182, pinyin: "qiqihaer qqhr"),
        CityModel(name: "牡丹江", province: "黑龙江", region: "东北地区", latitude: 44.5519, longitude: 129.6332, pinyin: "mudanjiang mdj"),
        CityModel(name: "大庆", province: "黑龙江", region: "东北地区", latitude: 46.5878, longitude: 125.1038, pinyin: "daqing dq"),
        CityModel(name: "佳木斯", province: "黑龙江", region: "东北地区", latitude: 46.7999, longitude: 130.3189, pinyin: "jiamusi jms"),
        CityModel(name: "长春", province: "吉林", region: "东北地区", latitude: 43.8171, longitude: 125.3235, pinyin: "changchun cc", isHot: true),
        CityModel(name: "吉林市", province: "吉林", region: "东北地区", latitude: 43.8378, longitude: 126.5494, pinyin: "jilin jl"),
        CityModel(name: "延吉", province: "吉林", region: "东北地区", latitude: 42.8913, longitude: 129.5089, pinyin: "yanji yj"),
        CityModel(name: "沈阳", province: "辽宁", region: "东北地区", latitude: 41.8057, longitude: 123.4315, pinyin: "shenyang sy", isHot: true),
        CityModel(name: "大连", province: "辽宁", region: "东北地区", latitude: 38.9140, longitude: 121.6147, pinyin: "dalian dl", isHot: true),
        CityModel(name: "鞍山", province: "辽宁", region: "东北地区", latitude: 41.1077, longitude: 122.9946, pinyin: "anshan as"),

        // --- 直辖市与华北地区 ---
        CityModel(name: "北京", province: "北京", region: "华北地区", latitude: 39.9042, longitude: 116.4074, pinyin: "beijing bj", isHot: true),
        CityModel(name: "天津", province: "天津", region: "华北地区", latitude: 39.0842, longitude: 117.2009, pinyin: "tianjin tj", isHot: true),
        CityModel(name: "石家庄", province: "河北", region: "华北地区", latitude: 38.0428, longitude: 114.5149, pinyin: "shijiazhuang sjz"),
        CityModel(name: "唐山", province: "河北", region: "华北地区", latitude: 39.6351, longitude: 118.1754, pinyin: "tangshan ts"),
        CityModel(name: "太原", province: "山西", region: "华北地区", latitude: 37.8706, longitude: 112.5489, pinyin: "taiyuan ty"),
        CityModel(name: "呼和浩特", province: "内蒙古", region: "华北地区", latitude: 40.8426, longitude: 111.7492, pinyin: "huhehaote hhht"),
        CityModel(name: "包头", province: "内蒙古", region: "华北地区", latitude: 40.6574, longitude: 109.8404, pinyin: "baotou bt"),

        // --- 华东地区 ---
        CityModel(name: "上海", province: "上海", region: "华东地区", latitude: 31.2304, longitude: 121.4737, pinyin: "shanghai sh", isHot: true),
        CityModel(name: "杭州", province: "浙江", region: "华东地区", latitude: 30.2741, longitude: 120.1551, pinyin: "hangzhou hz", isHot: true),
        CityModel(name: "宁波", province: "浙江", region: "华东地区", latitude: 29.8683, longitude: 121.5440, pinyin: "ningbo nb"),
        CityModel(name: "南京", province: "江苏", region: "华东地区", latitude: 32.0603, longitude: 118.7969, pinyin: "nanjing nj", isHot: true),
        CityModel(name: "苏州", province: "江苏", region: "华东地区", latitude: 31.2990, longitude: 120.5853, pinyin: "suzhou sz", isHot: true),
        CityModel(name: "无锡", province: "江苏", region: "华东地区", latitude: 31.4912, longitude: 120.3119, pinyin: "wuxi wx"),
        CityModel(name: "合肥", province: "安徽", region: "华东地区", latitude: 31.8206, longitude: 117.2272, pinyin: "hefei hf"),
        CityModel(name: "福州", province: "福建", region: "华东地区", latitude: 26.0745, longitude: 119.2965, pinyin: "fuzhou fz"),
        CityModel(name: "厦门", province: "福建", region: "华东地区", latitude: 24.4798, longitude: 118.0894, pinyin: "xiamen xm", isHot: true),
        CityModel(name: "南昌", province: "江西", region: "华东地区", latitude: 28.6829, longitude: 115.8582, pinyin: "nanchang nc"),
        CityModel(name: "济南", province: "山东", region: "华东地区", latitude: 36.6512, longitude: 117.1201, pinyin: "jinan jn"),
        CityModel(name: "青岛", province: "山东", region: "华东地区", latitude: 36.0671, longitude: 120.3826, pinyin: "qingdao qd", isHot: true),

        // --- 华南地区 ---
        CityModel(name: "广州", province: "广东", region: "华南地区", latitude: 23.1291, longitude: 113.2644, pinyin: "guangzhou gz", isHot: true),
        CityModel(name: "深圳", province: "广东", region: "华南地区", latitude: 22.5431, longitude: 114.0579, pinyin: "shenzhen sz", isHot: true),
        CityModel(name: "珠海", province: "广东", region: "华南地区", latitude: 22.2707, longitude: 113.5767, pinyin: "zhuhai zh"),
        CityModel(name: "南宁", province: "广西", region: "华南地区", latitude: 22.8170, longitude: 108.3665, pinyin: "nanning nn"),
        CityModel(name: "桂林", province: "广西", region: "华南地区", latitude: 25.2736, longitude: 110.2902, pinyin: "guilin gl"),
        CityModel(name: "海口", province: "海南", region: "华南地区", latitude: 20.0440, longitude: 110.1999, pinyin: "haikou hk"),
        CityModel(name: "三亚", province: "海南", region: "华南地区", latitude: 18.2528, longitude: 109.5119, pinyin: "sanya sy", isHot: true),

        // --- 华中地区 ---
        CityModel(name: "武汉", province: "湖北", region: "华中地区", latitude: 30.5928, longitude: 114.3055, pinyin: "wuhan wh", isHot: true),
        CityModel(name: "长沙", province: "湖南", region: "华中地区", latitude: 28.2282, longitude: 112.9388, pinyin: "changsha cs", isHot: true),
        CityModel(name: "郑州", province: "河南", region: "华中地区", latitude: 34.7466, longitude: 113.6253, pinyin: "zhengzhou zz", isHot: true),

        // --- 西南地区 ---
        CityModel(name: "成都", province: "四川", region: "西南地区", latitude: 30.5728, longitude: 104.0668, pinyin: "chengdu cd", isHot: true),
        CityModel(name: "重庆", province: "重庆", region: "西南地区", latitude: 29.5630, longitude: 106.5516, pinyin: "chongqing cq", isHot: true),
        CityModel(name: "贵阳", province: "贵州", region: "西南地区", latitude: 26.6470, longitude: 106.6302, pinyin: "guiyang gy"),
        CityModel(name: "昆明", province: "云南", region: "西南地区", latitude: 25.0406, longitude: 102.7129, pinyin: "kunming km", isHot: true),
        CityModel(name: "大理", province: "云南", region: "西南地区", latitude: 25.6065, longitude: 100.2676, pinyin: "dali dl"),
        CityModel(name: "拉萨", province: "西藏", region: "西南地区", latitude: 29.6525, longitude: 91.1721, pinyin: "lasa ls"),

        // --- 西北地区 ---
        CityModel(name: "西安", province: "陕西", region: "西北地区", latitude: 34.3416, longitude: 108.9398, pinyin: "xian xa", isHot: true),
        CityModel(name: "兰州", province: "甘肃", region: "西北地区", latitude: 36.0611, longitude: 103.8343, pinyin: "lanzhou lz"),
        CityModel(name: "西宁", province: "青海", region: "西北地区", latitude: 36.6209, longitude: 101.7801, pinyin: "xining xn"),
        CityModel(name: "银川", province: "宁夏", region: "西北地区", latitude: 38.4872, longitude: 106.2309, pinyin: "yinchuan yc"),
        CityModel(name: "乌鲁木齐", province: "新疆", region: "西北地区", latitude: 43.8256, longitude: 87.6168, pinyin: "wulumuqi wlmq", isHot: true)
    ]

    public static var hotCities: [CityModel] {
        allCities.filter { $0.isHot }
    }

    public static var groupedByRegion: [String: [CityModel]] {
        Dictionary(grouping: allCities, by: { $0.region })
    }
}
