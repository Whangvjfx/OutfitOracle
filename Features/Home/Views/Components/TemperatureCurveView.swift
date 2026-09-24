import SwiftUI

/// 顶部温差曲线与气温进展标尺视图
public struct TemperatureCurveView: View {
    public let currentTemp: Double
    public let dailyLow: Double
    public let dailyHigh: Double

    public init(currentTemp: Double, dailyLow: Double, dailyHigh: Double) {
        self.currentTemp = currentTemp
        self.dailyLow = dailyLow
        self.dailyHigh = dailyHigh
    }

    public var body: some View {
        VStack(spacing: 6) {
            // 温度标尺进度条
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let range = max(dailyHigh - dailyLow, 1.0)
                let clampedCurrent = min(max(currentTemp, dailyLow), dailyHigh)
                let progress = CGFloat((clampedCurrent - dailyLow) / range)
                let currentIndicatorX = totalWidth * progress

                ZStack(alignment: .leading) {
                    // 背景渐变轨道
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.6),
                                    Color.teal.opacity(0.7),
                                    Color.orange.opacity(0.8),
                                    Color.red.opacity(0.7)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 6)

                    // 当前气温指示圆点与外发光
                    Circle()
                        .fill(Color.white)
                        .frame(width: 14, height: 14)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                        .overlay(
                            Circle()
                                .stroke(Color.orange, lineWidth: 2.5)
                        )
                        .offset(x: max(0, min(currentIndicatorX - 7, totalWidth - 14)))
                }
            }
            .frame(height: 14)

            // 两端最低/最高标尺文本
            HStack {
                Text("最低 \(Int(round(dailyLow)))°")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Spacer()

                Text("温差 \(Int(round(dailyHigh - dailyLow)))°C")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.12))
                    .clipShape(Capsule())

                Spacer()

                Text("最高 \(Int(round(dailyHigh)))°")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    TemperatureCurveView(currentTemp: 18.0, dailyLow: 11.0, dailyHigh: 24.0)
        .padding()
}
