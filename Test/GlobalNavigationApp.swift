// GlobalNavigationApp
// Copyright (c) 2023 Webbo, Inc.

import SwiftUI

enum Route: Hashable {
    case login
    case list
    case detail(Movie)
    case reviews([Review])
}

@main
struct GlobalNavigationApp: App {
    @State private var path: [Route] = []

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
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
                            ReviewListScreen(path: $path, reviews: reviews)
                    }
                }
            }
        }
    }
}
