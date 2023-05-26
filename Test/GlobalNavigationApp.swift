// GlobalNavigationApp
// Copyright (c) 2023 Webbo, Inc.

import SwiftUI

enum Route: Hashable {
    case login
    case list
    case detail(Movie)
    case reviews([Review])
}

final class AppModel: ObservableObject {
    @Published var path: [Route] = []
    
    func logout() {
        withAnimation {
            path = []
        }
    }
}

@main
struct GlobalNavigationApp: App {
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appModel.path) {
                VStack {
                    LoginScreen()
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                        case .login:
                            LoginScreen()
                        case .list:
                            MovieListScreen()
                        case let .detail(movie):
                            MovieDetailScreen(movie: movie)
                        case let .reviews(reviews):
                            ReviewListScreen(reviews: reviews)
                    }
                }
            }
            .environmentObject(appModel)
        }
    }
}
