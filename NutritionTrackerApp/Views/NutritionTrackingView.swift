import SwiftUI

struct NutritionTrackingView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var navigateToThankYou = false  // ✅ State to navigate

    var totalPrice: Double {
        viewModel.logItems.reduce(0) { $0 + ($1.calories * 0.05) } // Example pricing logic
    }

    var body: some View {
        VStack {
            Text("Nutrition Summary")
                .font(.title)
                .padding()

            // Displays total intake vs goal
            VStack(alignment: .leading, spacing: 10) {
                Text("Calories: \(viewModel.totalCalories, specifier: "%.2f") / \(viewModel.userProfile.calorieGoal, specifier: "%.2f")")
                Text("Fat: \(viewModel.totalFat, specifier: "%.2f")g / \(viewModel.userProfile.fatGoal, specifier: "%.2f")g")
                Text("Protein: \(viewModel.totalProtein, specifier: "%.2f")g / \(viewModel.userProfile.proteinGoal, specifier: "%.2f")g")
                Text("Carbs: \(viewModel.totalCarbs, specifier: "%.2f")g / \(viewModel.userProfile.carbGoal, specifier: "%.2f")g")
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
            .padding(.horizontal)

            Divider()

            Text("Items in Your Cart")
                .font(.headline)
                .padding(.top)

            // List of food items logged
            List(viewModel.logItems) { item in
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text("Calories: \(item.calories, specifier: "%.2f")")
                    Text("Fat: \(item.fat, specifier: "%.2f")g")
                    Text("Protein: \(item.protein, specifier: "%.2f")g")
                    Text("Carbs: \(item.carbs, specifier: "%.2f")g")
                }
                .padding(.vertical, 5)
            }

            // Total Price Section
            VStack {
                Divider()
                Text("Total Price: $\(totalPrice, specifier: "%.2f")")
                    .font(.title2)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.2)))
            }
            .padding(.horizontal)

            // ✅ Checkout Button
            Button("Checkout") {
                navigateToThankYou = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top)

            // ✅ Navigation to Thank You Page
            NavigationLink(destination: ThankYouView(), isActive: $navigateToThankYou) { EmptyView() }

            Spacer()
        }
        .padding()
    }
}

// ✅ Thank You View
struct ThankYouView: View {
    var body: some View {
        VStack {
            Text("🎉 Thank You for Shopping!")
                .font(.largeTitle)
                .bold()
                .padding()
            Text("See you again! 😊")
                .font(.headline)
                .padding()
        }
    }
}

#Preview{
    NutritionTrackingView()
}

