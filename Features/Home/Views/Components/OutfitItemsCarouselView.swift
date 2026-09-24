import SwiftUI

/// 底部滑动卡片区：今日推荐单品横向轮播与“换一批”
public struct OutfitItemsCarouselView: View {
    public let plan: OutfitPlan?
    public let onShuffle: () -> Void

    public init(plan: OutfitPlan?, onShuffle: @escaping () -> Void) {
        self.plan = plan
        self.onShuffle = onShuffle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // 顶部提示文案与“换一批”动作条
            HStack(alignment: .center) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.orange)
                    Text("今日穿搭清单")
                        .font(.headline)
                        .fontWeight(.bold)
                }

                Spacer()

                Button(action: onShuffle) {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("换一套")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                }
            }

            // 智能穿衣指导胶囊
            if let advice = plan?.adviceSummary {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                        .padding(.top, 2)
                    Text(advice)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(uiColor: .tertiarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }

            // 单品横向轮播卡片
            if let items = plan?.allItems, !items.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(items, id: \.id) { item in
                            itemCard(item: item)
                        }
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 2)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: -4)
        )
    }

    private func itemCard(item: ClothingItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // 图标与分类标签
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(categoryColor(for: item.category).opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: item.iconName.isEmpty ? item.category.sfSymbol : item.iconName)
                        .font(.system(size: 18))
                        .foregroundStyle(categoryColor(for: item.category))
                }

                Spacer()

                Text(item.category.rawValue)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(categoryColor(for: item.category))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(categoryColor(for: item.category).opacity(0.12))
                    .clipShape(Capsule())
            }

            // 单品名称
            Text(item.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 温区标签
            Text("\(Int(item.minApparentTemp))°C ~ \(Int(item.maxApparentTemp))°C")
                .font(.system(size: 10))
                .foregroundStyle(.secondary)

            // 属性徽章（防风/防水）
            HStack(spacing: 4) {
                if item.isWaterproof {
                    attributeBadge(text: "防水", color: .blue)
                }
                if item.isWindproof {
                    attributeBadge(text: "防风", color: .teal)
                }
                Spacer()
                // 保暖星级
                HStack(spacing: 1.5) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: "flame.fill")
                            .font(.system(size: 7))
                            .foregroundStyle(star <= item.warmthScore ? Color.orange : Color.gray.opacity(0.25))
                    }
                }
            }
        }
        .padding(12)
        .frame(width: 155, height: 135)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private func attributeBadge(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 8, weight: .bold))
            .foregroundStyle(color)
            .padding(.horizontal, 4)
            .padding(.vertical, 1.5)
            .background(color.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private func categoryColor(for category: ClothingCategory) -> Color {
        switch category {
        case .inner: return .orange
        case .midLayer: return .yellow
        case .outer: return .blue
        case .bottom: return .indigo
        case .accessory: return .purple
        }
    }
}
