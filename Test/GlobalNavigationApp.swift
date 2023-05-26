// GlobalNavigationApp
// Copyright (c) 2023 Webbo, Inc.

import SwiftUI

final class AppModel: ObservableObject {
    @Published var shouldAuthenticate = true

    func logout() {
        withAnimation {
            self.shouldAuthenticate = true
        }
    }
}

@main
struct GlobalNavigationApp: App {
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if appModel.shouldAuthenticate {
                    LoginScreen()
                } else {
                    MovieListScreen()
                }
            }
            .environmentObject(appModel)
        }
    }
}
