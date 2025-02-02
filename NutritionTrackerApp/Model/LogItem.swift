import Foundation

struct LogItem: Identifiable, Codable {
    var id: Int  // Product ID
    var name: String
    var calories: Double
    var fat: Double
    var protein: Double
    var carbs: Double
    var price: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name = "product_name"  // ✅ Maps JSON "product_name" to "name"
        case calories, fat, protein, carbs, price
    }
}

