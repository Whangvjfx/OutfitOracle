import SwiftUI

/// 核心视觉区：ZStack 多图层真实拟态虚拟试衣间
public struct AvatarDisplayView: View {
    public let plan: OutfitPlan?
    public let weather: WeatherSnapshot?
    public let gender: GenderCategory
    @State private var isJacketOpen: Bool = true

    public init(plan: OutfitPlan?, weather: WeatherSnapshot?, gender: GenderCategory = .men) {
        self.plan = plan
        self.weather = weather
        self.gender = gender
    }

    public var body: some View {
        ZStack {
            // 图层 0: 环境氛围光晕 (根据穿衣等级动态冷暖色温)
            ambientAtmosphereLayer

            // 图层 1: 真实拟态高精度人物穿搭引擎
            RealisticAvatarView(
                plan: plan,
                weather: weather,
                gender: gender,
                isJacketOpen: isJacketOpen
            )

            // 图层 2: 浮动穿搭标牌标签 (优雅展示搭配各单品名称)
            if let plan = plan {
                floatingTagsOverlay(plan: plan)
            }

            // 图层 3: 外套开合切换控制药丸 (当有外套时提供交互)
            if plan?.outer != nil {
                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            isJacketOpen.toggle()
                        }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: isJacketOpen ? "rectangle.split.2x1" : "rectangle.portrait.fill")
                                .font(.system(size: 11, weight: .bold))
                            Text(isJacketOpen ? "外套：敞开看内搭" : "外套：拉上防风")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 6)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 390)
        .padding(.vertical, 4)
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

    // MARK: - 侧边浮动搭配品名浮标

    private func floatingTagsOverlay(plan: OutfitPlan) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                tagChip(title: plan.inner.name, category: "内搭", color: .orange, isCustom: !plan.inner.customCode.isEmpty)
                if let mid = plan.midLayer {
                    tagChip(title: mid.name, category: "中层", color: .yellow, isCustom: !mid.customCode.isEmpty)
                }
                if let outer = plan.outer {
                    tagChip(title: outer.name, category: "外套", color: .blue, isCustom: !outer.customCode.isEmpty)
                }
                Spacer()
            }
            .padding(.leading, 8)
            .padding(.top, 40)

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                tagChip(title: plan.bottom.name, category: "下装", color: .indigo, isCustom: !plan.bottom.customCode.isEmpty)
                if let acc = plan.accessory {
                    tagChip(title: acc.name, category: "配件", color: .purple, isCustom: !acc.customCode.isEmpty)
                }
                Spacer()
            }
            .padding(.trailing, 8)
            .padding(.top, 70)
        }
    }

    private func tagChip(title: String, category: String, color: Color, isCustom: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack(spacing: 3) {
                Text(category)
                    .font(.system(size: 8.5, weight: .bold))
                    .foregroundStyle(color)
                if isCustom {
                    Text("专属私服")
                        .font(.system(size: 7.5, weight: .semibold))
                        .foregroundStyle(Color.orange)
                        .padding(.horizontal, 3)
                        .padding(.vertical, 0.5)
                        .background(Color.orange.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            Text(title)
                .font(.system(size: 10.5, weight: .medium))
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
        )
    }
}
