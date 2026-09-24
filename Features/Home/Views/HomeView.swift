import SwiftUI

/// OutfitOracle 核心主界面 (Phase 3: UI/UX & 虚拟形象展示)
public struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var showingPreferenceSheet = false
    @State private var showingNotificationSheet = false

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                // 动态全屏背景渐变色
                backgroundGradient
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 顶部天气概况与温差标尺
                        WeatherHeaderView(
                            cityName: viewModel.locationManager.currentCity,
                            weather: viewModel.weather,
                            isLoading: viewModel.isLoading,
                            onRefresh: {
                                Task { await viewModel.loadData() }
                            }
                        )
                        .padding(.horizontal)

                        // 核心视觉区：ZStack 多图层虚拟形象换装
                        AvatarDisplayView(
                            plan: viewModel.currentPlan,
                            weather: viewModel.weather
                        )
                        .padding(.horizontal)

                        // 底部单品横向轮播卡片与“换一套”
                        OutfitItemsCarouselView(
                            plan: viewModel.currentPlan,
                            onShuffle: {
                                triggerHaptic()
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    viewModel.shuffleOutfit()
                                }
                            }
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                    .padding(.top, 8)
                }
                .refreshable {
                    await viewModel.loadData()
                }
            }
            .navigationTitle("OutfitOracle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 12) {
                        Button(action: { showingPreferenceSheet = true }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                        }

                        Button(action: { showingNotificationSheet = true }) {
                            Image(systemName: "bell.badge")
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if let level = viewModel.currentPlan?.level {
                        Text(level.rawValue)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(level.accentColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(level.accentColor.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
            }
            .sheet(isPresented: $showingPreferenceSheet) {
                preferenceSheetView
            }
            .sheet(isPresented: $showingNotificationSheet) {
                NotificationSettingsView(
                    weather: viewModel.weather,
                    plan: viewModel.currentPlan,
                    cityName: viewModel.locationManager.currentCity
                )
            }
            .task {
                if viewModel.weather == nil {
                    await viewModel.loadData()
                }
            }
        }
    }

    // MARK: - 动态背景渐变

    private var backgroundGradient: some View {
        let colors: [Color] = {
            guard let level = viewModel.currentPlan?.level else {
                return [Color(uiColor: .systemGroupedBackground), Color(uiColor: .secondarySystemGroupedBackground)]
            }
            switch level {
            case .freezing:
                return [Color.cyan.opacity(0.18), Color.blue.opacity(0.12), Color(uiColor: .systemGroupedBackground)]
            case .cold:
                return [Color.blue.opacity(0.16), Color.teal.opacity(0.08), Color(uiColor: .systemGroupedBackground)]
            case .cool:
                return [Color.teal.opacity(0.15), Color.mint.opacity(0.08), Color(uiColor: .systemGroupedBackground)]
            case .comfortable:
                return [Color.green.opacity(0.14), Color.yellow.opacity(0.06), Color(uiColor: .systemGroupedBackground)]
            case .hot:
                return [Color.orange.opacity(0.18), Color.yellow.opacity(0.08), Color(uiColor: .systemGroupedBackground)]
            }
        }()

        return LinearGradient(
            colors: colors,
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - 偏好设置半屏弹窗

    private var preferenceSheetView: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("冷热体质个性化调节")
                    .font(.headline)

                Text("OutfitOracle 会根据您的冷热体质，在算法计算时微调体感温度触发阈值，为您定制更舒适的穿搭推荐。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Picker("体质偏好", selection: $viewModel.preference) {
                    ForEach(ThermalPreference.allCases) { pref in
                        Text(pref.rawValue).tag(pref)
                    }
                }
                .pickerStyle(.inline)
                .onChange(of: viewModel.preference) { _, _ in
                    withAnimation {
                        viewModel.calculatePlan()
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("偏好设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { showingPreferenceSheet = false }
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
}

#Preview {
    HomeView()
}
