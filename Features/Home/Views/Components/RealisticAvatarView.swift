import SwiftUI

/// 高精度真实拟态人物穿搭画布引擎 (内置全部 18 款用户真实私服的具象矢量卡通渲染与层次遮挡)
public struct RealisticAvatarView: View {
    public let plan: OutfitPlan?
    public let weather: WeatherSnapshot?
    public let gender: GenderCategory
    public var isJacketOpen: Bool

    public init(
        plan: OutfitPlan?,
        weather: WeatherSnapshot?,
        gender: GenderCategory = .men,
        isJacketOpen: Bool = true
    ) {
        self.plan = plan
        self.weather = weather
        self.gender = gender
        self.isJacketOpen = isJacketOpen
    }

    // 肤色与发色常量 (柔和自然美学)
    private let skinColor = Color(red: 0.97, green: 0.88, blue: 0.83)
    private let skinShadowColor = Color(red: 0.91, green: 0.80, blue: 0.74)
    private let hairColor = Color(red: 0.15, green: 0.14, blue: 0.14)
    private let hairHighlightColor = Color(red: 0.22, green: 0.20, blue: 0.20)

    public var body: some View {
        ZStack {
            // 地台环境阴影
            avatarGroundShadow

            // 人物主体与层叠穿搭
            ZStack {
                // 1. 人体底模 (头发、五官、脸庞、脖颈、手臂、修长双腿与运动鞋履)
                bodyBaseSilhouette

                if let plan = plan {
                    // 2. 贴身内搭图层 (短袖T恤、打底衫，内穿短袖时小臂自然裸露，胸前印花清晰可见)
                    innerGarmentLayer(item: plan.inner)

                    // 3. 下装图层 (工装短裤、灯芯绒长裤、抽绳垂坠长裤、牛仔裤、卫裤)
                    bottomGarmentLayer(item: plan.bottom)

                    // 4. 保暖中层 (当无大外套，或叠穿在外套内侧时渲染)
                    if let mid = plan.midLayer {
                        midGarmentLayer(item: mid, isUnderJacket: plan.outer != nil)
                    }

                    // 5. 外套图层 (敞开式夹克/风衣/棉服大衣，绝不遮挡内搭，完美呈现“内穿短袖/毛衣，外穿外套”)
                    if let outer = plan.outer {
                        outerGarmentLayer(item: outer, innerItem: plan.inner, midItem: plan.midLayer)
                    }

                    // 6. 配件图层 (雨伞、围巾、帽子)
                    if let acc = plan.accessory {
                        accessoryGarmentLayer(item: acc)
                    }
                }
            }
            .frame(width: 230, height: 380)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 390)
    }

    // MARK: - 地台与环境阴影

    private var avatarGroundShadow: some View {
        VStack {
            Spacer()
            ZStack {
                Ellipse()
                    .fill(Color.black.opacity(0.08))
                    .frame(width: 150, height: 22)
                    .blur(radius: 6)
                Ellipse()
                    .fill(Color.black.opacity(0.12))
                    .frame(width: 95, height: 14)
                    .blur(radius: 3)
            }
            .offset(y: 8)
        }
    }

    // MARK: - 1. 人体底模骨架 (自然肩颈线条、俊朗发型、自然双腿与运动鞋)

