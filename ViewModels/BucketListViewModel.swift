import SwiftUI
import FirebaseAuth

class BucketListViewModel: ObservableObject {
    @Published var lists: [BucketList] = []
    @Published var items: [BucketItem] = []
    @Published var currentList: BucketList?
    @Published var newListTitle = ""
    @Published var newItemTitle = ""
    @Published var imageData: Data?

    var userID: String? {
        Auth.auth().currentUser?.uid
    }

    func fetchLists() {
        guard let uid = userID else { return }
        FirebaseService.shared.fetchLists(for: uid) { lists in
            DispatchQueue.main.async {
                self.lists = lists
                self.currentList = self.currentList ?? lists.first
                self.fetchItems()
            }
        }
    }

    func fetchItems() {
        guard let listID = currentList?.id else { return }
        FirebaseService.shared.fetchItems(for: listID) { items in
            DispatchQueue.main.async {
                self.items = items
            }
        }
    }

    func createNewList() {
        guard let uid = userID else { return }
        FirebaseService.shared.createList(title: newListTitle, userID: uid) {
            DispatchQueue.main.async {
                self.newListTitle = ""
                self.fetchLists()
            }
        }
    }

    func addItem() {
        guard let uid = userID,
              let listID = currentList?.id else { return }

        if let imageData = imageData {
            ImageUploader.shared.upload(imageData) { url in
                self.saveItem(uid: uid, listID: listID, imageURL: url)
            }
        } else {
            saveItem(uid: uid, listID: listID, imageURL: nil)
        }
    }

    private func saveItem(uid: String, listID: String, imageURL: String?) {
        let data: [String: Any] = [
            "title": newItemTitle,
            "imageURL": imageURL ?? "",
            "createdBy": uid,
            "listID": listID,
            "timestamp": Date()
        ]

        FirebaseService.shared.addItem(data: data) {
            DispatchQueue.main.async {
                self.newItemTitle = ""
                self.imageData = nil
            }
        }
    }
}

