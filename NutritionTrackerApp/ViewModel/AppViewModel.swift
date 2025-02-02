import Foundation
import Combine

class AppViewModel: ObservableObject {
    @Published var userProfile = UserProfile()
    @Published var logItems: [LogItem] = []

    private var timer: Timer?
    private let baseURL = "https://your-api.com" // Replace with actual API

    init() {
        fetchUserID()
        startFetchingLog()
    }

    func fetchUserID() {
        guard let url = URL(string: "\(baseURL)/get-id") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let id = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.userProfile.id = id
                }
            }
        }.resume()
    }

    func startFetchingLog() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.fetchLog()
        }
    }

    func fetchLog() {
        guard let url = URL(string: "\(baseURL)/get-log") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let newItem = try JSONDecoder().decode(LogItem.self, from: data)
                    DispatchQueue.main.async {
                        self.logItems.append(newItem)
                    }
                } catch {
                    print("Error decoding log item:", error)
                }
            }
        }.resume()
    }

    var totalCalories: Double { logItems.reduce(0) { $0 + $1.calories } }
    var totalFat: Double { logItems.reduce(0) { $0 + $1.fat } }
    var totalProtein: Double { logItems.reduce(0) { $0 + $1.protein } }
    var totalCarbs: Double { logItems.reduce(0) { $0 + $1.carbs } }
}

