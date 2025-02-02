import SwiftUI

struct NutritionInputView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var calories = ""
    @State private var fat = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var navigateToTracking = false

    var body: some View {
        VStack {
            Text("Set Your Daily Nutrition Goals")
                .font(.title)
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text("Calories")
                    .font(.headline)
                TextField("Enter Calories", text: $calories)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)

                Text("Fat (g)")
                    .font(.headline)
                TextField("Enter Fat (g)", text: $fat)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)

                Text("Protein (g)")
                    .font(.headline)
                TextField("Enter Protein (g)", text: $protein)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)

                Text("Carbs (g)")
                    .font(.headline)
                TextField("Enter Carbs (g)", text: $carbs)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
            }
            .padding(.horizontal)

            // Navigation to Tracking
            NavigationLink(destination: NutritionTrackingView(), isActive: $navigateToTracking) { EmptyView() }

            Button("Continue") {
                if let cal = Double(calories), let fatValue = Double(fat),
                   let proteinValue = Double(protein), let carbsValue = Double(carbs) {

                    viewModel.userProfile.calorieGoal = cal
                    viewModel.userProfile.fatGoal = fatValue
                    viewModel.userProfile.proteinGoal = proteinValue
                    viewModel.userProfile.carbGoal = carbsValue

                    navigateToTracking = true
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .onAppear {
            autoFillNutrients()
        }
    }

    func autoFillNutrients() {
        calories = String(format: "%.0f", viewModel.userProfile.calorieGoal)
        fat = String(format: "%.1f", viewModel.userProfile.fatGoal)
        protein = String(format: "%.1f", viewModel.userProfile.proteinGoal)
        carbs = String(format: "%.1f", viewModel.userProfile.carbGoal)
    }
}

