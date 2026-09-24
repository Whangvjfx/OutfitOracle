import SwiftUI

/// 一天内分时段穿衣建议与 24 小时气象演变视图 (解决全天温差与动态穿搭)
public struct DaytimeTimelineView: View {
    public let plan: OutfitPlan?
    public let weather: WeatherSnapshot?

    public init(plan: OutfitPlan?, weather: WeatherSnapshot?) {
        self.plan = plan
        self.weather = weather
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // 标题栏
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "clock.arrow.2.circlepath")
                        .foregroundStyle(.blue)
                    Text("全天动态穿衣指南")
                        .font(.headline)
                        .fontWeight(.bold)
                }

                Spacer()

                Text("早晚温差自适应")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.12))
                    .clipShape(Capsule())
            }

            // 1. 一天 4 个核心时段建议卡片网格
            if let periods = plan?.periodAdvices, !periods.isEmpty {
                VStack(spacing: 8) {
                    ForEach(periods) { item in
                        periodRowCard(item)
                    }
                }
            }

            // 2. 24 小时逐小时气温与降水横向时间轴
            if let hourly = weather?.hourlyList, !hourly.isEmpty {
                Divider()
                    .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text("未来 24 小时体感与气象变化")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(hourly) { h in
                                hourlyItemCard(h)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }

    private func periodRowCard(_ item: DaytimePeriodAdvice) -> some View {
        HStack(alignment: .center, spacing: 10) {
            ZStack {
                Circle()
                    .fill(periodColor(for: item.periodName).opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: item.iconSymbol)
                    .font(.system(size: 16))
                    .foregroundStyle(periodColor(for: item.periodName))
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(item.periodName)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(item.timeRange)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    
                    Spacer()

                    Text("体感 \(Int(round(item.averageApparentTemp)))°C")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(periodColor(for: item.periodName))
                }

                Text(item.dressingAction)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Text(item.details)
                    .font(.system(size: 10.5))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .background(Color(uiColor: .tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func hourlyItemCard(_ h: HourlyWeather) -> some View {
        VStack(spacing: 4) {
            Text(h.hourString)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)

            Image(systemName: h.symbolName)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 18))
                .frame(height: 22)

            Text("\(Int(round(h.temperature)))°")
                .font(.system(size: 12, weight: .semibold, design: .rounded))

            Text("体感\(Int(round(h.apparentTemperature)))°")
                .font(.system(size: 9))
                .foregroundStyle(.orange)

            if h.precipitationChance > 0 {
                HStack(spacing: 1) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 7))
                    Text("\(Int(h.precipitationChance * 100))%")
                        .font(.system(size: 8))
                }
                .foregroundStyle(.blue)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .frame(width: 58)
        .background(Color(uiColor: .tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func periodColor(for name: String) -> Color {
        if name.contains("早晨") { return .orange }
        if name.contains("午间") { return .red }
        if name.contains("傍晚") { return .indigo }
        return .blue
    }
}
