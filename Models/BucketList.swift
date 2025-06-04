import Foundation

struct BucketList: Identifiable, Codable, Hashable {
    var id: String?
    var title: String
    var memberIDs: [String]
}

