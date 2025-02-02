import SwiftUI

struct CartIDView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var cartID = ""
    @State private var navigateToProfile = false
    @State private var timer: Timer?  // ✅ Timer for auto-refresh

    var body: some View {
        VStack {
            // ✅ Add an Image on Top
            Image("cart") // Replace "shopping_cart" with the actual image asset name
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150) // Adjust size as needed
                .padding(.bottom, 20)

            Text("Enter Your Shopping Cart ID")
                .font(.title)
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text("Cart ID")
                    .font(.headline)
                TextField("Enter Cart ID", text: $cartID)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }
            .padding(.horizontal)

            NavigationLink(destination: ProfileView(), isActive: $navigateToProfile) { EmptyView() }

            Button("Continue") {
                if !cartID.isEmpty {
                    viewModel.userProfile.cartID = cartID  // ✅ Store Cart ID
                    fetchShoppingLog(cartID: cartID)       // ✅ Initial API Call
                    startAutoRefresh(cartID: cartID)       // ✅ Start Auto-Refresh
                    navigateToProfile = true
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }

    // ✅ Auto-Refresh API Call Every 5 Seconds
    func startAutoRefresh(cartID: String) {
        timer?.invalidate() // Stop any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            fetchShoppingLog(cartID: cartID)
        }
    }

    // ✅ API Call Function with Error Handling and Debugging
    func fetchShoppingLog(cartID: String, retryCount: Int = 3) {
        guard let url = URL(string: "https://hackru-spring-2025-backend.onrender.com/get-shopping-log/\(cartID)") else {
            print("❌ Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network Error:", error.localizedDescription)
                if retryCount > 0 {
                    print("🔄 Retrying... Attempts left: \(retryCount - 1)")
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                        fetchShoppingLog(cartID: cartID, retryCount: retryCount - 1)
                    }
                }
                return
            }

            // ✅ Check if response is valid
            if let httpResponse = response as? HTTPURLResponse {
                print("✅ Server Response Code:", httpResponse.statusCode)
                if httpResponse.statusCode != 200 {
                    print("❌ Server returned error \(httpResponse.statusCode)")
                    return
                }
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            // ✅ Print API response for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("📝 Raw API Response:\n\(rawString)")

                if rawString.contains("<html") {
                    print("⚠️ API returned an HTML page instead of JSON!")
                    return
                }
            }

            do {
                // ✅ FIXED: Decode an ARRAY of LogItem objects
                let newLogItems = try JSONDecoder().decode([LogItem].self, from: data)

                DispatchQueue.main.async {
                    // ✅ Instead of checking unique IDs, just append all entries
                    viewModel.logItems.append(contentsOf: newLogItems)
                    print("🛒 Updated Log Items:", viewModel.logItems)
                }
            } catch {
                print("❌ JSON Decoding Error:", error.localizedDescription)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📝 Raw JSON (for Debugging):\n\(jsonString)")
                }
            }
        }.resume()
    }
}

#Preview {
    CartIDView()
}

