# OutfitOracle 🌤️👗

> 原生 iOS 天气智能穿搭推荐应用（完全对标 "Weather Fit"）
> 纯原生 SwiftUI (iOS 17+) + SwiftData + 免费全球实时气象引擎 + WidgetKit + 晨间智能通知推送

---

## ✨ 核心特性

- 📍 **实时气温与体感决策 (Weather Engine)**：
  - 支持免 API Key 的 **Open-Meteo** 全球实时天气源，包含实时气温、体感温度（Apparent Temp）、全天最高/最低温差、降水概率。
  - 保留 Apple 官方 **WeatherKit** 与离线 **Mock 仿真场景** 切换能力。
- 🧠 **穿搭推荐算法 (Outfit Engine)**：
  - 基于体感温度的 5 级穿衣体系（极寒严冬、寒冷冬日、微凉春秋、舒适宜人、炎炎夏日）。
  - **洋葱穿衣法则**：日温差 $\ge 9^\circ\text{C}$ 时自适应建议易穿脱外套。
  - **降水决策**：降水概率 $\ge 35\%$ 时自动推荐晴雨伞与防泼水单品。
  - **个人体质微调**：支持偏怕冷（倾向加衣）与偏怕热（倾向清凉）的体感阈值补偿。
  - **换一套 (Shuffle)**：支持在适穿区间内一键轮换不同组合。
- 🪞 **拟态虚拟形象试衣间 (Avatar Canvas)**：
  - 采用 `ZStack` 复合多图层叠加（环境光晕 -> 地台 -> 人模骨架 -> 内搭 -> 下装 -> 外套 -> 配件 -> 悬浮标牌）。
  - 预留了直接读取 Assets 自定义透明 PNG 的接口，未配置图片时由精细矢量几何体兜底渲染。
- 🔔 **晨间 7:30 智能推送 (UserNotifications)**：
  - 每日早晨准时触发当地温差与今日穿搭指引横幅。
  - 内置即刻测试推送机制（延迟 2 秒弹出）。
- 📱 **桌面小组件 (WidgetKit)**：
  - 支持 **Small**（紧凑图标行）与 **Medium**（天气概况 + 单品卡片）双尺寸。
- 🛠️ **GitHub Actions 0 元云端打包 CI/CD**：
  - 纯 Windows 开发者福音：云端 `macos-14` 自动化通过 XcodeGen 生成工程并编译免签名 `.ipa`，支持 TrollStore 巨魔、Sideloadly、爱思助手快速自签旁加载安装。

---

## 📂 项目结构

```text
OutfitOracle/
├── .github/workflows/
│   └── build-ios.yml            // GitHub Actions 自动编译与 IPA 打包流水线
├── project.yml                  // XcodeGen 项目工程定义描述文件
├── Info.plist                   // 定位与系统权限配置
├── OutfitOracleApp.swift        // SwiftUI 应用程序入口
├── IOS_INSTALL_GUIDE.md         // 详细的安装与云端打包指南
├── Core/
│   ├── Location/                // iOS 17 @Observable 定位管理器
│   ├── Notifications/           // 晨间 7:30 本地智能通知中心
│   ├── Recommendation/          // 穿衣等级、方案模型与推荐匹配算法引擎
│   ├── Wardrobe/                // SwiftData 持久化模型与四季预置衣橱单品库
│   ├── Weather/                 // Open-Meteo 免Key服务、WeatherKit与Mock服务
│   └── Widget/                  // WidgetKit 时间线、Small/Medium 小组件视图
└── Features/
    ├── Home/                    // 核心首页、动态渐变、天气概况、试衣间与轮播卡
    ├── Settings/                // 偏好设置、晨间提醒配置与测试面板
    ├── RecommendationTesting/   // 穿搭算法交互式压测控制台
    └── WeatherTesting/          // 气象服务多源热切换与实时诊断终端
```
