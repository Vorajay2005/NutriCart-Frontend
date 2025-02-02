import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        NavigationView {
            WelcomeView()
        }
        .environmentObject(viewModel) // Ensure ViewModel is available to all views
    }
}

#Preview {
    ContentView().environmentObject(AppViewModel()) // ✅ Enables previewing without errors
}

