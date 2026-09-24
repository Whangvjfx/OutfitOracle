import SwiftUI

/// 城市切换选择面板（支持搜索、热门城市速选与分区浏览）
public struct CityPickerView: View {
    @Environment(\.dismiss) private var dismiss
    public let currentSelectedCity: CityModel
    public let onSelectCity: (CityModel) -> Void

    @State private var searchText: String = ""

    public init(
        currentSelectedCity: CityModel,
        onSelectCity: @escaping (CityModel) -> Void
    ) {
        self.currentSelectedCity = currentSelectedCity
        self.onSelectCity = onSelectCity
    }

    private var filteredCities: [CityModel] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return CityDatabase.allCities
        }
        let lower = searchText.lowercased()
        return CityDatabase.allCities.filter {
            $0.name.contains(searchText) ||
            $0.province.contains(searchText) ||
            $0.pinyin.lowercased().contains(lower)
        }
    }

    public var body: some View {
        NavigationStack {
            List {
                // 1. 当前所在/已选城市
                Section {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(currentSelectedCity.name)
                                .font(.headline)
                            Text("\(currentSelectedCity.province) · \(currentSelectedCity.region)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text("当前使用")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.12))
                            .foregroundStyle(.blue)
                            .clipShape(Capsule())
                    }
                    .padding(.vertical, 2)
                } header: {
                    Text("当前选择")
                }

                // 2. 热门城市快捷标签
                if searchText.isEmpty {
                    Section {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                            ForEach(CityDatabase.hotCities) { city in
                                Button(action: {
                                    onSelectCity(city)
                                    dismiss()
                                }) {
                                    Text(city.name)
                                        .font(.subheadline)
                                        .fontWeight(city.name == currentSelectedCity.name ? .bold : .regular)
                                        .foregroundStyle(city.name == currentSelectedCity.name ? .white : .primary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(city.name == currentSelectedCity.name ? Color.blue : Color(uiColor: .tertiarySystemFill))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    } header: {
                        Text("🔥 热门与重点城市 (点击速选)")
                    }
                }

                // 3. 城市列表（搜索结果或大区列表）
                if searchText.isEmpty {
                    ForEach(CityDatabase.groupedByRegion.keys.sorted(), id: \.self) { region in
                        if let list = CityDatabase.groupedByRegion[region] {
                            Section(header: Text(region)) {
                                ForEach(list) { city in
                                    cityRow(city)
                                }
                            }
                        }
                    }
                } else {
                    Section(header: Text("搜索结果 (\(filteredCities.count))")) {
                        if filteredCities.isEmpty {
                            Text("未找到相关城市，请尝试搜索拼音或省份。")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(filteredCities) { city in
                                cityRow(city)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "输入城市名或拼音 (如：哈尔滨 / hrb)")
            .navigationTitle("选择城市与地区")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("关闭") { dismiss() }
                }
            }
        }
    }

    private func cityRow(_ city: CityModel) -> some View {
        Button(action: {
            onSelectCity(city)
            dismiss()
        }) {
            HStack {
                Text(city.name)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                Text(city.province)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if city.name == currentSelectedCity.name {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