    private var bodyBaseSilhouette: some View {
        ZStack {
            // 双腿与皮肤 (短裤时裸露膝盖与小腿)
            HStack(spacing: 24) {
                // 左腿
                TaperedLegShape()
                    .fill(skinColor)
                    .frame(width: 26, height: 165)
                // 右腿
                TaperedLegShape()
                    .fill(skinColor)
                    .frame(width: 26, height: 165)
                    .scaleEffect(x: -1, y: 1)
            }
            .offset(y: 105)

            // 现代白色复古运动球鞋
            HStack(spacing: 24) {
                shoeView
                shoeView
            }
            .offset(y: 182)

            // 躯干皮肤基底
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(skinColor)
                .frame(width: 82, height: 110)
                .offset(y: 12)

            // 脖颈
            Rectangle()
                .fill(skinShadowColor)
                .frame(width: 20, height: 26)
                .offset(y: -46)

            // 双手臂与手掌 (自然垂放于身体两侧，自然肩斜度)
            HStack(spacing: 96) {
                // 左臂与手
                VStack(spacing: 0) {
                    Capsule()
                        .fill(skinColor)
                        .frame(width: 14, height: 116)
                    Circle()
                        .fill(skinColor)
                        .frame(width: 15, height: 15)
                }
                // 右臂与手
                VStack(spacing: 0) {
                    Capsule()
                        .fill(skinColor)
                        .frame(width: 14, height: 116)
                    Circle()
                        .fill(skinColor)
                        .frame(width: 15, height: 15)
                }
            }
            .offset(y: 20)

            // 头脸轮廓与清爽五官
            VStack(spacing: 0) {
                ZStack {
                    // 耳朵
                    HStack(spacing: 48) {
                        Circle().fill(skinColor).frame(width: 10, height: 14)
                        Circle().fill(skinColor).frame(width: 10, height: 14)
                    }
                    .offset(y: 4)

                    // 脸部轮廓
                    Capsule()
                        .fill(skinColor)
                        .frame(width: 50, height: 58)
                        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)

                    // 眉眼自然神采
                    HStack(spacing: 12) {
                        Capsule().fill(Color(red: 0.25, green: 0.22, blue: 0.2)).frame(width: 6, height: 2.5)
                        Capsule().fill(Color(red: 0.25, green: 0.22, blue: 0.2)).frame(width: 6, height: 2.5)
                    }
                    .offset(y: -3)

                    HStack(spacing: 14) {
                        Circle().fill(Color(red: 0.18, green: 0.16, blue: 0.15)).frame(width: 4.5, height: 4.5)
                        Circle().fill(Color(red: 0.18, green: 0.16, blue: 0.15)).frame(width: 4.5, height: 4.5)
                    }
                    .offset(y: 4)

                    // 微笑
                    Circle()
                        .trim(from: 0.1, to: 0.4)
                        .stroke(Color(red: 0.8, green: 0.4, blue: 0.38), lineWidth: 1.6)
                        .frame(width: 11, height: 11)
                        .rotationEffect(.degrees(45))
                        .offset(y: 15)

                    // 层次立体发型
                    hairStyleView
                }
            }
            .offset(y: -76)
        }
    }

    private var hairStyleView: some View {
        Group {
            if gender == .women {
                // 女士温婉长发
                ZStack {
                    Capsule()
                        .fill(hairColor)
                        .frame(width: 54, height: 34)
                        .offset(y: -18)
                    HStack(spacing: 42) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(hairColor)
                            .frame(width: 13, height: 50)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(hairColor)
                            .frame(width: 13, height: 50)
                    }
                    .offset(y: 6)
                }
            } else {
                // 男士层次利落短发
                ZStack {
                    Capsule()
                        .fill(hairColor)
                        .frame(width: 54, height: 30)
                        .offset(y: -18)
                    // 发顶质感高光
                    Capsule()
                        .fill(hairHighlightColor)
                        .frame(width: 32, height: 10)
                        .offset(y: -24)
                    // 鬓角
                    HStack(spacing: 40) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(hairColor)
                            .frame(width: 8, height: 20)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(hairColor)
                            .frame(width: 8, height: 20)
                    }
                    .offset(y: -8)
                }
            }
        }
    }

    private var shoeView: some View {
        VStack(spacing: 0) {
            // 鞋面
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(Color.white)
                .frame(width: 27, height: 16)
                .overlay(
                    HStack(spacing: 2) {
                        Rectangle().fill(Color.gray.opacity(0.35)).frame(width: 1.5, height: 7)
                        Rectangle().fill(Color.gray.opacity(0.35)).frame(width: 1.5, height: 7)
                    }
                )
            // 橡胶耐磨鞋底
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(red: 0.88, green: 0.90, blue: 0.94))
                .frame(width: 29, height: 5)
        }
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }

    // MARK: - 2. 贴身内搭图层 (真实短袖/CURE艺术印花/长袖打底)

    private func innerGarmentLayer(item: ClothingItem) -> some View {
        let isShortSleeve = item.visualStyle == "tshirt" || item.name.contains("短T") || item.name.contains("短袖")
        let isCureTee = item.customCode == "79_38" || item.name.contains("CURE")
        let isGraffitiTee = item.customCode == "82_38" || item.name.contains("泼墨")
        let clothColor = parseColor(item.colorHex)

        return ZStack {
            // A. 躯干部分
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(clothColor)
                .frame(width: 78, height: 92)
                .overlay(
                    VStack {
                        // 领口
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .stroke(Color.black.opacity(0.2), lineWidth: 2.5)
                            .frame(width: 24, height: 15)
                            .offset(y: -4)

                        // 核心辨识度印花：#79 CURE 红框艺术印花
                        if isCureTee {
                            ZStack {
                                // 红色矩形油画框
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color(red: 0.74, green: 0.15, blue: 0.17))
                                    .frame(width: 32, height: 40)
                                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)

                                VStack(spacing: 2) {
                                    // 眼睛抽象艺术涂鸦
                                    ZStack {
                                        Circle().fill(Color.white.opacity(0.95)).frame(width: 14, height: 10)
                                        Circle().fill(Color.black).frame(width: 6, height: 6)
                                        Circle().fill(Color.white).frame(width: 2, height: 2).offset(x: -1, y: -1)
                                    }
                                    .padding(.top, 4)

                                    Rectangle().fill(Color.white.opacity(0.85)).frame(width: 18, height: 1)

                                    // CURE 艺术字母
                                    Text("CURE")
                                        .font(.system(size: 6.5, weight: .black, design: .rounded))
                                        .foregroundStyle(.white)
                                }
                            }
                            .offset(y: 4)
                        } else if isGraffitiTee {
                            // #82 街头泼墨 T 恤正面微标
                            HStack(spacing: 2) {
                                Text("+*")
                                    .font(.system(size: 7, weight: .bold))
                                    .foregroundStyle(Color.white.opacity(0.8))
                                Spacer()
                            }
                            .padding(.leading, 12)
                            .offset(y: 6)
                        }

                        Spacer()
                    }
                    .padding(.top, 2)
                )
                .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 2)

            // B. 袖子 (短袖时：仅覆盖上臂，露出下方光滑健康小臂；长袖时：覆盖整个手臂)
            HStack(spacing: 76) {
                // 左袖
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(clothColor)
                    .frame(width: 18, height: isShortSleeve ? 38 : 100)
                    .offset(y: isShortSleeve ? -20 : 10)

                // 右袖
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(clothColor)
                    .frame(width: 18, height: isShortSleeve ? 38 : 100)
                    .offset(y: isShortSleeve ? -20 : 10)
            }
        }
        .offset(y: 8)
    }

    // MARK: - 3. 下装图层 (工装短裤/灯芯绒长裤/垂坠抽绳裤/牛仔裤/束脚裤)

    private func bottomGarmentLayer(item: ClothingItem) -> some View {
        let isShorts = item.visualStyle == "shorts" || item.name.contains("短裤")
        let isShohCargoShorts = item.customCode == "67_38" || item.name.contains("SHOH")
        let isKhakiShorts = item.customCode == "71_38" || item.name.contains("浅卡其")
        let isDrawstringPants = item.customCode == "70_38" || item.customCode == "83_38" || item.name.contains("抽绳长裤")
        let isTaupeCorduroy = item.customCode == "72_38" || item.name.contains("灰褐色") || item.name.contains("灯芯绒")
        let isSkechersNavy = item.customCode == "73_38" || item.name.contains("斯凯奇")
        let is1977Black = item.customCode == "74_38" || item.name.contains("1977")
        let isIndigoJeans = item.customCode == "81_38" || item.name.contains("牛仔")
        let pantColor = parseColor(item.colorHex)

        return Group {
            if isShorts {
                // 短裤形态 (膝上剪裁，露出下方小腿)
                ZStack {
                    HStack(spacing: 6) {
                        // 左裤腿
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(pantColor)
                            .frame(width: 35, height: 56)
                            .overlay(
                                // #67 SHOH 工装立体贴袋与白色标签
                                Group {
                                    if isShohCargoShorts {
                                        VStack {
                                            HStack {
                                                RoundedRectangle(cornerRadius: 2)
                                                    .fill(Color(white: 0.18))
                                                    .frame(width: 10, height: 26)
                                                    .overlay(
                                                        Text("S")
                                                            .font(.system(size: 6, weight: .bold))
                                                            .foregroundStyle(.white)
                                                    )
                                                Spacer()
                                            }
                                            .padding(.leading, 2)
                                            .padding(.top, 14)
                                            Spacer()
                                        }
                                    }
                                }
                            )

                        // 右裤腿
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(pantColor)
                            .frame(width: 35, height: 56)
                            .overlay(
                                Group {
                                    if isShohCargoShorts {
                                        VStack {
                                            HStack {
                                                Spacer()
                                                RoundedRectangle(cornerRadius: 2)
                                                    .fill(Color(white: 0.18))
                                                    .frame(width: 10, height: 26)
                                            }
                                            .padding(.trailing, 2)
                                            .padding(.top, 14)
                                            Spacer()
                                        }
                                    }
                                }
                            )
                    }
                    .shadow(color: .black.opacity(0.12), radius: 3, x: 0, y: 2)

                    // 白色抽绳自然下垂 (#67 标志性白色系绳)
                    if isShohCargoShorts || isKhakiShorts {
                        HStack(spacing: 5) {
                            Capsule().fill(Color.white).frame(width: 2.5, height: 20)
                            Capsule().fill(Color.white).frame(width: 2.5, height: 16)
                        }
                        .offset(y: -10)
                    }
                }
                .offset(y: 62)

            } else {
                // 各种长裤形态 (微锥直筒/束脚长裤，直达球鞋)
                ZStack {
                    HStack(spacing: 6) {
                        // 左裤腿
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(pantColor)
                            .frame(width: 33, height: 125)
                            .overlay(
                                ZStack {
                                    // 1. #72 灰褐色灯芯绒细条纹质感 + 左大腿银色金属拉链与黑色三角标
                                    if isTaupeCorduroy {
                                        HStack(spacing: 5) {
                                            Rectangle().fill(Color.black.opacity(0.08)).frame(width: 1)
                                            Rectangle().fill(Color.black.opacity(0.08)).frame(width: 1)
                                            Rectangle().fill(Color.black.opacity(0.08)).frame(width: 1)
                                            Spacer()
                                        }
                                        VStack {
                                            HStack {
                                                // 金属拉链
                                                Rectangle().fill(Color(white: 0.85)).frame(width: 2, height: 18)
                                                // 黑色金属三角标
                                                TriangleShape()
                                                    .fill(Color.black)
                                                    .frame(width: 8, height: 7)
                                                    .rotationEffect(.degrees(180))
                                                Spacer()
                                            }
                                            .padding(.leading, 4)
                                            .padding(.top, 25)
                                            Spacer()
                                        }
                                    }

                                    // 2. #73 斯凯奇白色 "S" 品牌刺绣
                                    if isSkechersNavy {
                                        VStack {
                                            HStack {
                                                Text("S")
                                                    .font(.system(size: 9, weight: .black, design: .rounded))
                                                    .foregroundStyle(.white)
                                                Spacer()
                                            }
                                            .padding(.leading, 6)
                                            .padding(.top, 22)
                                            Spacer()
                                        }
                                    }

                                    // 3. #74 1977 纯白高街粗体字母
                                    if is1977Black {
                                        VStack {
                                            HStack {
                                                Text("1977")
                                                    .font(.system(size: 7.5, weight: .heavy, design: .monospaced))
                                                    .foregroundStyle(.white)
                                                Spacer()
                                            }
                                            .padding(.leading, 4)
                                            .padding(.top, 38) // 稍微向下，即使穿中长外套也清晰可见
                                            Spacer()
                                        }
                                    }

                                    // 4. #81 原牛深蓝双明黄色车缝线 + 铜扣
                                    if isIndigoJeans {
                                        HStack {
                                            Rectangle().fill(Color(red: 0.92, green: 0.72, blue: 0.28)).frame(width: 1)
                                            Spacer()
                                        }
                                        .padding(.leading, 3)
                                    }
                                }
                            )

                        // 右裤腿
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(pantColor)
                            .frame(width: 33, height: 125)
                            .overlay(
                                Group {
                                    if isIndigoJeans {
                                        HStack {
                                            Spacer()
                                            Rectangle().fill(Color(red: 0.92, green: 0.72, blue: 0.28)).frame(width: 1)
                                        }
                                        .padding(.trailing, 3)
                                    }
                                }
                            )
                    }
                    .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 3)

                    // 5. #70 / #83 深灰休闲裤专属：垂挂在裤腰正中的白色粗棉絮流苏抽绳！
                    if isDrawstringPants {
                        HStack(spacing: 6) {
                            VStack(spacing: 0) {
                                Capsule().fill(Color.white).frame(width: 3, height: 28)
                                Circle().fill(Color.white.opacity(0.9)).frame(width: 5, height: 5)
                            }
                            VStack(spacing: 0) {
                                Capsule().fill(Color.white).frame(width: 3, height: 24)
                                Circle().fill(Color.white.opacity(0.9)).frame(width: 5, height: 5)
                            }
                        }
                        .offset(y: -42)
                    }

                    // 牛仔裤腰带铜扣
                    if isIndigoJeans {
                        Circle()
                            .fill(Color(red: 0.85, green: 0.65, blue: 0.25))
                            .frame(width: 5, height: 5)
                            .offset(y: -56)
                    }
                }
                .offset(y: 95)
            }
        }
    }

    // MARK: - 4. 保暖中层图层 (卫衣/开衫/衬衫/假两件)

    private func midGarmentLayer(item: ClothingItem, isUnderJacket: Bool) -> some View {
        let isOliveHalfZip = item.customCode == "66_38" || item.name.contains("杉杉")
        let isAdidasGrey = item.customCode == "68_38" || item.name.contains("阿迪达斯")
        let isBlueFakeTwo = item.customCode == "75_38" || item.name.contains("牛仔蓝") || (item.name.contains("假两件") && item.colorHex.contains("405E7A"))
        let isBlackFakeTwo = item.customCode == "80_38" || (item.name.contains("假两件") && item.colorHex.contains("1C1C20"))
        let isPlaidShacket = item.customCode == "76_38" || item.name.contains("海澜之家") || item.name.contains("细格")
        let midColor = parseColor(item.colorHex)

        return ZStack {
            // A. 中层躯干
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(midColor)
                .frame(width: 78, height: 92)
                .overlay(
                    VStack {
                        // 1. #75 / #80 假两件保暖毛衣：外露洁白小翻领！
                        if isBlueFakeTwo || isBlackFakeTwo {
                            HStack(spacing: 4) {
                                TriangleShape()
                                    .fill(Color.white)
                                    .frame(width: 14, height: 11)
                                    .rotationEffect(.degrees(160))
                                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)

                                TriangleShape()
                                    .fill(Color.white)
                                    .frame(width: 14, height: 11)
                                    .rotationEffect(.degrees(-160))
                                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                            }
                            .offset(y: -3)

                            // 小马刺绣
                            HStack {
                                Circle().fill(Color(red: 0.85, green: 0.72, blue: 0.55)).frame(width: 4, height: 4)
                                Spacer()
                            }
                            .padding(.leading, 14)
                            .padding(.top, 4)

                        // 2. #66 杉杉军绿立领：银色半拉链！
                        } else if isOliveHalfZip {
                            // 橄榄绿小立领
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(red: 0.25, green: 0.32, blue: 0.24))
                                .frame(width: 24, height: 14)
                                .offset(y: -5)
                                .overlay(
                                    // 银色半拉链
                                    VStack(spacing: 0) {
                                        Rectangle().fill(Color(white: 0.88)).frame(width: 2, height: 26)
                                        Circle().fill(Color.white).frame(width: 3.5, height: 3.5)
                                    }
                                    .offset(y: 8)
                                )

                        // 3. #68 阿迪浅灰卫衣：经典复古三角拼领 + 黑色刺绣三叶草标！
                        } else if isAdidasGrey {
                            // 三角拼领
                            TriangleShape()
                                .fill(Color(red: 0.85, green: 0.87, blue: 0.90))
                                .frame(width: 12, height: 8)
                                .rotationEffect(.degrees(180))
                                .offset(y: 3)

                            // 黑色小标
                            HStack {
                                Circle().fill(Color.black).frame(width: 5, height: 5)
                                Spacer()
                            }
                            .padding(.leading, 15)
                            .padding(.top, 4)

                        // 4. #76 海澜之家细格衬衫夹克：翻领 + 亮黄细格纹！
                        } else if isPlaidShacket {
                            ZStack {
                                // 细格纹理
                                HStack(spacing: 12) {
                                    Rectangle().fill(Color(red: 0.9, green: 0.75, blue: 0.3).opacity(0.6)).frame(width: 1)
                                    Rectangle().fill(Color(red: 0.9, green: 0.75, blue: 0.3).opacity(0.6)).frame(width: 1)
                                    Rectangle().fill(Color(red: 0.9, green: 0.75, blue: 0.3).opacity(0.6)).frame(width: 1)
                                }
                                // 双胸袋
                                HStack(spacing: 24) {
                                    RoundedRectangle(cornerRadius: 1).fill(Color(red: 0.2, green: 0.28, blue: 0.35)).frame(width: 16, height: 14)
                                    RoundedRectangle(cornerRadius: 1).fill(Color(red: 0.2, green: 0.28, blue: 0.35)).frame(width: 16, height: 14)
                                }
                            }
                        }

                        Spacer()
                    }
                    .padding(.top, 2)
                )
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)

            // B. 中层长袖 (如果外面还有大外套，外套的袖子会覆盖在上面)
            if !isUnderJacket {
                HStack(spacing: 76) {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(midColor)
                        .frame(width: 18, height: 100)
                        .offset(y: 10)

                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(midColor)
                        .frame(width: 18, height: 100)
                        .offset(y: 10)
                }
            }
        }
        .offset(y: 8)
    }

    // MARK: - 5. 外套图层 (冲锋衣/轻量小棉服/重磅派克大衣，敞开式设计完美露出内搭)

    private func outerGarmentLayer(item: ClothingItem, innerItem: ClothingItem, midItem: ClothingItem?) -> some View {
        let isWindbreaker = item.customCode == "69_38" || item.name.contains("冲锋衣")
        let isLightPadded = item.customCode == "77_38" || item.name.contains("小棉服") || item.name.contains("双横拉链")
        let isHeavyParka = item.customCode == "78_38" || item.name.contains("派克") || item.name.contains("棉服大衣")
        let jacketColor = parseColor(item.colorHex)

        return ZStack {
            // A. 敞开式门襟两侧 (左前片 + 右前片，中间留出 42pt 宽阔展示缝，把里面的短袖CURE/假两件白领 100% 露出来！)
            HStack(spacing: isJacketOpen ? 42 : 2) {
                // 左前胸门襟
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isWindbreaker ? Color(red: 0.21, green: 0.23, blue: 0.25) : jacketColor)
                    .frame(width: isJacketOpen ? 28 : 46, height: isHeavyParka ? 138 : 100)
                    .overlay(
                        ZStack {
                            // 1. #69 冲锋衣：卡其色肩部拼接 + 胸前斜插拉链
                            if isWindbreaker {
                                VStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(red: 0.78, green: 0.67, blue: 0.53))
                                        .frame(height: 28)
                                    // 斜拉链
                                    Rectangle()
                                        .fill(Color(white: 0.9))
                                        .frame(width: 2, height: 16)
                                        .rotationEffect(.degrees(35))
                                        .offset(y: 4)
                                    Spacer()
                                }
                            }

                            // 2. #77 轻量小棉服：横向防水拉链暗袋与轻薄充棉微绗缝
                            if isLightPadded {
                                VStack {
                                    HStack {
                                        Rectangle().fill(Color(white: 0.8)).frame(width: 14, height: 2)
                                        Circle().fill(Color.white).frame(width: 3, height: 3)
                                    }
                                    .padding(.top, 22)
                                    Spacer()
                                    Rectangle().fill(Color.black.opacity(0.3)).frame(height: 1).padding(.bottom, 20)
                                }
                            }

                            // 3. #78 重磅派克棉服：上下两个超大立体工装贴袋 + 银色四合扣
                            if isHeavyParka {
                                VStack {
                                    // 上胸袋
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color(white: 0.16))
                                        .frame(width: 18, height: 14)
                                        .padding(.top, 20)
                                    Spacer()
                                    // 下大贴袋 + 银扣
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color(white: 0.16))
                                        .frame(width: 22, height: 26)
                                        .overlay(
                                            Circle().fill(Color(white: 0.75)).frame(width: 3, height: 3).offset(y: -8)
                                        )
                                        .padding(.bottom, 12)
                                }
                            }
                        }
                    )
                    .shadow(color: .black.opacity(0.18), radius: 4, x: -2, y: 2)

                // 右前胸门襟
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isWindbreaker ? Color(red: 0.21, green: 0.23, blue: 0.25) : jacketColor)
                    .frame(width: isJacketOpen ? 28 : 46, height: isHeavyParka ? 138 : 100)
                    .overlay(
                        ZStack {
                            if isWindbreaker {
                                VStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(red: 0.78, green: 0.67, blue: 0.53))
                                        .frame(height: 28)
                                    Spacer()
                                }
                            }
                            if isLightPadded {
                                VStack {
                                    HStack {
                                        Circle().fill(Color.white).frame(width: 3, height: 3)
                                        Rectangle().fill(Color(white: 0.8)).frame(width: 14, height: 2)
                                    }
                                    .padding(.top, 22)
                                    Spacer()
                                }
                            }
                            if isHeavyParka {
                                VStack {
                                    RoundedRectangle(cornerRadius: 2).fill(Color(white: 0.16)).frame(width: 18, height: 14).padding(.top, 20)
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 3).fill(Color(white: 0.16)).frame(width: 22, height: 26)
                                        .overlay(Circle().fill(Color(white: 0.75)).frame(width: 3, height: 3).offset(y: -8))
                                        .padding(.bottom, 12)
                                }
                            }
                        }
                    )
                    .shadow(color: .black.opacity(0.18), radius: 4, x: 2, y: 2)
            }
            .offset(y: isHeavyParka ? 28 : 12)

            // B. 外套立领与翻领 (环绕颈项，优雅利落)
            HStack(spacing: 28) {
                TriangleShape()
                    .fill(isWindbreaker ? Color(red: 0.78, green: 0.67, blue: 0.53) : jacketColor)
                    .frame(width: 16, height: 12)
                    .rotationEffect(.degrees(140))
                TriangleShape()
                    .fill(isWindbreaker ? Color(red: 0.78, green: 0.67, blue: 0.53) : jacketColor)
                    .frame(width: 16, height: 12)
                    .rotationEffect(.degrees(-140))
            }
            .offset(y: -42)

            // C. 外套厚实保暖大袖子 (覆盖在内搭外面)
            HStack(spacing: 86) {
                // 左长袖
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isWindbreaker ? Color(red: 0.78, green: 0.67, blue: 0.53) : jacketColor)
                    .frame(width: 20, height: isHeavyParka ? 116 : 106)
                    .overlay(
                        Group {
                            if isWindbreaker {
                                VStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 4).fill(Color(red: 0.21, green: 0.23, blue: 0.25)).frame(height: 38)
                                }
                            }
                        }
                    )

                // 右长袖
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isWindbreaker ? Color(red: 0.78, green: 0.67, blue: 0.53) : jacketColor)
                    .frame(width: 20, height: isHeavyParka ? 116 : 106)
                    .overlay(
                        Group {
                            if isWindbreaker {
                                VStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 4).fill(Color(red: 0.21, green: 0.23, blue: 0.25)).frame(height: 38)
                                }
                                .overlay(
                                    // 袖侧 TECH 字母标
                                    Text("TECH")
                                        .font(.system(size: 6, weight: .bold))
                                        .foregroundStyle(.white)
                                        .offset(y: 8)
                                )
                            }
                        }
                    )
            }
            .offset(y: isHeavyParka ? 20 : 14)
            .shadow(color: .black.opacity(0.16), radius: 4, x: 0, y: 3)
        }
    }

    // MARK: - 6. 配件图层 (雨伞/围巾/帽子)

    private func accessoryGarmentLayer(item: ClothingItem) -> some View {
        Group {
            if item.name.contains("伞") {
                ZStack {
                    Circle()
                        .trim(from: 0.5, to: 1.0)
                        .fill(LinearGradient(colors: [Color.blue, Color(red: 0.1, green: 0.3, blue: 0.7)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 82, height: 82)

                    VStack(spacing: 0) {
                        Spacer()
                        Rectangle().fill(Color.gray).frame(width: 2.5, height: 75)
                        Circle().trim(from: 0.0, to: 0.5).stroke(Color.gray, lineWidth: 2.5).frame(width: 9, height: 9)
                    }
                    .frame(height: 95)
                    .offset(y: 20)
                }
                .rotationEffect(.degrees(22))
                .offset(x: 72, y: -25)
                .shadow(color: .blue.opacity(0.25), radius: 5, x: 3, y: 3)

            } else if item.name.contains("围巾") {
                ZStack {
                    Capsule().fill(parseColor(item.colorHex)).frame(width: 44, height: 20).offset(y: -42)
                    RoundedRectangle(cornerRadius: 3).fill(parseColor(item.colorHex)).frame(width: 14, height: 46).offset(x: -8, y: -20)
                }
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)

            } else if item.name.contains("帽") {
                ZStack {
                    Capsule().fill(parseColor(item.colorHex)).frame(width: 52, height: 22).offset(y: -88)
                    Ellipse().fill(parseColor(item.colorHex).opacity(0.85)).frame(width: 36, height: 10).offset(x: 12, y: -80)
                }
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
            }
        }
    }

    // MARK: - 辅助颜色解析

    private func parseColor(_ hex: String) -> Color {
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexSanitized.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 59, 130, 246)
        }
        return Color(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// 腿部自然平滑曲线形状
private struct TaperedLegShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - 2, y: rect.height * 0.45))
        path.addLine(to: CGPoint(x: rect.maxX - 4, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.height * 0.45))
        path.closeSubpath()
        return path
    }
}

// 倒三角辅助形状
private struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
