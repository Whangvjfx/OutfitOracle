import SwiftUI

/// OutfitOracle 核心主界面 (全面优化：消除黑边、支持全国/哈尔滨城市切换、全天分时段穿衣建议、高逼真人物试衣间、性别选择)
public struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var showingPreferenceSheet = false
    @State private var showingNotificationSheet = false
    @State private var showingCityPicker = false

    public init() {}

    public var body: some View {
        NavigationStack {
            ZStack {
                // 动态全屏背景渐变色
                backgroundGradient
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 1. 顶部天气概况与温差标尺 (点击城市可手动切换全国/哈尔滨)
                        WeatherHeaderView(
                            cityName: viewModel.locationManager.currentCity,
                            weather: viewModel.weather,
                            isLoading: viewModel.isLoading,
                            onRefresh: {
                                Task { await viewModel.loadData() }
                            },
                            onTapCity: {
                                showingCityPicker = true
                            }
                        )
                        .padding(.horizontal)

                        // 2. 核心视觉区：ZStack 高拟真真实人物穿搭试衣间 (内穿短袖/外穿夹克清晰可见)
                        AvatarDisplayView(
                            plan: viewModel.currentPlan,
                            weather: viewModel.weather,
                            gender: viewModel.genderPreference
                        )
                        .padding(.horizontal)

                        // 3. 一天内动态穿衣指南 (早晨通勤、午间暖阳、傍晚归途、夜间防寒 + 24小时逐小时变化)
                        DaytimeTimelineView(
                            plan: viewModel.currentPlan,
                            weather: viewModel.weather
                        )
                        .padding(.horizontal)

                        // 4. 底部单品横向轮播卡片与“换一套”
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
                    .padding(.top, 4)
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
            // 偏好设置弹窗 (体质冷热 + 男女装风格)
            .sheet(isPresented: $showingPreferenceSheet) {
                preferenceSheetView
            }
            // 晨间推送弹窗
            .sheet(isPresented: $showingNotificationSheet) {
                NotificationSettingsView(
                    weather: viewModel.weather,
                    plan: viewModel.currentPlan,
                    cityName: viewModel.locationManager.currentCity
                )
            }
            // 城市选择弹窗 (覆盖全国，支持哈尔滨等)
            .sheet(isPresented: $showingCityPicker) {
                CityPickerView(
                    currentSelectedCity: viewModel.locationManager.selectedCity,
                    onSelectCity: { city in
                        Task {
                            await viewModel.changeCity(city)
                        }
                    }
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

    // MARK: - 偏好设置半屏弹窗 (男女穿搭风格 + 冷热体质)

    private var preferenceSheetView: some View {
        NavigationStack {
            List {
                Section {
                    Picker("穿搭风格倾向", selection: Binding(
                        get: { viewModel.genderPreference },
                        set: { viewModel.setGenderPreference($0) }
                    )) {
                        ForEach(GenderCategory.allCases) { g in
                            Label(g.rawValue, systemImage: g.iconSymbol).tag(g)
                        }
                    }
                    .pickerStyle(.inline)
                } header: {
                    Text("穿搭性别与风格")
                } footer: {
                    Text("切换为「男士风尚」将重点匹配衬衫、工装夹克、连帽卫衣、直筒牛仔裤；切换为「女士优雅」将重点匹配呢大衣、法式开衫、羊毛裙、阔腿裤等。")
                }

                Section {
                    Picker("体质偏好", selection: Binding(
                        get: { viewModel.preference },
                        set: { viewModel.setThermalPreference($0) }
                    )) {
                        ForEach(ThermalPreference.allCases) { pref in
                            Text(pref.rawValue).tag(pref)
                        }
                    }
                    .pickerStyle(.inline)
                } header: {
                    Text("冷热体质个性化调节")
                } footer: {
                    Text("OutfitOracle 会根据您的冷热体质，在算法计算时微调体感温度触发阈值，为您定制更舒适的穿搭推荐。")
                }
            }
            .navigationTitle("偏好设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { showingPreferenceSheet = false }
                }
            }
        }
        .presentationDetents([.medium, .large])
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
