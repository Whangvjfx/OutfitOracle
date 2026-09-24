import SwiftUI

/// 阶段 2 穿搭算法与衣橱匹配测试视图
public struct RecommendationTestView: View {
    @State private var viewModel = RecommendationTestViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. 穿搭等级与综合建议卡片
                    if let plan = viewModel.currentPlan {
                        planHeaderCard(plan: plan)
                        matchedOutfitCard(plan: plan)
                    }

                    // 2. 交互式气温与条件模拟控制台
                    simulationControlsCard

                    // 3. 用户偏好与单品库概况
                    preferenceAndWardrobeCard
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("穿搭推荐引擎 (Phase 2)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            viewModel.shuffle()
                        }
                    }) {
                        Label("换一批", systemImage: "arrow.triangle.2.circlepath")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
            }
        }
    }

    // MARK: - Subviews

    private func planHeaderCard(plan: OutfitPlan) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: plan.level.iconSymbol)
                            .foregroundStyle(plan.level.accentColor)
                        Text(plan.level.rawValue)
                            .font(.title2)
                            .fontWeight(.bold)
                    }

                    Text("计算基准体感：\(String(format: "%.1f", plan.calculatedApparentTemp))°C")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button(action: {
                    withAnimation(.spring()) { viewModel.shuffle() }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "shuffle")
                        Text("换一批")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.12))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
                }
            }

            Divider()

            // 算法提示文案（温差/雨具/防风提示）
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)
                    .font(.footnote)
                    .padding(.top, 2)
                
                Text(plan.adviceSummary)
                    .font(.subheadline)
                    .foregroundStyle(Color(uiColor: .label))
            }
            .padding(10)
            .background(Color(uiColor: .tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(plan.level.layeringRule)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func matchedOutfitCard(plan: OutfitPlan) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("今日智能搭配组合")
                .font(.headline)
                .foregroundStyle(.secondary)

            VStack(spacing: 10) {
                // 贴身内搭
                clothingRow(categoryTitle: "贴身内搭", item: plan.inner, categoryColor: .orange)

                // 保暖中层
                if let mid = plan.midLayer {
                    clothingRow(categoryTitle: "保暖中层", item: mid, categoryColor: .yellow)
                }

                // 防风外套
                if let outer = plan.outer {
                    clothingRow(categoryTitle: "防风外套", item: outer, categoryColor: .blue)
                }

                // 舒适下装
                clothingRow(categoryTitle: "下身搭配", item: plan.bottom, categoryColor: .indigo)

                // 专属配件
                if let acc = plan.accessory {
                    clothingRow(categoryTitle: "贴心配件", item: acc, categoryColor: .purple)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func clothingRow(categoryTitle: String, item: ClothingItem, categoryColor: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: item.iconName.isEmpty ? item.category.sfSymbol : item.iconName)
                    .foregroundStyle(categoryColor)
                    .font(.system(size: 20))
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(item.name)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    if item.isWaterproof {
                        Image(systemName: "drop.degreesign.fill")
                            .font(.caption2)
                            .foregroundStyle(.blue)
                    }
                    if item.isWindproof {
                        Image(systemName: "wind")
                            .font(.caption2)
                            .foregroundStyle(.teal)
                    }
                }

                Text("\(categoryTitle) · 适穿区间: \(Int(item.minApparentTemp))°C ~ \(Int(item.maxApparentTemp))°C")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // 保暖星级
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: "flame.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(star <= item.warmthScore ? Color.orange : Color.gray.opacity(0.3))
                }
            }
        }
        .padding(10)
        .background(Color(uiColor: .tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var simulationControlsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("气温模拟滑块 (实时算法压测)")
                .font(.headline)
                .foregroundStyle(.secondary)

            // 体感温度调节滑块
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("模拟体感温度：")
                        .font(.subheadline)
                    Spacer()
                    Text("\(String(format: "%.1f", viewModel.apparentTemperature))°C")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(viewModel.apparentTemperature < 10 ? .blue : (viewModel.apparentTemperature > 25 ? .orange : .green))
                }

                Slider(value: $viewModel.apparentTemperature, in: -15...40, step: 0.5) { _ in
                    viewModel.recalculate()
                }
            }

            Divider()

            // 温差调节
            HStack {
                VStack(alignment: .leading) {
                    Text("今日最高: \(Int(viewModel.dailyHigh))°C")
                        .font(.caption)
                    Slider(value: $viewModel.dailyHigh, in: 0...45, step: 1.0) { _ in
                        viewModel.recalculate()
                    }
                }
                VStack(alignment: .leading) {
                    Text("今日最低: \(Int(viewModel.dailyLow))°C")
                        .font(.caption)
                    Slider(value: $viewModel.dailyLow, in: -20...30, step: 1.0) { _ in
                        viewModel.recalculate()
                    }
                }
            }

            // 降水概率
            HStack {
                Text("降水概率模拟: \(Int(viewModel.precipitationChance * 100))%")
                    .font(.caption)
                Spacer()
                Button(viewModel.precipitationChance > 0.4 ? "切换为晴天" : "切换为雨天") {
                    viewModel.precipitationChance = viewModel.precipitationChance > 0.4 ? 0.05 : 0.85
                    viewModel.recalculate()
                }
                .font(.caption)
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var preferenceAndWardrobeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("个人冷热体质校准")
                .font(.headline)
                .foregroundStyle(.secondary)

            Picker("体质偏好", selection: $viewModel.preference) {
                ForEach(ThermalPreference.allCases) { pref in
                    Text(pref.rawValue).tag(pref)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.preference) { _, _ in
                viewModel.recalculate()
            }

            HStack {
                Text("当前衣橱单品总数：")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(viewModel.wardrobeItems.count) 件 (已预置)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    RecommendationTestView()
}
