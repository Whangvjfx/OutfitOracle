import SwiftUI
import SwiftData

@main
struct OutfitOracleApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("今日穿搭", systemImage: "sparkles")
                    }

                WardrobeGalleryView()
                    .tabItem {
                        Label("我的衣橱", systemImage: "tshirt.fill")
                    }

                FittingRoomView()
                    .tabItem {
                        Label("试衣间", systemImage: "figure.arms.open")
                    }

                RecommendationTestView()
                    .tabItem {
                        Label("算法压测", systemImage: "slider.horizontal.2.square")
                    }
            }
            .tint(.blue)
        }
        .modelContainer(for: ClothingItem.self)
    }
}
