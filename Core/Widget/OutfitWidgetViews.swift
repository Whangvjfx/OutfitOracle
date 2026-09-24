import SwiftUI
import WidgetKit

/// 桌面小组件 UI 视图构建器（支持 Small 与 Medium 尺寸）
public struct OutfitWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    public let entry: OutfitWidgetEntry

    public init(entry: OutfitWidgetEntry) {
        self.entry = entry
    }

    public var body: some View {
        switch family {
        case .systemSmall:
            smallWidgetView
        case .systemMedium:
            mediumWidgetView
        default:
            mediumWidgetView
        }
    }

    // MARK: - 1. Small 紧凑型桌面小组件

    private var smallWidgetView: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 顶栏：气温与图标
            HStack(alignment: .center) {
                Image(systemName: entry.symbolName)
                    .symbolRenderingMode(.multicolor)
                    .font(.title2)
                Spacer()
                Text("\(Int(round(entry.temperature)))°")
                    .font(.system(size: 28, weight: .light, design: .rounded))
            }

            // 体感温度与穿衣等级
            HStack(spacing: 4) {
                Text("体感 \(Int(round(entry.apparentTemperature)))°C")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.orange)
                
                Spacer()

                Text(entry.dressingLevelName)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color.orange.opacity(0.12))
            .clipShape(Capsule())

            Spacer()

            // 核心：今日推荐衣物 Icon 行
            VStack(alignment: .leading, spacing: 3) {
                Text("推荐穿搭")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)

                HStack(spacing: 6) {
                    ForEach(Array(entry.outfitItemSymbols.prefix(3).enumerated()), id: \.offset) { _, symbol in
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.12))
                                .frame(width: 26, height: 26)
                            Image(systemName: symbol)
                                .font(.system(size: 12))
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
        }
        .padding(12)
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(uiColor: .systemBackground), Color(uiColor: .secondarySystemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    // MARK: - 2. Medium 中号桌面小组件

    private var mediumWidgetView: some View {
        HStack(spacing: 14) {
            // 左半区：天气详情
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                    Text(entry.cityName)
                        .font(.caption)
                        .fontWeight(.bold)
                }

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(Int(round(entry.temperature)))")
                        .font(.system(size: 38, weight: .light, design: .rounded))
                    Text("°C")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 4) {
                    Image(systemName: "thermometer.sun.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Text("体感 \(String(format: "%.1f", entry.apparentTemperature))°")
                        .font(.system(size: 11, weight: .semibold))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2.5)
                .background(Color.orange.opacity(0.14))
                .clipShape(Capsule())

                Spacer()

                Text("高 \(Int(round(entry.dailyHigh)))° / 低 \(Int(round(entry.dailyLow)))°")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 100)

            Divider()

            // 右半区：穿衣等级与搭配单品卡片
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(entry.dressingLevelName)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.12))
                        .clipShape(Capsule())

                    Spacer()

                    Image(systemName: entry.symbolName)
                        .symbolRenderingMode(.multicolor)
                        .font(.subheadline)
                }

                // 推荐衣服单品小胶囊
                HStack(spacing: 8) {
                    ForEach(Array(zip(entry.outfitItemNames.prefix(3), entry.outfitItemSymbols.prefix(3))), id: \.0) { name, symbol in
                        VStack(spacing: 3) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(uiColor: .tertiarySystemFill))
                                    .frame(width: 34, height: 34)
                                Image(systemName: symbol)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.primary)
                            }
                            Text(name)
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .frame(width: 44)
                        }
                    }
                }

                Spacer()

                // 提示文案
                Text(entry.adviceSummary)
                    .font(.system(size: 9.5))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(uiColor: .systemBackground), Color(uiColor: .secondarySystemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}
