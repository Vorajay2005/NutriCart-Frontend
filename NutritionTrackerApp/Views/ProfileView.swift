import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var height = ""
    @State private var age = ""
    @State private var weight = ""
    @State private var navigateToNutritionInput = false

    var body: some View {
        VStack {
            Text("Enter Your Details")
                .font(.title)
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text("Height (cm)")
                    .font(.headline)
                TextField("Enter your height", text: $height)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)

                Text("Age")
                    .font(.headline)
                TextField("Enter your age", text: $age)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)

                Text("Weight (kg)")
                    .font(.headline)
                TextField("Enter your weight", text: $weight)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
            }
            .padding(.horizontal)

            NavigationLink(destination: NutritionInputView(), isActive: $navigateToNutritionInput) { EmptyView() }

            Button("Next") {
                if let heightValue = Double(height),
                   let ageValue = Int(age),
                   let weightValue = Double(weight) {
                    // Store user details
                    viewModel.userProfile.height = heightValue
                    viewModel.userProfile.age = ageValue
                    viewModel.userProfile.weight = weightValue

                    // Calculate suggested nutrient goals
                    calculateRecommendedNutrients(weight: weightValue, height: heightValue, age: ageValue)

                    // Navigate to the next view
                    navigateToNutritionInput = true
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }

    func calculateRecommendedNutrients(weight: Double, height: Double, age: Int) {
        // Simple BMR-based estimation for daily caloric intake
        let bmr = 10 * weight + 6.25 * height - 5 * Double(age) + 5 // Mifflin-St Jeor Equation for men

        viewModel.userProfile.calorieGoal = bmr * 1.2  // Assuming sedentary lifestyle
        viewModel.userProfile.proteinGoal = weight * 1.6 // 1.6g protein per kg of body weight
        viewModel.userProfile.fatGoal = (viewModel.userProfile.calorieGoal * 0.25) / 9 // 25% of calories from fat
        viewModel.userProfile.carbGoal = (viewModel.userProfile.calorieGoal * 0.50) / 4 // 50% of calories from carbs
    }
}

