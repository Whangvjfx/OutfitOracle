import SwiftUI

/// 首页顶部天气概况与温差看板（支持点击切换全国城市）
public struct WeatherHeaderView: View {
    public let cityName: String
    public let weather: WeatherSnapshot?
    public let isLoading: Bool
    public let onRefresh: () -> Void
    public let onTapCity: () -> Void

    public init(
        cityName: String,
        weather: WeatherSnapshot?,
        isLoading: Bool,
        onRefresh: @escaping () -> Void,
        onTapCity: @escaping () -> Void
    ) {
        self.cityName = cityName
        self.weather = weather
        self.isLoading = isLoading
        self.onRefresh = onRefresh
        self.onTapCity = onTapCity
    }

    public var body: some View {
        VStack(spacing: 14) {
            // 顶栏：城市点击切换与日期 + 刷新按钮
            HStack(alignment: .center) {
                Button(action: onTapCity) {
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.subheadline)
                            .foregroundStyle(.blue)

                        Text(cityName)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)

                        Image(systemName: "chevron.down.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                HStack(spacing: 8) {
                    Text(formattedDate())
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Button(action: onRefresh) {
                        Image(systemName: "arrow.clockwise")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                            .rotationEffect(.degrees(isLoading ? 360 : 0))
                            .animation(isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isLoading)
                            .padding(7)
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(Circle())
                    }
                    .disabled(isLoading)
                }
            }

            if let w = weather {
                // 核心气温与体感看板
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(Int(round(w.temperature)))")
                                .font(.system(size: 52, weight: .light, design: .rounded))
                            Text("°C")
                                .font(.title2)
                                .fontWeight(.light)
                                .foregroundStyle(.secondary)
                        }

                        // 核心：体感温度指示条
                        HStack(spacing: 4) {
                            Image(systemName: "thermometer.sun.fill")
                                .font(.caption)
                                .foregroundStyle(.orange)
                            Text("体感 \(String(format: "%.1f", w.apparentTemperature))°C")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.orange.opacity(0.16))
                        .clipShape(Capsule())
                    }

                    Spacer()

                    // 天气图标与状态描述
                    VStack(alignment: .trailing, spacing: 4) {
                        Image(systemName: w.symbolName)
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 40))
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                        Text(w.conditionDescription)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)

                        if w.precipitationChance > 0 {
                            HStack(spacing: 3) {
                                Image(systemName: "drop.fill")
                                    .font(.caption2)
                                Text("\(Int(w.precipitationChance * 100))%")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                            }
                            .foregroundStyle(.blue)
                        }
                    }
                }

                // 温差曲线与标尺条
                TemperatureCurveView(
                    currentTemp: w.temperature,
                    dailyLow: w.dailyLow,
                    dailyHigh: w.dailyHigh
                )
            } else if isLoading {
                HStack {
                    Spacer()
                    ProgressView("正在同步气象数据...")
                        .font(.caption)
                    Spacer()
                }
                .padding(.vertical, 16)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
        )
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "M月d日 EEEE"
        return formatter.string(from: Date())
    }
}
