import Foundation
import UserNotifications

/// 本地通知管理服务 (每天早晨 7:30 智能穿搭推送)
public final class NotificationManager: NSObject, Sendable {
    public static let shared = NotificationManager()
    public static let dailyNotificationIdentifier = "com.outfitoracle.daily.morning.outfit"
    public static let testNotificationIdentifier = "com.outfitoracle.test.outfit"

    public override init() {
        super.init()
    }

    /// 请求通知授权
    public func requestAuthorization() async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("通知权限申请失败: \(error.localizedDescription)")
            return false
        }
    }

    /// 检查当前通知授权状态
    public func getAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }

    /// 设置每日早晨定时推送（默认 7:30）
    /// - Parameters:
    ///   - hour: 触发小时（默认 7）
    ///   - minute: 触发分钟（默认 30）
    ///   - weather: 当前可用天气
    ///   - plan: 当前计算的推荐穿搭方案
    ///   - city: 当前城市名称
    public func scheduleDailyMorningNotification(
        hour: Int = 7,
        minute: Int = 30,
        weather: WeatherSnapshot?,
        plan: OutfitPlan?,
        city: String = "您所在的地区"
    ) {
        let center = UNUserNotificationCenter.current()
        // 先移除旧的日常通知，避免重复排队
        center.removePendingNotificationRequests(withIdentifiers: [Self.dailyNotificationIdentifier])

        let content = buildNotificationContent(weather: weather, plan: plan, city: city)

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: Self.dailyNotificationIdentifier,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("注册每日早晨穿搭推送失败: \(error.localizedDescription)")
            } else {
                print("成功预约每日早晨 \(String(format: "%02d:%02d", hour, minute)) 穿搭推送！")
            }
        }
    }

    /// 立即触发一条测试推送（延迟 2 秒弹出，方便用户真机调试验证）
    public func sendImmediateTestNotification(
        weather: WeatherSnapshot?,
        plan: OutfitPlan?,
        city: String = "北京"
    ) {
        let center = UNUserNotificationCenter.current()
        let content = buildNotificationContent(weather: weather, plan: plan, city: city, isTest: true)

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
        let request = UNNotificationRequest(
            identifier: Self.testNotificationIdentifier,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("发送测试通知失败: \(error.localizedDescription)")
            } else {
                print("测试通知已加入队列，将在 2 秒后弹出。")
            }
        }
    }

    /// 取消所有待触发的定时通知
    public func cancelAllScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("已取消所有定时穿搭推送。")
    }

    // MARK: - 构建通知文案

    private func buildNotificationContent(
        weather: WeatherSnapshot?,
        plan: OutfitPlan?,
        city: String,
        isTest: Bool = false
    ) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = .default

        let prefix = isTest ? "[测试] " : ""
        content.title = "\(prefix)OutfitOracle 晨间穿搭指引"

        if let w = weather, let p = plan {
            let highInt = Int(round(w.dailyHigh))
            let lowInt = Int(round(w.dailyLow))
            let apparentInt = Int(round(w.apparentTemperature))
            let range = highInt - lowInt

            content.subtitle = "\(city) · 体感 \(apparentInt)°C (最高 \(highInt)°C / 最低 \(lowInt)°C)"

            // 构建穿搭组合摘要
            var outfitSummary = [p.inner.name]
            if let mid = p.midLayer { outfitSummary.append(mid.name) }
            if let outer = p.outer { outfitSummary.append(outer.name) }
            outfitSummary.append(p.bottom.name)
            let comboText = outfitSummary.joined(separator: " + ")

            var bodyText = "推荐穿搭：\(comboText)。"
            if range >= 9 {
                bodyText += " 今日温差较明显(\(range)°C)，出门建议备好易穿脱外套。"
            }
            if w.precipitationChance >= 0.35 {
                bodyText += " 预计有雨，出门记得带伞！"
            }
            content.body = bodyText
        } else {
            content.subtitle = "\(city) · 伴随清晨第一缕阳光"
            content.body = "今日最高温 21℃，早晚温差大，建议穿夹克+短袖。记得打开 App 查看专属穿搭！"
        }

        return content
    }
}
