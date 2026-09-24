import SwiftUI

/// 高精度真实拟态人物穿搭画布引擎 (支持内搭露胸口/露短袖、外穿敞开外套、真实牛仔裤/裙装与饰品)
public struct RealisticAvatarView: View {
    public let plan: OutfitPlan?
    public let weather: WeatherSnapshot?
    public let gender: GenderCategory

    public init(plan: OutfitPlan?, weather: WeatherSnapshot?, gender: GenderCategory = .men) {
        self.plan = plan
        self.weather = weather
        self.gender = gender
    }

    // 肤色与发色常量
    private let skinColor = Color(red: 0.96, green: 0.82, blue: 0.72)
    private let skinShadowColor = Color(red: 0.88, green: 0.72, blue: 0.62)
    private let hairColor = Color(red: 0.15, green: 0.15, blue: 0.18)

    public var body: some View {
        ZStack {
            // 地台光影
            avatarGroundShadow

            // 人物主体与层叠穿搭
            ZStack {
                // 1. 身体底模 (头脸、发型、脖子、四肢、鞋子)
                bodyBaseSilhouette

                if let plan = plan {
                    // 2. 贴身内搭图层 (短袖T恤、衬衫、打底衫，清晰可见领口与袖型)
                    innerGarmentLayer(item: plan.inner)

                    // 3. 下装图层 (牛仔裤、工装裤、短裤、半身裙)
                    bottomGarmentLayer(item: plan.bottom)

                    // 4. 外套图层 (敞开式夹克/风衣/羽绒服，绝不遮挡内搭，清晰呈现“内穿短袖，外套夹克”)
                    if let outer = plan.outer {
                        outerGarmentLayer(item: outer, innerItem: plan.inner)
                    } else if let mid = plan.midLayer {
                        // 无大外套但有中层卫衣/开衫时
                        midGarmentLayer(item: mid)
                    }

                    // 5. 配件图层 (雨伞握在手上、围巾系在脖子上、帽子戴在头上)
                    if let acc = plan.accessory {
                        accessoryGarmentLayer(item: acc)
                    }
                }
            }
            .frame(width: 220, height: 360)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 380)
    }

    // MARK: - 地台与环境阴影

    private var avatarGroundShadow: some View {
        VStack {
            Spacer()
            Ellipse()
                .fill(Color.black.opacity(0.14))
                .frame(width: 140, height: 18)
                .blur(radius: 5)
                .offset(y: 4)
        }
    }

    // MARK: - 1. 人体底模骨架 (头发、脸庞、脖子、手臂、腿与鞋)

