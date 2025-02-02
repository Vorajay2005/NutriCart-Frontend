import Foundation

struct UserProfile {
    var id: String = ""
    var cartID: String = ""  // ✅ Stores Cart ID
    var height: Double?
    var age: Int?
    var weight: Double?
    var calorieGoal: Double = 0
    var fatGoal: Double = 0
    var proteinGoal: Double = 0
    var carbGoal: Double = 0
}

