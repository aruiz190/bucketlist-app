import Foundation

struct BucketItem: Identifiable, Codable {
    var id: String?
    var title: String
    var imageURL: String?
    var createdBy: String
    var listID: String
    var timestamp: Date
}

