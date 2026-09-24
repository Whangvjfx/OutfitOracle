# OutfitOracle iOS 安装与构建指南

本项目支持在 **纯 Windows 环境** 下，通过 **GitHub Actions** 自动化完成 iOS 原生应用的云端编译，并直接输出可供旁加载安装的 `.ipa` 安装包，**全程无需 Mac 电脑，无需购买 99 美元/年的苹果开发者账号**。

---

## 🚀 方式一：触发 GitHub Actions 云端自动构建打包

### 1. 将项目推送到你的 GitHub 仓库
在 Windows 终端中，进入项目目录执行：
```powershell
cd C:\Users\wb686\.gemini\antigravity\scratch\OutfitOracle
git init
git add .
git commit -m "feat: complete OutfitOracle with automated iOS CI/CD"
git branch -M main
# 关联到你在 GitHub 新建的空仓库（例如 OutfitOracle）
git remote add origin https://github.com/<你的用户名>/OutfitOracle.git
git push -u origin main
```

### 2. 自动构建与下载 .ipa
1. 打开该 GitHub 仓库，点击顶部菜单的 **Actions** 标签页。
2. 你会看到名为 **"Build iOS IPA (OutfitOracle)"** 的工作流正在自动运行（运行在 Apple 官方的 `macos-14` 云端环境）。
3. 构建完成后（通常仅需约 2~3 分钟），在当前 Run 详情页底部的 **Artifacts** 区域，直接下载 **`OutfitOracle-iOS-IPA`**。
4. 解压下载的 zip 包即可得到 **`OutfitOracle.ipa`**。

> 💡 **提示（直接发布 Release）**：
> 如果你推送一个 Git 标签（例如 `git tag v1.0.0 && git push origin v1.0.0`），工作流会自动将 `.ipa` 附加到 GitHub Releases 页面，直接点击即可下载。

---

## 📱 方式二：将 .ipa 安装到 iPhone 手机

获得 `OutfitOracle.ipa` 后，可任选以下三种免费免付费开发者账号的方式安装到 iPhone：

### 方案 A：巨魔商店 (TrollStore) —— 【最推荐，永久可用】
*适用设备：iOS 14.0 ~ 17.0 等支持 TrollStore 漏洞的设备*
1. 将 `OutfitOracle.ipa` 通过微信文件传输助手、QQ 或局域网发送到 iPhone。
2. 在手机上点击该 `.ipa`，选择 **“用其他应用打开”** -> 选择 **TrollStore**。
3. 点击 **Install**，应用将直接完成系统级安装，**永不过期、无需 7 天重新签名、无证书掉签风险**。

### 方案 B：Sideloadly (Windows 电脑端免证书自签)
*适用设备：全版本 iOS 设备（包括 iOS 17/18+）*
1. 在 Windows 电脑下载并安装 [Sideloadly](https://sideloadly.io/)。
2. 用 USB 数据线将 iPhone 连接至电脑，信任电脑。
3. 打开 Sideloadly，将 `OutfitOracle.ipa` 拖拽到左侧图标区域。
4. 输入你个人的普通 Apple ID（仅用于自签，无需付费开发者账号）。
5. 点击 **Start**，等待进度条走完（约 30 秒）。
6. 在 iPhone 上进入 **设置 -> 通用 -> VPN 与设备管理**，找到你的 Apple ID 点击“信任此开发者证书”。
7. 开启 iPhone **设置 -> 隐私与安全性 -> 开发者模式**（重启后确认），即可打开使用。

### 方案 C：爱思助手 / AltStore
1. 打开爱思助手 Windows 版，连接手机。
2. 点击 **应用游戏 -> 导入安装**，选择 `OutfitOracle.ipa`。
3. 选择“使用个人 Apple ID 签名”，输入账号密码后点击签名并自动安装。

---

## ⚙️ 为什么本方案能做到 100% 免费与原生？
1. **气象服务**：我们弃用了需要 99 美元账号鉴权的 Apple WeatherKit，全面接入了免 Key、免注册、无商业限制的 **Open-Meteo 全球气象引擎**，脱壳和自签环境下依然能实时拉取当地精准体感气温与日温差。
2. **Xcode 工程构建**：采用 **XcodeGen**（`project.yml`）在 GitHub 云端动态生成规范的 Xcode 工程，彻底解决在 Windows 下无法维护 `.pbxproj` 复杂内部 ID 的痛点。
3. **免签名输出**：构建时指定 `CODE_SIGNING_ALLOWED=NO`，编译纯正的 ARM64 生产架构二进制，并封包为符合苹果规范的 `Payload/*.app`，自签工具均可 100% 成功注入并安装。