    private var bodyBaseSilhouette: some View {
        ZStack {
            // 双腿与皮肤 (短裤或裙装时会露出)
            HStack(spacing: 20) {
                // 左腿
                Capsule()
                    .fill(skinColor)
                    .frame(width: 22, height: 130)
                // 右腿
                Capsule()
                    .fill(skinColor)
                    .frame(width: 22, height: 130)
            }
            .offset(y: 95)

            // 真实运动鞋履 (White Sneakers with rubber sole)
            HStack(spacing: 20) {
                shoeView
                shoeView
            }
            .offset(y: 165)

            // 双手臂与手掌 (自然垂放于身体两侧)
            HStack(spacing: 86) {
                // 左臂与手
                VStack(spacing: 0) {
                    Capsule()
                        .fill(skinColor)
                        .frame(width: 14, height: 110)
                    Circle()
                        .fill(skinColor)
                        .frame(width: 15, height: 15)
                }
                // 右臂与手
                VStack(spacing: 0) {
                    Capsule()
                        .fill(skinColor)
                        .frame(width: 14, height: 110)
                    Circle()
                        .fill(skinColor)
                        .frame(width: 15, height: 15)
                }
            }
            .offset(y: 15)

            // 躯干皮肤基底
            RoundedRectangle(cornerRadius: 14)
                .fill(skinColor)
                .frame(width: 74, height: 105)
                .offset(y: 8)

            // 脖颈
            Rectangle()
                .fill(skinShadowColor)
                .frame(width: 18, height: 22)
                .offset(y: -46)

            // 头脸轮廓与五官阴影
            VStack(spacing: 0) {
                // 脸庞
                ZStack {
                    Capsule()
                        .fill(skinColor)
                        .frame(width: 48, height: 56)
                        .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 2)

                    // 眉眼拟态微表情
                    HStack(spacing: 12) {
                        Capsule().fill(Color(uiColor: .darkGray)).frame(width: 6, height: 3)
                        Capsule().fill(Color(uiColor: .darkGray)).frame(width: 6, height: 3)
                    }
                    .offset(y: -2)

                    // 嘴唇微扬微笑
                    Circle()
                        .trim(from: 0.1, to: 0.4)
                        .stroke(Color.red.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 12, height: 12)
                        .rotationEffect(.degrees(45))
                        .offset(y: 12)

                    // 发型渲染 (根据性别区分男士层次碎发或女士温婉长发)
                    hairStyleView
                }
            }
            .offset(y: -74)
        }
    }

    private var hairStyleView: some View {
        Group {
            if gender == .women {
                // 女士长发
                ZStack {
                    // 头顶蓬松发量
                    Capsule()
                        .fill(hairColor)
                        .frame(width: 52, height: 32)
                        .offset(y: -18)
                    // 两侧垂发
                    HStack(spacing: 40) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(hairColor)
                            .frame(width: 12, height: 48)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(hairColor)
                            .frame(width: 12, height: 48)
                    }
                    .offset(y: 4)
                }
            } else {
                // 男士干练短发
                ZStack {
                    Capsule()
                        .fill(hairColor)
                        .frame(width: 52, height: 28)
                        .offset(y: -18)
                    HStack(spacing: 38) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(hairColor)
                            .frame(width: 8, height: 18)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(hairColor)
                            .frame(width: 8, height: 18)
                    }
                    .offset(y: -10)
                }
            }
        }
    }

    private var shoeView: some View {
        VStack(spacing: 0) {
            // 鞋身
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white)
                .frame(width: 26, height: 14)
                .overlay(
                    HStack(spacing: 2) {
                        Rectangle().fill(Color.gray.opacity(0.4)).frame(width: 2, height: 6)
                        Rectangle().fill(Color.gray.opacity(0.4)).frame(width: 2, height: 6)
                    }
                )
            // 橡胶耐磨鞋底
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(uiColor: .systemGray3))
                .frame(width: 28, height: 4)
        }
        .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 1)
    }

    // MARK: - 2. 贴身内搭图层 (短袖T恤、衬衫、保暖打底，呈现真实衣服质感)

    private func innerGarmentLayer(item: ClothingItem) -> some View {
        let clothColor = parseColor(item.colorHex)

        return ZStack {
            // A. 内搭躯干衣服
            RoundedRectangle(cornerRadius: 10)
                .fill(clothColor)
                .frame(width: 70, height: 86)
                .overlay(
                    // 衣服领口与细节
                    VStack {
                        if item.visualStyle == "shirt" {
                            // 衬衫翻领与扣子
                            HStack(spacing: 8) {
                                Triangle().fill(clothColor).frame(width: 14, height: 10).rotationEffect(.degrees(180))
                                Triangle().fill(clothColor).frame(width: 14, height: 10).rotationEffect(.degrees(180))
                            }
                            .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
                            
                            // 纽扣竖排
                            VStack(spacing: 8) {
                                Circle().fill(Color.black.opacity(0.2)).frame(width: 3, height: 3)
                                Circle().fill(Color.black.opacity(0.2)).frame(width: 3, height: 3)
                                Circle().fill(Color.black.opacity(0.2)).frame(width: 3, height: 3)
                            }
                            .padding(.top, 4)
                        } else {
                            // 经典短袖圆领
                            Circle()
                                .trim(from: 0.0, to: 0.5)
                                .stroke(Color.black.opacity(0.18), lineWidth: 2)
                                .frame(width: 22, height: 14)
                                .offset(y: -4)
                        }
                        Spacer()
                    }
                    .padding(.top, 2)
                )
                .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 2)

            // B. 真实内搭袖子 (短袖时：仅覆盖上臂上方，露出下方光滑小臂；长袖时：覆盖整个手臂)
            HStack(spacing: 66) {
                // 左袖
                RoundedRectangle(cornerRadius: 5)
                    .fill(clothColor)
                    .frame(width: 16, height: item.visualStyle == "tshirt" ? 34 : 96)
                    .offset(y: item.visualStyle == "tshirt" ? -24 : 8)

                // 右袖
                RoundedRectangle(cornerRadius: 5)
                    .fill(clothColor)
                    .frame(width: 16, height: item.visualStyle == "tshirt" ? 34 : 96)
                    .offset(y: item.visualStyle == "tshirt" ? -24 : 8)
            }
        }
        .offset(y: 4)
    }

    // MARK: - 3. 下装图层 (牛仔裤、工装裤、短裤、裙装)

    private func bottomGarmentLayer(item: ClothingItem) -> some View {
        let pantColor = parseColor(item.colorHex)

        return Group {
            if item.visualStyle == "skirt" {
                // 女士半身裙 / 百褶裙
                VStack(spacing: 0) {
                    Trapezoid()
                        .fill(pantColor)
                        .frame(width: 86, height: item.name.contains("短裙") ? 46 : 94)
                        .overlay(
                            // 裙褶暗纹
                            HStack(spacing: 8) {
                                ForEach(0..<6, id: \.self) { _ in
                                    Rectangle().fill(Color.black.opacity(0.08)).frame(width: 1)
                                }
                            }
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    Spacer()
                }
                .offset(y: 44)
            } else if item.visualStyle == "shorts" {
                // 夏季短裤 (膝盖以上，露出下方小腿)
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(pantColor)
                        .frame(width: 32, height: 48)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(pantColor)
                        .frame(width: 32, height: 48)
                }
                .offset(y: 52)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            } else {
                // 经典长裤 / 直筒牛仔裤 / 工装裤
                ZStack {
                    HStack(spacing: 6) {
                        // 左裤腿
                        RoundedRectangle(cornerRadius: 7)
                            .fill(pantColor)
                            .frame(width: 29, height: 114)
                            .overlay(
                                // 牛仔裤压线缝与侧口袋
                                VStack {
                                    HStack {
                                        Rectangle().fill(Color.black.opacity(0.15)).frame(width: 1.5, height: 18)
                                        Spacer()
                                    }
                                    .padding(.leading, 3)
                                    .padding(.top, 8)
                                    Spacer()
                                }
                            )

                        // 右裤腿
                        RoundedRectangle(cornerRadius: 7)
                            .fill(pantColor)
                            .frame(width: 29, height: 114)
                            .overlay(
                                VStack {
                                    HStack {
                                        Spacer()
                                        Rectangle().fill(Color.black.opacity(0.15)).frame(width: 1.5, height: 18)
                                    }
                                    .padding(.trailing, 3)
                                    .padding(.top, 8)
                                    Spacer()
                                }
                            )
                    }
                    .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 3)

                    // 裤腰带皮带环
                    VStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(pantColor.opacity(0.85))
                            .frame(width: 66, height: 12)
                            .overlay(
                                HStack(spacing: 12) {
                                    Rectangle().fill(Color.black.opacity(0.2)).frame(width: 2, height: 8)
                                    Rectangle().fill(Color.black.opacity(0.2)).frame(width: 2, height: 8)
                                    Rectangle().fill(Color.black.opacity(0.2)).frame(width: 2, height: 8)
                                }
                            )
                        Spacer()
                    }
                    .offset(y: 40)
                }
                .offset(y: 84)
            }
        }
    }

    // MARK: - 4. 外套图层 (敞开式大衣/夹克/羽绒服，完美露出内搭短袖与胸膛)

    private func outerGarmentLayer(item: ClothingItem, innerItem: ClothingItem) -> some View {
        let jacketColor = parseColor(item.colorHex)
        let isLongCoat = item.visualStyle == "coat" || item.name.contains("长款")

        return ZStack {
            // A. 敞开的外套门襟两侧 (左前片 + 右前片，中间留出 38pt 宽阔展示缝，把里面的短袖/衬衫 100% 露出来！)
            HStack(spacing: 38) {
                // 左前胸门襟
                RoundedRectangle(cornerRadius: 8)
                    .fill(jacketColor)
                    .frame(width: 26, height: isLongCoat ? 140 : 98)
                    .overlay(
                        // 夹克拉链链牙与口袋
                        VStack(alignment: .trailing, spacing: 6) {
                            HStack {
                                Spacer()
                                Rectangle().fill(Color.black.opacity(0.25)).frame(width: 2)
                            }
                            // 胸前口袋
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.black.opacity(0.15))
                                .frame(width: 14, height: 8)
                                .padding(.trailing, 6)
                            Spacer()
                        }
                    )
                    .shadow(color: .black.opacity(0.16), radius: 4, x: -2, y: 2)

                // 右前胸门襟
                RoundedRectangle(cornerRadius: 8)
                    .fill(jacketColor)
                    .frame(width: 26, height: isLongCoat ? 140 : 98)
                    .overlay(
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Rectangle().fill(Color.black.opacity(0.25)).frame(width: 2)
                                Spacer()
                            }
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.black.opacity(0.15))
                                .frame(width: 14, height: 8)
                                .padding(.leading, 6)
                            Spacer()
                        }
                    )
                    .shadow(color: .black.opacity(0.16), radius: 4, x: 2, y: 2)
            }
            .offset(y: isLongCoat ? 30 : 8)

            // B. 外套立领与翻领
            HStack(spacing: 24) {
                Triangle()
                    .fill(jacketColor)
                    .frame(width: 18, height: 14)
                    .rotationEffect(.degrees(135))
                Triangle()
                    .fill(jacketColor)
                    .frame(width: 18, height: 14)
                    .rotationEffect(.degrees(-135))
            }
            .offset(y: -40)

            // C. 外套厚实大袖子 (覆盖在内搭外面)
            HStack(spacing: 80) {
                // 左外套长袖
                RoundedRectangle(cornerRadius: 7)
                    .fill(jacketColor)
                    .frame(width: 19, height: 104)
                    .overlay(
                        // 如果是羽绒服，显示羽绒压胶横纹线
                        VStack(spacing: 16) {
                            if item.visualStyle == "downJacket" {
                                Rectangle().fill(Color.black.opacity(0.15)).frame(height: 1)
                                Rectangle().fill(Color.black.opacity(0.15)).frame(height: 1)
                                Rectangle().fill(Color.black.opacity(0.15)).frame(height: 1)
                            }
                        }
                    )
                // 右外套长袖
                RoundedRectangle(cornerRadius: 7)
                    .fill(jacketColor)
                    .frame(width: 19, height: 104)
                    .overlay(
                        VStack(spacing: 16) {
                            if item.visualStyle == "downJacket" {
                                Rectangle().fill(Color.black.opacity(0.15)).frame(height: 1)
                                Rectangle().fill(Color.black.opacity(0.15)).frame(height: 1)
                                Rectangle().fill(Color.black.opacity(0.15)).frame(height: 1)
                            }
                        }
                    )
            }
            .offset(y: 12)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
        }
    }

    private func midGarmentLayer(item: ClothingItem) -> some View {
        let midColor = parseColor(item.colorHex)
        return ZStack {
            // 卫衣/开衫门襟
            HStack(spacing: 34) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(midColor)
                    .frame(width: 22, height: 88)
                RoundedRectangle(cornerRadius: 6)
                    .fill(midColor)
                    .frame(width: 22, height: 88)
            }
            .offset(y: 6)
        }
    }

    // MARK: - 5. 配件图层 (雨伞、围巾、帽子)

    private func accessoryGarmentLayer(item: ClothingItem) -> some View {
        Group {
            if item.name.contains("伞") {
                // 手持撑开的拟真大伞 (在身体右侧微倾斜)
                ZStack {
                    // 伞面半圆拱形
                    Circle()
                        .trim(from: 0.5, to: 1.0)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color(red: 0.1, green: 0.3, blue: 0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 84, height: 84)
                        .overlay(
                            // 伞骨线条
                            HStack(spacing: 18) {
                                Rectangle().fill(Color.white.opacity(0.3)).frame(width: 1)
                                Rectangle().fill(Color.white.opacity(0.3)).frame(width: 1)
                                Rectangle().fill(Color.white.opacity(0.3)).frame(width: 1)
                            }
                        )

                    // 伞柄金属长杆与弯钩
                    VStack(spacing: 0) {
                        Spacer()
                        Rectangle()
                            .fill(Color(uiColor: .darkGray))
                            .frame(width: 3, height: 75)
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .stroke(Color(uiColor: .darkGray), lineWidth: 3)
                            .frame(width: 10, height: 10)
                    }
                    .frame(height: 100)
                    .offset(y: 20)
                }
                .rotationEffect(.degrees(22))
                .offset(x: 68, y: -20)
                .shadow(color: .blue.opacity(0.25), radius: 6, x: 4, y: 4)

            } else if item.name.contains("围巾") {
                // 真实羊绒围巾 (绕颈一周并垂落于前胸)
                ZStack {
                    // 绕颈圈
                    Capsule()
                        .fill(parseColor(item.colorHex))
                        .frame(width: 44, height: 20)
                        .offset(y: -42)
                    // 下垂流苏飘带
                    RoundedRectangle(cornerRadius: 3)
                        .fill(parseColor(item.colorHex))
                        .frame(width: 14, height: 46)
                        .offset(x: -8, y: -20)
                }
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)

            } else if item.name.contains("雷锋帽") {
                // 东北特色加厚护耳雷锋帽 (戴在头上，护耳两侧垂下)
                ZStack {
                    // 帽顶厚绒
                    Capsule()
                        .fill(parseColor(item.colorHex))
                        .frame(width: 58, height: 26)
                        .offset(y: -88)
                    // 前额毛绒帽檐
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.9, green: 0.85, blue: 0.75))
                        .frame(width: 32, height: 12)
                        .offset(y: -86)
                    // 两侧保暖护耳
                    HStack(spacing: 44) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(parseColor(item.colorHex))
                            .frame(width: 12, height: 32)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(parseColor(item.colorHex))
                            .frame(width: 12, height: 32)
                    }
                    .offset(y: -74)
                }
                .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 2)

            } else if item.name.contains("帽") {
                // 棒球帽 / 防晒帽
                ZStack {
                    Capsule()
                        .fill(parseColor(item.colorHex))
                        .frame(width: 50, height: 20)
                        .offset(y: -86)
                    // 鸭舌帽檐
                    Ellipse()
                        .fill(parseColor(item.colorHex).opacity(0.85))
                        .frame(width: 36, height: 10)
                        .offset(x: 12, y: -78)
                }
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
            }
        }
    }

    // MARK: - 辅助形状与颜色解析

    private func parseColor(_ hex: String) -> Color {
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexSanitized.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
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

// 简易三角形与梯形绘制助手
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct Trapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width * 0.8, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
