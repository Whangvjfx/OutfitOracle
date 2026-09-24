import SwiftUI

/// 阶段 1：基础天气测试与诊断看板
public struct WeatherTestView: View {
    @State private var viewModel = WeatherTestViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 数据源选择器与模式配置
                    providerSelectionCard

                    // 定位与核心天气数据展示卡片
                    if let weather = viewModel.weather {
                        weatherDisplayCard(weather: weather)
                        weatherMetricsGrid(weather: weather)
                    } else if viewModel.isLoading {
                        loadingCard
                    } else if let error = viewModel.errorMessage {
                        errorCard(error: error)
                    } else {
                        emptyPromptCard
                    }

                    // 实时调试日志终端窗
                    debugConsoleCard
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("OutfitOracle 诊断看板")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task { await viewModel.startFetchingProcess() }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .task {
                // 首次加载自动尝试获取
                if viewModel.weather == nil {
                    await viewModel.startFetchingProcess()
                }
            }
        }
    }

    // MARK: - Subviews

    private var providerSelectionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("天气服务源")
                .font(.headline)
                .foregroundStyle(.secondary)

            Picker("服务类型", selection: $viewModel.selectedProviderType) {
                ForEach(WeatherTestViewModel.ActiveProviderType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)

            if viewModel.selectedProviderType == .mockData {
                VStack(alignment: .leading, spacing: 6) {
                    Text("模拟温度场景：")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Picker("模拟场景", selection: $viewModel.mockScenario) {
                        Text("极寒 (-6.5°C)").tag(MockWeatherService.PresetScenario.freezingWinter)
                        Text("凉爽 (15°C)").tag(MockWeatherService.PresetScenario.coolAutumn)
                        Text("舒适 (22.5°C)").tag(MockWeatherService.PresetScenario.warmSpring)
                        Text("炎热 (38°C)").tag(MockWeatherService.PresetScenario.hotSummer)
                        Text("雨天 (16°C)").tag(MockWeatherService.PresetScenario.rainyDay)
                    }
                    .pickerStyle(.menu)
                }
            }

            Button(action: {
                Task { await viewModel.startFetchingProcess() }
            }) {
                HStack {
                    Spacer()
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "location.fill")
                        Text("刷新当前位置与天气")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(viewModel.isLoading)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func weatherDisplayCard(weather: WeatherSnapshot) -> some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Label(viewModel.locationManager.currentCity, systemImage: "mappin.and.ellipse")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("更新时间: \(weather.updatedAt.formatted(date: .omitted, time: .standard))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: weather.symbolName)
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 44))
            }

            Divider()

            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading) {
                    Text("\(Int(round(weather.temperature)))°")
                        .font(.system(size: 64, weight: .thin))
                    Text(weather.conditionDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // 核心：体感温度标识
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "thermometer.sun.fill")
                            .foregroundStyle(.orange)
                        Text("体感 \(String(format: "%.1f", weather.apparentTemperature))°C")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.15))
                    .clipShape(Capsule())

                    Text("最高 \(Int(round(weather.dailyHigh)))°  最低 \(Int(round(weather.dailyLow)))°")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func weatherMetricsGrid(weather: WeatherSnapshot) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            metricItem(
                title: "降水概率",
                value: "\(Int(weather.precipitationChance * 100))%",
                icon: "drop.fill",
                color: .blue
            )
            metricItem(
                title: "相对湿度",
                value: "\(Int(weather.humidity * 100))%",
                icon: "humidity.fill",
                color: .teal
            )
            metricItem(
                title: "风速",
                value: "\(String(format: "%.1f", weather.windSpeed)) m/s",
                icon: "wind",
                color: .indigo
            )
            metricItem(
                title: "穿衣判定参考基准",
                value: "\(String(format: "%.1f", weather.apparentTemperature))°C",
                icon: "tshirt.fill",
                color: .purple
            )
        }
    }

    private func metricItem(title: String, value: String, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.headline)
            }
            Spacer()
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var loadingCard: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
            Text("正在获取 GPS 坐标与气象数据...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func errorCard(error: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.yellow)
                Text("请求异常")
                    .font(.headline)
            }
            Text(error)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var emptyPromptCard: some View {
        VStack(spacing: 8) {
            Image(systemName: "cloud.sun")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("点击上方按钮开始获取天气")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var debugConsoleCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("实时诊断控制台 (Console)", systemImage: "terminal.fill")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                Spacer()

                Button("清空") {
                    viewModel.clearLogs()
                }
                .font(.caption2)
                .buttonStyle(.bordered)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    if viewModel.debugLogs.isEmpty {
                        Text("暂无日志输出...")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(Array(viewModel.debugLogs.enumerated()), id: \.offset) { _, log in
                            Text(log)
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(Color(uiColor: .label))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(8)
            }
            .frame(height: 160)
            .background(Color(uiColor: .tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    WeatherTestView()
}
