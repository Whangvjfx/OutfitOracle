import SwiftUI

/// 自由试衣间 (Fitting Room) - 交互式自由混搭专属私服，实时预览层次与遮挡
public struct FittingRoomView: View {
    private let allItems: [ClothingItem] = Array(WardrobeDefaults.initialItems.prefix(18))

    @State private var selectedInnerIndex: Int = 0
    @State private var selectedMidIndex: Int = 0 // 0 means none
    @State private var selectedOuterIndex: Int = 0 // 0 means none
    @State private var selectedBottomIndex: Int = 2
    @State private var isJacketOpen: Bool = true

    public init() {}

    private var inners: [ClothingItem] {
        allItems.filter { $0.category == .inner }
    }

    private var mids: [ClothingItem] {
        allItems.filter { $0.category == .midLayer }
    }

    private var outers: [ClothingItem] {
        allItems.filter { $0.category == .outer }
    }

    private var bottoms: [ClothingItem] {
        allItems.filter { $0.category == .bottom }
    }

    // 当前构建的实时搭配方案
    private var customPlan: OutfitPlan {
        let inner = inners[min(selectedInnerIndex, inners.count - 1)]
        let mid = selectedMidIndex > 0 && selectedMidIndex <= mids.count ? mids[selectedMidIndex - 1] : nil
        let outer = selectedOuterIndex > 0 && selectedOuterIndex <= outers.count ? outers[selectedOuterIndex - 1] : nil
        let bottom = bottoms[min(selectedBottomIndex, bottoms.count - 1)]

        // 综合保暖度估算
        var totalWarmth = inner.warmthScore + bottom.warmthScore
        if let m = mid { totalWarmth += m.warmthScore }
        if let o = outer { totalWarmth += o.warmthScore * 2 }

        let level: DressingLevel
        let tempRangeText: String
        if totalWarmth >= 12 {
            level = .freezing
            tempRangeText = "0°C ~ 8°C (晚秋初冬抗寒)"
        } else if totalWarmth >= 9 {
            level = .cold
            tempRangeText = "6°C ~ 15°C (深秋降温保暖)"
        } else if totalWarmth >= 6 {
            level = .cool
            tempRangeText = "12°C ~ 20°C (春秋微凉防风)"
        } else if totalWarmth >= 4 {
            level = .comfortable
            tempRangeText = "18°C ~ 25°C (初秋舒爽)"
        } else {
            level = .hot
            tempRangeText = "26°C ~ 35°C (盛夏清凉)"
        }

        return OutfitPlan(
            level: level,
            calculatedApparentTemp: 15.0,
            inner: inner,
            midLayer: mid,
            outer: outer,
            bottom: bottom,
            accessory: nil,
            adviceSummary: "当前自主搭配适穿范围：\(tempRangeText)",
            periodAdvices: []
        )
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(uiColor: .systemGroupedBackground), Color(uiColor: .secondarySystemGroupedBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 1. 试衣间人物画布展示区
                        fittingCanvasCard

                        // 2. 层叠穿搭选择控制面板 (内搭 / 中层 / 外套 / 裤装)
                        garmentPickerSection
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("自由试衣间")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: resetToDefault) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.subheadline)
                    }
                }
            }
        }
    }

    // MARK: - 试衣间展示画布

    private var fittingCanvasCard: some View {
        VStack(spacing: 8) {
            ZStack {
                // 环境氛围发光
                Circle()
                    .fill(customPlan.level.accentColor.opacity(0.12))
                    .frame(width: 260, height: 260)
                    .blur(radius: 20)

                // 核心矢量拟真穿搭模型
                RealisticAvatarView(
                    plan: customPlan,
                    weather: nil,
                    gender: .men,
                    isJacketOpen: isJacketOpen
                )
            }
            .frame(height: 380)

            // 外套开闭切换与适温指示器
            HStack {
                // 适温药丸
                HStack(spacing: 4) {
                    Image(systemName: "thermometer.medium")
                        .font(.system(size: 11))
                    Text(customPlan.adviceSummary)
                        .font(.system(size: 11.5, weight: .semibold))
                }
                .foregroundStyle(customPlan.level.accentColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(customPlan.level.accentColor.opacity(0.12))
                .clipShape(Capsule())

                Spacer()

                if customPlan.outer != nil {
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            isJacketOpen.toggle()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: isJacketOpen ? "rectangle.split.2x1" : "rectangle.portrait.fill")
                                .font(.system(size: 10, weight: .bold))
                            Text(isJacketOpen ? "敞开门襟" : "拉上拉链")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(Color(uiColor: .systemBackground))
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal)
    }

    // MARK: - 各层单品选择控制区

    private var garmentPickerSection: some View {
        VStack(spacing: 14) {
            // 1. 贴身内搭选择
            layerControlRow(
                title: "1. 贴身内搭 (短T)",
                items: inners.map { $0.name },
                selectedIndex: Binding(get: { selectedInnerIndex }, set: { selectedInnerIndex = $0 })
            )

            // 2. 保暖中层选择 (可为无)
            layerControlRow(
                title: "2. 保暖中层 (卫衣/衬衫)",
                items: ["不穿中层"] + mids.map { $0.name },
                selectedIndex: Binding(get: { selectedMidIndex }, set: { selectedMidIndex = $0 })
            )

            // 3. 防风外套选择 (可为无)
            layerControlRow(
                title: "3. 防寒外套 (夹克/大衣)",
                items: ["不穿外套"] + outers.map { $0.name },
                selectedIndex: Binding(get: { selectedOuterIndex }, set: { selectedOuterIndex = $0 })
            )

            // 4. 下装长裤/短裤
            layerControlRow(
                title: "4. 潮流下装 (长裤/短裤)",
                items: bottoms.map { $0.name },
                selectedIndex: Binding(get: { selectedBottomIndex }, set: { selectedBottomIndex = $0 })
            )
        }
        .padding(.horizontal)
    }

    private func layerControlRow(title: String, items: [String], selectedIndex: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0..<items.count, id: \.self) { idx in
                        let isSelected = selectedIndex.wrappedValue == idx
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedIndex.wrappedValue = idx
                            }
                        }) {
                            Text(shortenTitle(items[idx]))
                                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(isSelected ? Color.blue : Color(uiColor: .systemBackground))
                                )
                                .foregroundStyle(isSelected ? .white : .primary)
                                .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }

    private func shortenTitle(_ full: String) -> String {
        full.replacingOccurrences(of: "经典", with: "")
            .replacingOccurrences(of: "保暖", with: "")
            .replacingOccurrences(of: "宽松直筒", with: "")
    }

    private func resetToDefault() {
        withAnimation(.spring()) {
            selectedInnerIndex = 0
            selectedMidIndex = 0
            selectedOuterIndex = 1
            selectedBottomIndex = 2
            isJacketOpen = true
        }
    }
}
