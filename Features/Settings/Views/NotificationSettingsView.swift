import SwiftUI
import UserNotifications

/// 阶段 4：晨间推送与小组件配置面板
public struct NotificationSettingsView: View {
    public let weather: WeatherSnapshot?
    public let plan: OutfitPlan?
    public let cityName: String

    @State private var isNotificationEnabled = false
    @State private var selectedTime = Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date()) ?? Date()
    @State private var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @State private var statusToast: String?

    public init(weather: WeatherSnapshot?, plan: OutfitPlan?, cityName: String) {
        self.weather = weather
        self.plan = plan
        self.cityName = cityName
    }

    public var body: some View {
        NavigationStack {
            List {
                // 1. 晨间智能推送管理
                Section {
                    Toggle("开启每日晨间穿搭推送", isOn: $isNotificationEnabled)
                        .onChange(of: isNotificationEnabled) { _, enabled in
                            handleToggleChanged(enabled)
                        }

                    if isNotificationEnabled {
                        DatePicker("推送时间", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .onChange(of: selectedTime) { _, newDate in
                                reschedule(for: newDate)
                            }

                        Button(action: sendTestNotification) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                    .foregroundStyle(.blue)
                                Text("立即发送一条测试推送")
                                    .foregroundStyle(.blue)
                                Spacer()
                                Text("延迟2秒")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("晨间穿搭提醒")
                } footer: {
                    Text("开启后，系统将在设定时间自动触发本地推送（如：每天早晨 7:30 提醒今日温差、体感温度与推荐穿搭组合）。无需保持 App 前台运行。")
                }

                // 2. 推送预览效果示范
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "bell.badge.fill")
                                .foregroundStyle(.red)
                            Text("OutfitOracle 晨间穿搭指引")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("刚刚")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }

                        Text("\(cityName) · 体感 19°C (最高 22°C / 最低 11°C)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)

                        Text("今日穿搭：基础纯棉短袖T恤 + 工装防风立领夹克 + 厚磅经典直筒牛仔裤。今日温差较大(11°C)，出门建议备好易穿脱外套。")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("推送样式预览")
                }

                // 3. 桌面小组件指引
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("支持 Small (紧凑) 与 Medium (适中) 两种尺寸。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            VStack {
                                Image(systemName: "square.fill")
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                                Text("Small 尺寸")
                                    .font(.caption2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(uiColor: .tertiarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                            VStack {
                                Image(systemName: "rectangle.fill")
                                    .font(.title2)
                                    .foregroundStyle(.teal)
                                Text("Medium 尺寸")
                                    .font(.caption2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(uiColor: .tertiarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("WidgetKit 桌面小组件")
                } footer: {
                    Text("长按 iPhone 桌面空白处进入编辑模式，点击左上角「+」搜索「OutfitOracle」即可添加小组件。")
                }
            }
            .navigationTitle("通知与小组件 (Phase 4)")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await checkAuthorization()
            }
            .overlay(alignment: .bottom) {
                if let toast = statusToast {
                    Text(toast)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(radius: 6)
                        .padding(.bottom, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }

    // MARK: - 逻辑处理

    private func checkAuthorization() async {
        authorizationStatus = await NotificationManager.shared.getAuthorizationStatus()
        isNotificationEnabled = (authorizationStatus == .authorized)
    }

    private func handleToggleChanged(_ enabled: Bool) {
        if enabled {
            Task {
                let granted = await NotificationManager.shared.requestAuthorization()
                if granted {
                    reschedule(for: selectedTime)
                    showToast("已成功开启每日早晨推送！")
                } else {
                    isNotificationEnabled = false
                    showToast("未获取到系统通知权限，请在系统设置中允许。")
                }
            }
        } else {
            NotificationManager.shared.cancelAllScheduledNotifications()
            showToast("已关闭每日晨间推送。")
        }
    }

    private func reschedule(for date: Date) {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        NotificationManager.shared.scheduleDailyMorningNotification(
            hour: hour,
            minute: minute,
            weather: weather,
            plan: plan,
            city: cityName
        )
    }

    private func sendTestNotification() {
        NotificationManager.shared.sendImmediateTestNotification(
            weather: weather,
            plan: plan,
            city: cityName
        )
        showToast("测试通知已发送！请退到桌面查看横幅。")
    }

    private func showToast(_ message: String) {
        withAnimation {
            statusToast = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                statusToast = nil
            }
        }
    }
}
