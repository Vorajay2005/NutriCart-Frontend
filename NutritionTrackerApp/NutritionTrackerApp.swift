import SwiftUI

@main
struct NutritionTrackerApp: App {
    @StateObject var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}

