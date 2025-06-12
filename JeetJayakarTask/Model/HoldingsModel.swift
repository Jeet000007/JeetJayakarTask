import Foundation

// MARK: - Holding
struct Holding: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let userHolding: [UserHolding]
}

// MARK: - UserHolding
struct UserHolding: Codable {
    let symbol: String
    let quantity: Int
    let ltp, avgPrice, close: Double
}
