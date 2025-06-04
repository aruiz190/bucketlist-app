import SwiftUI
import FirebaseCore

@main
struct BucketListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authVM = AuthViewModel()
    @StateObject var bucketVM = BucketListViewModel()

    var body: some Scene {
        WindowGroup {
            BucketListView()
                .environmentObject(authVM)
                .environmentObject(bucketVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
