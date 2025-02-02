import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            // Add the app logo
            Image("social") // Use the name you set in the Assets
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150) // Adjust the size as needed
                .padding(.bottom, 20)

            // Welcome Text
            Text("Welcome to Nutrition Tracker")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()

            // Get Started Button
            NavigationLink(destination: CartIDView()) {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

