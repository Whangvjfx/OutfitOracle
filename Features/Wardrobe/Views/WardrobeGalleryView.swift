import SwiftUI

/// 我的专属衣橱 (My Wardrobe) - 完整收录用户 18 款核心私服与系统扩展单品
public struct WardrobeGalleryView: View {
    @State private var selectedFilter: WardrobeFilter = .all
    @State private var selectedItemForDetail: ClothingItem? = nil

    private let customItems: [ClothingItem] = Array(WardrobeDefaults.initialItems.prefix(18))

    public init() {}

    public enum WardrobeFilter: String, CaseIterable, Identifiable {
        case all = "全部私服"
        case inner = "贴身短T"
        case mid = "保暖中层"
        case outer = "防风外套"
        case bottom = "潮流下装"

        public var id: String { rawValue }
    }

    private var filteredItems: [ClothingItem] {
        switch selectedFilter {
        case .all:
            return customItems
        case .inner:
            return customItems.filter { $0.category == .inner }
        case .mid:
            return customItems.filter { $0.category == .midLayer }
        case .outer:
            return customItems.filter { $0.category == .outer }
        case .bottom:
            return customItems.filter { $0.category == .bottom }
        }
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                // 背景暖灰渐变
                LinearGradient(
                    colors: [Color(uiColor: .systemGroupedBackground), Color(uiColor: .secondarySystemGroupedBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 1. 顶部概述统计横幅
                        headerSummaryBanner

                        // 2. 类别筛选胶囊栏
                        filterCapsuleBar

                        // 3. 专属单品列表网格
                        LazyVStack(spacing: 12) {
                            ForEach(filteredItems) { item in
                                itemCard(item: item)
                                    .onTapGesture {
                                        selectedItemForDetail = item
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("我的专属衣橱")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedItemForDetail) { item in
                itemDetailSheet(item: item)
            }
        }
    }

    // MARK: - 顶部统计卡片

    private var headerSummaryBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("哈尔滨四季专属衣物库")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.primary)
                    Text("已精细录入 18 款核心私服与温区特性")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Color.blue.gradient)
            }

            Divider()

            HStack(spacing: 16) {
                statPill(title: "短袖打底", count: "2 款", color: .orange)
                statPill(title: "保暖中层", count: "5 款", color: .yellow)
                statPill(title: "防风外套", count: "3 款", color: .blue)
                statPill(title: "裤装下装", count: "8 款", color: .indigo)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
        .padding(.horizontal)
    }

    private func statPill(title: String, count: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(count)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(color)
            Text(title)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 分类胶囊选择栏

    private var filterCapsuleBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(WardrobeFilter.allCases) { filter in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedFilter = filter
                        }
                    }) {
                        Text(filter.rawValue)
                            .font(.system(size: 12.5, weight: selectedFilter == filter ? .bold : .medium))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                Capsule()
                                    .fill(selectedFilter == filter ? Color.blue : Color(uiColor: .systemBackground))
                            )
                            .foregroundStyle(selectedFilter == filter ? .white : .primary)
                            .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - 单品卡片

    private func itemCard(item: ClothingItem) -> some View {
        HStack(spacing: 14) {
            // 左侧缩略彩色图标徽章
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: item.colorHex).opacity(0.18))
                    .frame(width: 54, height: 54)

