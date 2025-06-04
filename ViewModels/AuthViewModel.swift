import FirebaseStorage

class ImageUploader {
    static let shared = ImageUploader()
    private let storage = Storage.storage()

    private init() {}

    func upload(_ data: Data, completion: @escaping (String?) -> Void) {
        let fileName = UUID().uuidString + ".jpg"
        let ref = storage.reference().child("bucket_images/\(fileName)")

        ref.putData(data, metadata: nil) { _, error in
            guard error == nil else {
                completion(nil)
                return
            }

            ref.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }
}

