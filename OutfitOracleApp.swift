import SwiftUI
import SwiftData

@main
struct OutfitOracleApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("今日穿搭", systemImage: "figure.walk")
                    }

                RecommendationTestView()
                    .tabItem {
                        Label("算法压测", systemImage: "slider.horizontal.2.square")
                    }

                WeatherTestView()
                    .tabItem {
                        Label("气象引擎", systemImage: "cloud.sun.fill")
                    }
            }
            .tint(.blue)
        }
        .modelContainer(for: ClothingItem.self)
    }
}
