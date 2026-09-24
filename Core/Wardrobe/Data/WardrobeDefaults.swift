import Foundation

/// 预置海量四季与男女专属衣橱单品库（60+ 精品款式，特别针对哈尔滨极寒与全国四季）
public struct WardrobeDefaults {
    public static let initialItems: [ClothingItem] = [
        // ==========================================
        // 0. 用户个人实拍专属衣橱库 (18件核心私服，最高推荐权重)
        // ==========================================
        // [贴身内搭 / 短袖]
        ClothingItem(
            name: "黑色CURE艺术红框印花短T",
            category: .inner,
            gender: .men,
            visualStyle: "tshirt",
            colorHex: "#191A1E",
            minApparentTemp: 20.0,
            maxApparentTemp: 38.0,
            iconName: "tshirt.fill",
            warmthScore: 1,
            customCode: "79_38",
            brand: "CURE",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "黑色街头泼墨大印花短T",
            category: .inner,
            gender: .men,
            visualStyle: "tshirt",
            colorHex: "#18181A",
            minApparentTemp: 20.0,
            maxApparentTemp: 38.0,
            iconName: "tshirt.fill",
            warmthScore: 1,
            customCode: "82_38",
            brand: "街头潮牌",
            isDefaultItem: true
        ),

        // [保暖中层 / 卫衣与衬衫]
        ClothingItem(
            name: "杉杉军绿半拉链立领长袖卫衣",
            category: .midLayer,
            gender: .men,
            visualStyle: "sweater",
            colorHex: "#4E604A",
            minApparentTemp: 14.0,
            maxApparentTemp: 24.0,
            iconName: "figure.walk",
            warmthScore: 2,
            customCode: "66_38",
            brand: "杉杉 (FIRS)",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "阿迪达斯浅灰圆领长袖卫衣",
            category: .midLayer,
            gender: .men,
            visualStyle: "sweater",
            colorHex: "#CED2D8",
            minApparentTemp: 12.0,
            maxApparentTemp: 22.0,
            iconName: "figure.walk",
            warmthScore: 3,
            customCode: "68_38",
            brand: "Adidas",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "牛仔蓝白领假两件保暖毛衣",
            category: .midLayer,
            gender: .men,
            visualStyle: "sweater",
            colorHex: "#405E7A",
            minApparentTemp: 6.0,
            maxApparentTemp: 18.0,
            iconName: "person.bust",
            warmthScore: 4,
            customCode: "75_38",
            brand: "商务休闲",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "纯黑白领假两件保暖毛织衫",
            category: .midLayer,
            gender: .men,
            visualStyle: "sweater",
            colorHex: "#1C1C20",
            minApparentTemp: 6.0,
            maxApparentTemp: 18.0,
            iconName: "person.bust",
            warmthScore: 4,
            customCode: "80_38",
            brand: "商务休闲",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "海澜之家蓝黄细格磨毛衬衫夹克",
            category: .midLayer,
            gender: .men,
            visualStyle: "shirt",
            colorHex: "#384A58",
            minApparentTemp: 8.0,
            maxApparentTemp: 20.0,
            iconName: "tshirt.fill",
            warmthScore: 4,
            isWindproof: true,
            customCode: "76_38",
            brand: "海澜之家 (HLA)",
            isDefaultItem: true
        ),

        // [防风防寒外壳]
        ClothingItem(
            name: "卡其拼深灰机能连帽冲锋衣",
            category: .outer,
            gender: .men,
            visualStyle: "windbreaker",
            colorHex: "#C6AA86",
            minApparentTemp: 10.0,
            maxApparentTemp: 20.0,
            iconName: "wind",
            warmthScore: 3,
            isWaterproof: true,
            isWindproof: true,
            customCode: "69_38",
            brand: "机能工装",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "纯黑立领双横拉链保暖小棉服",
            category: .outer,
            gender: .men,
            visualStyle: "downJacket",
            colorHex: "#1E1F23",
            minApparentTemp: 4.0,
            maxApparentTemp: 16.0,
            iconName: "cloud.snow.fill",
            warmthScore: 4,
            isWindproof: true,
            customCode: "77_38",
            brand: "极简运动棉服",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "重磅黑色工装派克连帽大衣",
            category: .outer,
            gender: .men,
            visualStyle: "coat",
            colorHex: "#18181C",
            minApparentTemp: -5.0,
            maxApparentTemp: 12.0,
            iconName: "snowflake",
            warmthScore: 5,
            isWaterproof: true,
            isWindproof: true,
            customCode: "78_38",
            brand: "工装防寒",
            isDefaultItem: true
        ),

        // [夏日短裤]
        ClothingItem(
            name: "SHOH纯黑工装多袋系带短裤",
            category: .bottom,
            gender: .men,
            visualStyle: "shorts",
            colorHex: "#191A1E",
            minApparentTemp: 22.0,
            maxApparentTemp: 38.0,
            iconName: "figure.walk",
            warmthScore: 1,
            customCode: "67_38",
            brand: "SHOH",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "美式复古浅卡其棉质休闲短裤",
            category: .bottom,
            gender: .men,
            visualStyle: "shorts",
            colorHex: "#D6C4AE",
            minApparentTemp: 22.0,
            maxApparentTemp: 38.0,
            iconName: "figure.walk",
            warmthScore: 1,
            customCode: "71_38",
            brand: "复古休闲",
            isDefaultItem: true
        ),

        // [秋冬长裤]
        ClothingItem(
            name: "深灰薄款休闲垂坠抽绳长裤",
            category: .bottom,
            gender: .men,
            visualStyle: "pants",
            colorHex: "#2A2C30",
            minApparentTemp: 14.0,
            maxApparentTemp: 25.0,
            iconName: "figure.walk",
            warmthScore: 2,
            customCode: "70_38",
            brand: "舒适休闲",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "灰褐色工装细条纹灯芯绒长裤",
            category: .bottom,
            gender: .men,
            visualStyle: "pants",
            colorHex: "#6C645A",
            minApparentTemp: 4.0,
            maxApparentTemp: 18.0,
            iconName: "figure.walk",
            warmthScore: 4,
            isWindproof: true,
            customCode: "72_38",
            brand: "机能工装",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "斯凯奇深藏青抓绒运动卫裤",
            category: .bottom,
            gender: .men,
            visualStyle: "pants",
            colorHex: "#1E293B",
            minApparentTemp: 6.0,
            maxApparentTemp: 20.0,
            iconName: "figure.walk",
            warmthScore: 3,
            customCode: "73_38",
            brand: "Skechers",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "1977高街黑白印花束脚卫裤",
            category: .bottom,
            gender: .men,
            visualStyle: "pants",
            colorHex: "#18181B",
            minApparentTemp: 6.0,
            maxApparentTemp: 20.0,
            iconName: "figure.walk",
            warmthScore: 4,
            isWindproof: true,
            customCode: "74_38",
            brand: "1977",
            isDefaultItem: true
        ),
        ClothingItem(
            name: "经典深蓝宽松直筒纯棉牛仔长裤",
            category: .bottom,
            gender: .men,
            visualStyle: "jeans",
            colorHex: "#1E2E46",
            minApparentTemp: 8.0,
            maxApparentTemp: 25.0,
            iconName: "figure.walk",
            warmthScore: 3,
            isWindproof: true,
            customCode: "81_38",
            brand: "经典丹宁",
            isDefaultItem: true
        ),

        // ==========================================
        // 1. 系统通用扩展衣橱库
        // ==========================================
        // --- 极寒/寒冷保暖打底 ---
        ClothingItem(
            name: "德绒加厚双面发热内衣",
            category: .inner,
            gender: .unisex,
            visualStyle: "thermal",
            colorHex: "#374151",
            minApparentTemp: -40.0,
            maxApparentTemp: 3.0,
            iconName: "flame.fill",
            warmthScore: 5,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "美利奴羊毛高领打底衫",
            category: .inner,
            gender: .women,
            visualStyle: "thermal",
            colorHex: "#F3F4F6",
            minApparentTemp: -25.0,
            maxApparentTemp: 6.0,
            iconName: "tshirt.fill",
            warmthScore: 5,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "重磅磨毛长袖打底T恤",
            category: .inner,
            gender: .men,
            visualStyle: "thermal",
            colorHex: "#111827",
            minApparentTemp: -5.0,
            maxApparentTemp: 12.0,
            iconName: "tshirt.fill",
            warmthScore: 4,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "经典白圆领纯棉打底长袖",
            category: .inner,
            gender: .unisex,
            visualStyle: "tshirt",
            colorHex: "#FFFFFF",
            minApparentTemp: 5.0,
            maxApparentTemp: 18.0,
            iconName: "tshirt.fill",
            warmthScore: 3,
            isDefaultItem: true
        ),
        // --- 衬衫类 ---
        ClothingItem(
            name: "牛津纺经典纯白长袖衬衫",
            category: .inner,
            gender: .men,
            visualStyle: "shirt",
            colorHex: "#F9FAFB",
            minApparentTemp: 12.0,
            maxApparentTemp: 23.0,
            iconName: "briefcase.fill",
            warmthScore: 2,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "法式复古飘带长袖雪纺衬衫",
            category: .inner,
            gender: .women,
            visualStyle: "shirt",
            colorHex: "#EDE9FE",
            minApparentTemp: 14.0,
            maxApparentTemp: 25.0,
            iconName: "sparkles",
            warmthScore: 2,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "蓝色条纹休闲廓形衬衫",
            category: .inner,
            gender: .unisex,
            visualStyle: "shirt",
            colorHex: "#60A5FA",
            minApparentTemp: 15.0,
            maxApparentTemp: 24.0,
            iconName: "briefcase.fill",
            warmthScore: 2,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "日系水洗牛仔短袖衬衫",
            category: .inner,
            gender: .men,
            visualStyle: "shirt",
            colorHex: "#3B82F6",
            minApparentTemp: 18.0,
            maxApparentTemp: 28.0,
            iconName: "tshirt",
            warmthScore: 2,
            isDefaultItem: true
        ),
        // --- 短袖T恤与背心 ---
        ClothingItem(
            name: "重磅纯棉正肩白色短袖T恤",
            category: .inner,
            gender: .unisex,
            visualStyle: "tshirt",
            colorHex: "#FFFFFF",
            minApparentTemp: 18.0,
            maxApparentTemp: 35.0,
            iconName: "tshirt",
            warmthScore: 1,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "复古黑色宽松印花短袖T恤",
            category: .inner,
            gender: .men,
            visualStyle: "tshirt",
            colorHex: "#18181B",
            minApparentTemp: 19.0,
            maxApparentTemp: 36.0,
            iconName: "tshirt",
            warmthScore: 1,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "法式法兰绒修身短袖针织衫",
            category: .inner,
            gender: .women,
            visualStyle: "tshirt",
            colorHex: "#FDE68A",
            minApparentTemp: 18.0,
            maxApparentTemp: 29.0,
            iconName: "tshirt",
            warmthScore: 2,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "冰丝凉感浅灰短袖T恤",
            category: .inner,
            gender: .unisex,
            visualStyle: "tshirt",
            colorHex: "#E5E7EB",
            minApparentTemp: 24.0,
            maxApparentTemp: 42.0,
            iconName: "snowflake",
            warmthScore: 1,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "美式纯色螺纹无袖工装背心",
            category: .inner,
            gender: .men,
            visualStyle: "tshirt",
            colorHex: "#4B5563",
            minApparentTemp: 28.0,
            maxApparentTemp: 45.0,
            iconName: "sun.max.fill",
            warmthScore: 1,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "法式方领吊带针织背心",
            category: .inner,
            gender: .women,
            visualStyle: "tshirt",
            colorHex: "#FBCFE8",
            minApparentTemp: 27.0,
            maxApparentTemp: 45.0,
            iconName: "sun.max.fill",
            warmthScore: 1,
            isDefaultItem: true
        ),

        // ==========================================
        // 2. 保暖中层 (MidLayer) - 共 14 款
        // ==========================================
        ClothingItem(
            name: "粗棒针高领加厚绞花毛衣",
            category: .midLayer,
            gender: .unisex,
            visualStyle: "sweater",
            colorHex: "#FEF3C7",
            minApparentTemp: -40.0,
            maxApparentTemp: 5.0,
            iconName: "theatermasks.fill",
            warmthScore: 5,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "软糯马海毛落肩针织毛衣",
            category: .midLayer,
            gender: .women,
            visualStyle: "sweater",
            colorHex: "#DDD6FE",
            minApparentTemp: -20.0,
            maxApparentTemp: 10.0,
            iconName: "hanger",
            warmthScore: 4,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "户外摇粒绒保暖半拉链中层",
            category: .midLayer,
            gender: .unisex,
            visualStyle: "sweater",
            colorHex: "#4D7C0F",
            minApparentTemp: -15.0,
            maxApparentTemp: 8.0,
            iconName: "shield.fill",
            warmthScore: 4,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "复古水洗重磅连帽卫衣",
            category: .midLayer,
            gender: .men,
            visualStyle: "hoodie",
            colorHex: "#374151",
            minApparentTemp: -2.0,
            maxApparentTemp: 16.0,
            iconName: "figure.walk",
            warmthScore: 4,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "克莱因蓝圆领刺绣卫衣",
            category: .midLayer,
            gender: .unisex,
            visualStyle: "hoodie",
            colorHex: "#2563EB",
            minApparentTemp: 2.0,
            maxApparentTemp: 17.0,
            iconName: "figure.walk",
            warmthScore: 3,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "温柔奶杏色羊绒开衫",
            category: .midLayer,
            gender: .women,
            visualStyle: "sweater",
            colorHex: "#FDF4E3",
            minApparentTemp: 10.0,
            maxApparentTemp: 20.0,
            iconName: "hanger",
            warmthScore: 3,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "学院风V领撞色毛背心",
            category: .midLayer,
            gender: .unisex,
            visualStyle: "sweater",
            colorHex: "#1E3A8A",
            minApparentTemp: 12.0,
            maxApparentTemp: 22.0,
            iconName: "hanger",
            warmthScore: 2,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "轻薄防晒薄针织空调开衫",
            category: .midLayer,
            gender: .women,
            visualStyle: "sweater",
            colorHex: "#E0E7FF",
            minApparentTemp: 18.0,
            maxApparentTemp: 27.0,
            iconName: "sun.max",
            warmthScore: 1,
            isDefaultItem: true
        ),

        // ==========================================
        // 3. 防风外套 (Outer) - 共 16 款
        // ==========================================
        // --- 极寒严冬羽绒 (哈尔滨级抗寒) ---
        ClothingItem(
            name: "极地抗风暴长款加厚白鹅绒服",
            category: .outer,
            gender: .unisex,
            visualStyle: "downJacket",
            colorHex: "#0F172A",
            minApparentTemp: -45.0,
            maxApparentTemp: -5.0,
            iconName: "snowflake",
            warmthScore: 5,
            isWaterproof: true,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "女士收腰保暖中长款连帽羽绒服",
            category: .outer,
            gender: .women,
            visualStyle: "downJacket",
            colorHex: "#E2E8F0",
            minApparentTemp: -30.0,
            maxApparentTemp: 2.0,
            iconName: "snowflake",
            warmthScore: 5,
            isWaterproof: true,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "短款廓形立领面包羽绒服",
            category: .outer,
            gender: .unisex,
            visualStyle: "downJacket",
            colorHex: "#64748B",
            minApparentTemp: -18.0,
            maxApparentTemp: 6.0,
            iconName: "cloud.snow.fill",
            warmthScore: 4,
            isWindproof: true,
            isDefaultItem: true
        ),
        // --- 羊毛大衣 ---
        ClothingItem(
            name: "双排扣英伦经典羊毛呢大衣",
            category: .outer,
            gender: .men,
            visualStyle: "coat",
            colorHex: "#1E293B",
            minApparentTemp: -8.0,
            maxApparentTemp: 11.0,
            iconName: "star.fill",
            warmthScore: 4,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "法式系带水波纹双面呢长款大衣",
            category: .outer,
            gender: .women,
            visualStyle: "coat",
            colorHex: "#D97706",
            minApparentTemp: -6.0,
            maxApparentTemp: 12.0,
            iconName: "star.fill",
            warmthScore: 4,
            isWindproof: true,
            isDefaultItem: true
        ),
        // --- 冲锋衣与风衣 ---
        ClothingItem(
            name: "三合一可拆卸户外压胶冲锋衣",
            category: .outer,
            gender: .unisex,
            visualStyle: "windbreaker",
            colorHex: "#047857",
            minApparentTemp: -10.0,
            maxApparentTemp: 15.0,
            iconName: "shield.fill",
            warmthScore: 4,
            isWaterproof: true,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "英伦经典双排扣防风长风衣",
            category: .outer,
            gender: .unisex,
            visualStyle: "coat",
            colorHex: "#CA8A04",
            minApparentTemp: 6.0,
            maxApparentTemp: 19.0,
            iconName: "wind",
            warmthScore: 3,
            isWaterproof: true,
            isWindproof: true,
            isDefaultItem: true
        ),
        // --- 夹克与皮衣 ---
        ClothingItem(
            name: "复古水洗工装牛仔翻领夹克",
            category: .outer,
            gender: .unisex,
            visualStyle: "jacket",
            colorHex: "#2563EB",
            minApparentTemp: 10.0,
            maxApparentTemp: 21.0,
            iconName: "jacket.fill",
            warmthScore: 2,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "机车风真皮翻领立挺皮夹克",
            category: .outer,
            gender: .men,
            visualStyle: "jacket",
            colorHex: "#18181B",
            minApparentTemp: 8.0,
            maxApparentTemp: 18.0,
            iconName: "shield.fill",
            warmthScore: 3,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "美式复古拼色刺绣棒球服",
            category: .outer,
            gender: .unisex,
            visualStyle: "jacket",
            colorHex: "#1E3A8A",
            minApparentTemp: 9.0,
            maxApparentTemp: 19.0,
            iconName: "sportscourt.fill",
            warmthScore: 3,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "韩系宽松休闲小西装外套",
            category: .outer,
            gender: .women,
            visualStyle: "jacket",
            colorHex: "#52525B",
            minApparentTemp: 14.0,
            maxApparentTemp: 23.0,
            iconName: "briefcase.fill",
            warmthScore: 2,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "轻薄防泼水户外运动皮肤风衣",
            category: .outer,
            gender: .unisex,
            visualStyle: "windbreaker",
            colorHex: "#06B6D4",
            minApparentTemp: 17.0,
            maxApparentTemp: 26.0,
            iconName: "wind",
            warmthScore: 1,
            isWaterproof: true,
            isWindproof: true,
            isDefaultItem: true
        ),

        // ==========================================
        // 4. 裤装与下装 (Bottom) - 共 14 款
        // ==========================================
        // --- 极寒保暖裤 ---
        ClothingItem(
            name: "内加厚羊羔绒极地防风保暖长裤",
            category: .bottom,
            gender: .unisex,
            visualStyle: "pants",
            colorHex: "#1F2937",
            minApparentTemp: -40.0,
            maxApparentTemp: 2.0,
            iconName: "figure.walk",
            warmthScore: 5,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "加厚摇粒绒内衬微弹牛仔长裤",
            category: .bottom,
            gender: .unisex,
            visualStyle: "jeans",
            colorHex: "#1E3A8A",
            minApparentTemp: -20.0,
            maxApparentTemp: 8.0,
            iconName: "figure.walk",
            warmthScore: 4,
            isDefaultItem: true
        ),
        // --- 常规牛仔与休闲裤 ---
        ClothingItem(
            name: "经典复古水洗高腰直筒牛仔裤",
            category: .bottom,
            gender: .unisex,
            visualStyle: "jeans",
            colorHex: "#2563EB",
            minApparentTemp: 5.0,
            maxApparentTemp: 23.0,
            iconName: "figure.walk",
            warmthScore: 3,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "多口袋山系战术宽松工装裤",
            category: .bottom,
            gender: .men,
            visualStyle: "pants",
            colorHex: "#365314",
            minApparentTemp: 8.0,
            maxApparentTemp: 24.0,
            iconName: "figure.walk",
            warmthScore: 3,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "高腰垂感显瘦阔腿西装裤",
            category: .bottom,
            gender: .women,
            visualStyle: "pants",
            colorHex: "#374151",
            minApparentTemp: 10.0,
            maxApparentTemp: 25.0,
            iconName: "figure.stand",
            warmthScore: 2,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "纯棉重磅束脚宽松休闲运动卫裤",
            category: .bottom,
            gender: .unisex,
            visualStyle: "pants",
            colorHex: "#4B5563",
            minApparentTemp: 6.0,
            maxApparentTemp: 22.0,
            iconName: "figure.walk",
            warmthScore: 3,
            isDefaultItem: true
        ),
        // --- 裙装类 (女) ---
        ClothingItem(
            name: "加厚羊毛混纺高腰百褶半身长裙",
            category: .bottom,
            gender: .women,
            visualStyle: "skirt",
            colorHex: "#78350F",
            minApparentTemp: 0.0,
            maxApparentTemp: 16.0,
            iconName: "figure.stand.dress",
            warmthScore: 4,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "法式复古开叉牛仔A字长裙",
            category: .bottom,
            gender: .women,
            visualStyle: "skirt",
            colorHex: "#3B82F6",
            minApparentTemp: 14.0,
            maxApparentTemp: 26.0,
            iconName: "figure.stand.dress",
            warmthScore: 2,
            isDefaultItem: true
        ),
        // --- 夏季短裤与短裙 ---
        ClothingItem(
            name: "轻薄速干抽绳多口袋工装短裤",
            category: .bottom,
            gender: .men,
            visualStyle: "shorts",
            colorHex: "#52525B",
            minApparentTemp: 23.0,
            maxApparentTemp: 45.0,
            iconName: "sun.haze.fill",
            warmthScore: 1,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "韩系高腰百搭百褶短裙",
            category: .bottom,
            gender: .women,
            visualStyle: "skirt",
            colorHex: "#18181B",
            minApparentTemp: 23.0,
            maxApparentTemp: 44.0,
            iconName: "figure.stand.dress",
            warmthScore: 1,
            isDefaultItem: true
        ),

        // ==========================================
        // 5. 专属配件与鞋履 (Accessory) - 共 10 款
        // ==========================================
        ClothingItem(
            name: "东北加厚防风护耳毛绒雷锋帽",
            category: .accessory,
            gender: .unisex,
            visualStyle: "hat",
            colorHex: "#451A03",
            minApparentTemp: -45.0,
            maxApparentTemp: -8.0,
            iconName: "snowflake",
            warmthScore: 5,
            isWindproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "100%纯羊绒保暖流苏大围巾",
            category: .accessory,
            gender: .unisex,
            visualStyle: "scarf",
            colorHex: "#991B1B",
            minApparentTemp: -35.0,
            maxApparentTemp: 6.0,
            iconName: "scarf.fill",
            warmthScore: 5,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "加厚防滑保暖雪地靴",
            category: .accessory,
            gender: .unisex,
            visualStyle: "boots",
            colorHex: "#D97706",
            minApparentTemp: -40.0,
            maxApparentTemp: 0.0,
            iconName: "shoeprints.fill",
            warmthScore: 5,
            isWaterproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "便携黑胶超强抗风晴雨伞",
            category: .accessory,
            gender: .unisex,
            visualStyle: "umbrella",
            colorHex: "#1D4ED8",
            minApparentTemp: -40.0,
            maxApparentTemp: 45.0,
            iconName: "umbrella.fill",
            warmthScore: 1,
            isWaterproof: true,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "美式复古刺绣防晒棒球帽",
            category: .accessory,
            gender: .unisex,
            visualStyle: "hat",
            colorHex: "#1E293B",
            minApparentTemp: 18.0,
            maxApparentTemp: 45.0,
            iconName: "cap.fill",
            warmthScore: 1,
            isDefaultItem: true
        ),
        ClothingItem(
            name: "法式度假大檐草编遮阳帽",
            category: .accessory,
            gender: .women,
            visualStyle: "hat",
            colorHex: "#FEF08A",
            minApparentTemp: 24.0,
            maxApparentTemp: 45.0,
            iconName: "sun.max.fill",
            warmthScore: 1,
            isDefaultItem: true
        )
    ]
}
