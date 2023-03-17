import SwiftUI

@main
struct KatalogusApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext,
                              dataController.container.viewContext)
        }
    }
}

