import FirebaseFirestore
import FirebaseAuth

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()

    private init() {}

    func fetchLists(for uid: String, completion: @escaping ([BucketList]) -> Void) {
        db.collection("bucketLists")
            .whereField("memberIDs", arrayContains: uid)
            .addSnapshotListener { snapshot, _ in
                let lists = snapshot?.documents.compactMap { doc -> BucketList? in
                    let data = doc.data()
                    return BucketList(
                        id: doc.documentID,
                        title: data["title"] as? String ?? "",
                        memberIDs: data["memberIDs"] as? [String] ?? []
                    )
                } ?? []
                completion(lists)
            }
    }

    func fetchItems(for listID: String, completion: @escaping ([BucketItem]) -> Void) {
        db.collection("bucketItems")
            .whereField("listID", isEqualTo: listID)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, _ in
                let items = snapshot?.documents.compactMap { doc -> BucketItem? in
                    let data = doc.data()
                    return BucketItem(
                        id: doc.documentID,
                        title: data["title"] as? String ?? "",
                        imageURL: data["imageURL"] as? String,
                        createdBy: data["createdBy"] as? String ?? "",
                        listID: data["listID"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    )
                } ?? []
                completion(items)
            }
    }

    func createList(title: String, userID: String, completion: (() -> Void)? = nil) {
        db.collection("bucketLists").addDocument(data: [
            "title": title,
            "memberIDs": [userID]
        ]) { _ in completion?() }
    }

    func addItem(data: [String: Any], completion: (() -> Void)? = nil) {
        db.collection("bucketItems").addDocument(data: data) { _ in completion?() }
    }
}

