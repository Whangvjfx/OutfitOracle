import SwiftUI

/// 核心视觉区：ZStack 多图层虚拟形象穿搭渲染画布
public struct AvatarDisplayView: View {
    public let plan: OutfitPlan?
    public let weather: WeatherSnapshot?

    public init(plan: OutfitPlan?, weather: WeatherSnapshot?) {
        self.plan = plan
        self.weather = weather
    }

    public var body: some View {
        ZStack {
            // 图层 0: 环境氛围光晕 (根据穿衣等级/天气自动调节冷暖色温)
            ambientAtmosphereLayer

            // 图层 1: 地台底座与投影
            pedestalLayer

            // 人模与衣物叠加核心区 (ZStack)
            ZStack {
                // 图层 2: 人模底图 (Avatar Base Body)
                baseAvatarBodyLayer

                if let plan = plan {
                    // 图层 3: 内搭图层 (Inner Wear Layer)
                    innerClothingLayer(item: plan.inner)

                    // 图层 4: 下装图层 (Bottom Wear Layer)
                    bottomClothingLayer(item: plan.bottom)

                    // 图层 5: 保暖中层与外套图层 (Mid / Outer Wear Layer)
                    if let mid = plan.midLayer {
                        midClothingLayer(item: mid)
                    }
                    if let outer = plan.outer {
                        outerClothingLayer(item: outer)
                    }

                    // 图层 6: 配件图层 (Accessory Layer - 雨伞/围巾/帽子)
                    if let acc = plan.accessory {
                        accessoryLayer(item: acc)
                    }
                }
            }
            .frame(width: 260, height: 360)
            .drawingGroup() // 提升复合图层渲染性能

            // 浮动穿搭标牌标签
            if let plan = plan {
                floatingTagsOverlay(plan: plan)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 380)
        .padding(.vertical, 8)
    }

    // MARK: - Layer 0: 环境氛围与光效

    private var ambientAtmosphereLayer: some View {
        let colors: [Color] = {
            guard let level = plan?.level else {
                return [Color.blue.opacity(0.12), Color.clear]
            }
            switch level {
            case .freezing:
                return [Color.cyan.opacity(0.25), Color.blue.opacity(0.08), Color.clear]
            case .cold:
                return [Color.blue.opacity(0.22), Color.teal.opacity(0.06), Color.clear]
            case .cool:
                return [Color.teal.opacity(0.2), Color.mint.opacity(0.06), Color.clear]
            case .comfortable:
                return [Color.green.opacity(0.18), Color.yellow.opacity(0.08), Color.clear]
            case .hot:
                return [Color.orange.opacity(0.25), Color.red.opacity(0.08), Color.clear]
            }
        }()

        return RadialGradient(
            gradient: Gradient(colors: colors),
            center: .center,
            startRadius: 20,
            endRadius: 180
        )
    }

    // MARK: - Layer 1: 地台与投影

    private var pedestalLayer: some View {
        VStack {
            Spacer()
            Ellipse()
                .fill(Color.black.opacity(0.12))
                .frame(width: 170, height: 24)
                .blur(radius: 6)
                .offset(y: -10)
        }
    }

    // MARK: - Layer 2: 人模底图 (Base Mannequin)
    // 💡 支持从 Assets.xcassets 读取名为 "avatar_base" 的透明 PNG。
    // 若未放入自定义 PNG，则由高精几何形状与 SF Symbol 矢量人偶兜底渲染。

    private var baseAvatarBodyLayer: some View {
        Group {
            if let _ = UIImage(named: "avatar_base") {
                Image("avatar_base")
                    .resizable()
                    .scaledToFit()
            } else {
                // 矢量拟态人偶底模 (头部、躯干、腿部)
                VStack(spacing: 4) {
                    // 头部
                    Circle()
                        .fill(Color(uiColor: .systemGray4))
                        .frame(width: 58, height: 58)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)

                    // 脖颈
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(uiColor: .systemGray4))
                        .frame(width: 16, height: 12)

                    // 躯干与四肢占位骨架
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(uiColor: .systemGray5))
                        .frame(width: 100, height: 130)
                        .overlay(
                            VStack {
                                Spacer()
                                HStack(spacing: 12) {
                                    // 双腿轮廓
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(uiColor: .systemGray4))
                                        .frame(width: 28, height: 110)
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(uiColor: .systemGray4))
                                        .frame(width: 28, height: 110)
                                }
                                .offset(y: 80)
                            }
                        )
                }
                .offset(y: -40)
            }
        }
    }

    // MARK: - Layer 3: 内搭图层 (Inner Wear)
    // 💡 支持从 Assets 中读取自定义 PNG（如 "avatar_inner_tshirt"），无图时自动渲染矢量卡片

    private func innerClothingLayer(item: ClothingItem) -> some View {
        Group {
            let assetKey = "avatar_inner_\(item.name)"
            if let _ = UIImage(named: assetKey) {
                Image(assetKey)
                    .resizable()
                    .scaledToFit()
            } else {
                // 动态内搭色块与剪裁展示
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.orange.opacity(0.85), Color.orange.opacity(0.65)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 92, height: 90)
                            .shadow(color: .orange.opacity(0.2), radius: 6, x: 0, y: 3)

                        VStack(spacing: 2) {
                            Image(systemName: item.iconName)
                                .font(.system(size: 26))
                                .foregroundStyle(.white)
                            Text(item.name)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .padding(.horizontal, 4)
                        }
                    }
                    Spacer()
                }
                .offset(y: 84)
            }
        }
        .transition(.scale(scale: 0.8).combined(with: .opacity))
    }

    // MARK: - Layer 4: 下装图层 (Bottom Wear)

    private func bottomClothingLayer(item: ClothingItem) -> some View {
        Group {
            let assetKey = "avatar_bottom_\(item.name)"
            if let _ = UIImage(named: assetKey) {
                Image(assetKey)
                    .resizable()
                    .scaledToFit()
            } else {
                VStack {
                    Spacer()
                    ZStack {
                        // 裤装双筒几何遮罩
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.indigo.opacity(0.85), Color.indigo.opacity(0.65)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 38, height: item.name.contains("短裤") ? 55 : 110)

                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.indigo.opacity(0.85), Color.indigo.opacity(0.65)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 38, height: item.name.contains("短裤") ? 55 : 110)
                        }
                        .shadow(color: .indigo.opacity(0.2), radius: 6, x: 0, y: 3)

                        VStack {
                            Text(item.name)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(4)
                                .background(Color.black.opacity(0.25))
                                .clipShape(Capsule())
                        }
                    }
                }
                .offset(y: item.name.contains("短裤") ? -45 : 10)
            }
        }
        .transition(.opacity)
    }

    // MARK: - Layer 5-A: 保暖中层 (MidLayer)

    private func midClothingLayer(item: ClothingItem) -> some View {
        Group {
            let assetKey = "avatar_mid_\(item.name)"
            if let _ = UIImage(named: assetKey) {
                Image(assetKey)
                    .resizable()
                    .scaledToFit()
            } else {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.yellow, lineWidth: 3)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.yellow.opacity(0.35))
                            )
                            .frame(width: 104, height: 96)
                    }
                    Spacer()
                }
                .offset(y: 81)
            }
        }
    }

    // MARK: - Layer 5-B: 外套图层 (Outer Wear)

    private func outerClothingLayer(item: ClothingItem) -> some View {
        Group {
            let assetKey = "avatar_outer_\(item.name)"
            if let _ = UIImage(named: assetKey) {
                Image(assetKey)
                    .resizable()
                    .scaledToFit()
            } else {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.88), Color.teal.opacity(0.85)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 118, height: 110)
                            .shadow(color: .blue.opacity(0.25), radius: 8, x: 0, y: 4)

                        VStack(spacing: 3) {
                            HStack {
                                Image(systemName: item.iconName)
                                    .font(.system(size: 22))
                                if item.isWindproof {
                                    Image(systemName: "wind")
                                        .font(.system(size: 12))
                                }
                            }
                            .foregroundStyle(.white)

                            Text(item.name)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .padding(.horizontal, 6)
                        }
                    }
                    Spacer()
                }
                .offset(y: 74)
            }
        }
        .transition(.scale(scale: 0.9).combined(with: .opacity))
    }

    // MARK: - Layer 6: 配件图层 (Accessory)

    private func accessoryLayer(item: ClothingItem) -> some View {
        Group {
            let assetKey = "avatar_acc_\(item.name)"
            if let _ = UIImage(named: assetKey) {
                Image(assetKey)
                    .resizable()
                    .scaledToFit()
            } else {
                if item.name.contains("帽") {
                    // 头部佩戴
                    VStack {
                        Image(systemName: "baseballcap.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.purple)
                            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                        Spacer()
                    }
                    .offset(y: 12)
                } else if item.name.contains("围巾") {
                    // 颈部佩戴
                    VStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red.opacity(0.8))
                            .frame(width: 72, height: 20)
                            .shadow(radius: 2)
                        Spacer()
                    }
                    .offset(y: 68)
                } else if item.name.contains("伞") {
                    // 侧手持雨伞
                    HStack {
                        Spacer()
                        Image(systemName: "umbrella.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.blue)
                            .rotationEffect(.degrees(20))
                            .shadow(color: .blue.opacity(0.3), radius: 6, x: 2, y: 3)
                            .offset(x: 20, y: -20)
                    }
                }
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    // MARK: - 侧边浮动搭配品名浮标

    private func floatingTagsOverlay(plan: OutfitPlan) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                tagChip(title: plan.inner.name, category: "内搭", color: .orange)
                if let mid = plan.midLayer {
                    tagChip(title: mid.name, category: "中层", color: .yellow)
                }
                if let outer = plan.outer {
                    tagChip(title: outer.name, category: "外套", color: .blue)
                }
                Spacer()
            }
            .padding(.leading, 12)
            .padding(.top, 40)

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                tagChip(title: plan.bottom.name, category: "下装", color: .indigo)
                if let acc = plan.accessory {
                    tagChip(title: acc.name, category: "配件", color: .purple)
                }
                Spacer()
            }
            .padding(.trailing, 12)
            .padding(.top, 80)
        }
    }

    private func tagChip(title: String, category: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(category)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(color)
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }
}