                VStack(spacing: 1) {
                    if !item.customCode.isEmpty {
                        Text("#\(item.customCode.replacingOccurrences(of: "_38", with: ""))")
                            .font(.system(size: 9, weight: .black, design: .monospaced))
                            .foregroundStyle(.blue)
                    }
                    Image(systemName: item.iconName)
                        .font(.system(size: 18))
                        .foregroundStyle(Color(hex: item.colorHex))
                }
            }

            // 中间信息
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(item.name)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    if !item.brand.isEmpty {
                        Text(item.brand)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1.5)
                            .background(Color(uiColor: .secondarySystemFill))
                            .clipShape(Capsule())
                    }
                }

                HStack(spacing: 8) {
                    // 温度范围
                    HStack(spacing: 2) {
                        Image(systemName: "thermometer.medium")
                            .font(.system(size: 9))
                        Text("\(Int(item.minApparentTemp))°C ~ \(Int(item.maxApparentTemp))°C")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundStyle(.blue)

                    // 保暖星级
                    HStack(spacing: 1) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= item.warmthScore ? "flame.fill" : "flame")
                                .font(.system(size: 8))
                                .foregroundStyle(star <= item.warmthScore ? Color.orange : Color.gray.opacity(0.3))
                        }
                    }
                }

                // 穿搭定位说明
                Text(layerDesc(for: item))
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color(uiColor: .tertiaryLabel))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 1)
        )
    }

    private func layerDesc(for item: ClothingItem) -> String {
        switch item.category {
        case .inner:
            return "【贴身打底】夏季单穿，秋冬贴身吸汗保温"
        case .midLayer:
            return "【保暖中层】春秋单穿，深秋初冬叠穿锁温"
        case .outer:
            return "【防风防寒外壳】哈尔滨降温抗大风核心外套"
        case .bottom:
            return item.visualStyle == "shorts" ? "【夏当下装】轻便清凉" : "【主力下装】保暖抗风垂坠"
        case .accessory:
            return "【防护配饰】防雨抗寒"
        }
    }

    // MARK: - 单品详细信息 Sheet

    private func itemDetailSheet(item: ClothingItem) -> some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: item.colorHex).opacity(0.2))
                                    .frame(width: 80, height: 80)
                                Image(systemName: item.iconName)
                                    .font(.system(size: 36))
                                    .foregroundStyle(Color(hex: item.colorHex))
                            }

                            Text(item.name)
                                .font(.system(size: 17, weight: .bold))
                                .multilineTextAlignment(.center)

                            if !item.brand.isEmpty {
                                Text("品牌：\(item.brand)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }

                Section("核心穿着属性") {
                    HStack {
                        Text("服装层级")
                        Spacer()
                        Text(item.category.rawValue)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("适穿体感温区")
                        Spacer()
                        Text("\(Int(item.minApparentTemp))°C ~ \(Int(item.maxApparentTemp))°C")
                            .foregroundStyle(.blue)
                            .bold()
                    }
                    HStack {
                        Text("保暖指数")
                        Spacer()
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= item.warmthScore ? "flame.fill" : "flame")
                                    .foregroundStyle(star <= item.warmthScore ? Color.orange : Color.gray.opacity(0.3))
                            }
                            Text("（\(item.warmthScore)星）")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    HStack {
                        Text("防风性能")
                        Spacer()
                        Text(item.isWindproof ? "具备防风抗寒外壳" : "透气舒适")
                            .foregroundStyle(item.isWindproof ? .green : .secondary)
                    }
                }

                Section("哈尔滨穿搭实用指南") {
                    Text(detailedAdvice(for: item))
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }
            }
            .navigationTitle("单品详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") {
                        selectedItemForDetail = nil
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func detailedAdvice(for item: ClothingItem) -> String {
        if item.customCode == "79_38" {
            return "纯棉红框 CURE 艺术印花短T。夏季搭配工装短裤清爽透气；秋冬作为所有外套和毛衣的打底衫，贴身吸汗。"
        } else if item.customCode == "66_38" {
            return "杉杉军绿立领卫衣。薄款针织面料，14~24°C 单穿利落大方；天气转凉时作为轻薄内层或过渡中层。"
        } else if item.customCode == "68_38" {
            return "阿迪达斯经典浅灰圆领卫衣。复古三角拼领，单穿舒适百搭，外搭黑色小棉服或拼色冲锋衣视觉层次感强。"
        } else if item.customCode == "75_38" || item.customCode == "80_38" {
            return "保暖假两件毛衣。挺括白衬衫小翻领外露，省去穿两件的臃肿不适，保暖显精神，适合8~18°C日常外出。"
        } else if item.customCode == "76_38" {
            return "海澜之家蓝黄细格磨毛衬衫夹克。内里复合保暖抓绒，微凉时可当外套单穿，近零度时可作为派克大衣的二道保暖中层。"
        } else if item.customCode == "69_38" {
            return "沙漠拼灰机能连帽冲锋衣。抗秋凉挡大风的核心利器，版型挺括，内搭浅灰卫衣或T恤时尚利落。"
        } else if item.customCode == "77_38" {
            return "纯黑立领轻量双横拉链小棉服。内充轻薄保温棉层，比重磅大衣轻快便携，适合哈尔滨4~16°C降温防寒。"
        } else if item.customCode == "78_38" {
            return "重磅黑色工装派克大衣。4个立体大贴袋与连帽防风门襟，加厚绗缝保暖棉，是零度上下极寒天气的御寒王牌。"
        } else if item.customCode == "70_38" || item.customCode == "83_38" {
            return "深灰薄款休闲抽绳长裤。白色粗流苏抽绳自然下垂，面料轻薄垂坠无束缚，春秋14~25°C舒适自在。"
        } else if item.customCode == "72_38" {
            return "灰褐色细条纹灯芯绒长裤。左侧金属拉链与三角金属标，保暖挡风，色调高级，适合深秋降温天。"
        } else if item.customCode == "74_38" {
            return "1977 黑色高街束脚卫裤。高克重扎实保暖，束脚防灌风，搭配卫衣或冲锋衣美式运动感十足。"
        } else if item.customCode == "81_38" {
            return "经典深蓝宽松直筒牛仔裤。黄色明车线，纯棉挺括抗风，四季百搭。"
        }
        return "优质衣橱单品，根据当日天气与温差智能组合，提供最体贴的体感温度守护。"
    }
}

// Color Hex Extension
private extension Color {
    init(hex: String) {
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
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
