import Foundation

/// 系统预置的基础衣橱单品库（覆盖四季与各类天气场景）
public struct WardrobeDefaults {
    public static let initialItems: [ClothingItem] = [
        // --- 贴身内搭 (Inner) ---
        ClothingItem(
            name: "加厚发热保暖内衣",
            category: .inner,
            minApparentTemp: -30.0,
            maxApparentTemp: 5.0,
            iconName: "flame.fill",
            warmthScore: 5,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "长袖纯棉打底衫",
            category: .inner,
            minApparentTemp: 5.0,
            maxApparentTemp: 18.0,
            iconName: "tshirt.fill",
            warmthScore: 3,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "牛津纺长袖衬衫",
            category: .inner,
            minApparentTemp: 15.0,
            maxApparentTemp: 24.0,
            iconName: "briefcase.fill",
            warmthScore: 2,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "基础纯棉短袖T恤",
            category: .inner,
            minApparentTemp: 18.0,
            maxApparentTemp: 45.0,
            iconName: "tshirt",
            warmthScore: 1,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "速干透气无袖背心",
            category: .inner,
            minApparentTemp: 28.0,
            maxApparentTemp: 48.0,
            iconName: "sun.max.fill",
            warmthScore: 1,
            isDefaultItem: true
        ),

        // --- 保暖中层 (MidLayer) ---
        ClothingItem(
            name: "羊毛粗针厚毛衣",
            category: .midLayer,
            minApparentTemp: -30.0,
            maxApparentTemp: 8.0,
            iconName: "theatermasks.fill",
            warmthScore: 5,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "抓绒保暖连帽卫衣",
            category: .midLayer,
            minApparentTemp: 0.0,
            maxApparentTemp: 16.0,
            iconName: "figure.walk",
            warmthScore: 4,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "轻薄针织开衫",
            category: .midLayer,
            minApparentTemp: 14.0,
            maxApparentTemp: 22.0,
            iconName: "hanger",
            warmthScore: 2,
            isDefaultItem: true
        ),

        // --- 防风防寒外套 (Outer) ---
        ClothingItem(
            name: "极地防风加厚长款羽绒服",
            category: .outer,
            minApparentTemp: -35.0,
            maxApparentTemp: 0.0,
            iconName: "snowflake",
            warmthScore: 5,
            isWaterproof: true,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "短款轻便羽绒服",
            category: .outer,
            minApparentTemp: -2.0,
            maxApparentTemp: 10.0,
            iconName: "cloud.snow.fill",
            warmthScore: 4,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "羊毛毛呢经典大衣",
            category: .outer,
            minApparentTemp: 2.0,
            maxApparentTemp: 13.0,
            iconName: "star.fill",
            warmthScore: 4,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "工装防风立领夹克",
            category: .outer,
            minApparentTemp: 10.0,
            maxApparentTemp: 18.0,
            iconName: "shield.fill",
            warmthScore: 3,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "复古水洗牛仔外套",
            category: .outer,
            minApparentTemp: 12.0,
            maxApparentTemp: 20.0,
            iconName: "jacket.fill",
            warmthScore: 2,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "轻量透气户外风衣",
            category: .outer,
            minApparentTemp: 14.0,
            maxApparentTemp: 23.0,
            iconName: "wind",
            warmthScore: 2,
            isWaterproof: true,
            isWindproof: true,
            isDefaultItem: true
        ),

        // --- 舒适下装 (Bottom) ---
        ClothingItem(
            name: "内加厚摇粒绒保暖长裤",
            category: .bottom,
            minApparentTemp: -30.0,
            maxApparentTemp: 5.0,
            iconName: "figure.walk",
            warmthScore: 5,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "厚磅经典直筒牛仔裤",
            category: .bottom,
            minApparentTemp: 3.0,
            maxApparentTemp: 22.0,
            iconName: "figure.walk",
            warmthScore: 3,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "垂坠微弹休闲西裤",
            category: .bottom,
            minApparentTemp: 12.0,
            maxApparentTemp: 26.0,
            iconName: "figure.stand",
            warmthScore: 2,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "轻薄透气工装短裤",
            category: .bottom,
            minApparentTemp: 24.0,
            maxApparentTemp: 45.0,
            iconName: "sun.haze.fill",
            warmthScore: 1,
            isDefaultItem: true
        ),

        // --- 配件 (Accessory) ---
        ClothingItem(
            name: "羊绒防寒围巾",
            category: .accessory,
            minApparentTemp: -35.0,
            maxApparentTemp: 6.0,
            iconName: "scarf.fill",
            warmthScore: 5,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "便携抗风晴雨伞",
            category: .accessory,
            minApparentTemp: -35.0,
            maxApparentTemp: 45.0,
            iconName: "umbrella.fill",
            warmthScore: 1,
            isWaterproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "遮阳防晒棒球帽",
            category: .accessory,
            minApparentTemp: 22.0,
            maxApparentTemp: 45.0,
            iconName: "cap.fill",
            warmthScore: 1,
            isDefaultItem: true
        )
    ]
}
