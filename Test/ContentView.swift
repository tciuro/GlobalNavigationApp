// GlobalNavigationApp
// Copyright (c) 2023 Webbo, Inc.

import SwiftUI

enum Route: Hashable {
    case login
    case list
    case detail(Movie)
    case reviews([Review])
}

final class MoviesModel: ObservableObject {
    @Published var path: [Route] = []

    func popToRoot() {
        path = []
    }
}

struct Movie: Hashable {
    let name: String
}

struct Review: Hashable {
    let text: String
}

struct LoginScreen: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        Button("Login") {
            appModel.shouldAuthenticate = false
        }
    }
}

struct MovieListScreen: View {
    @EnvironmentObject private var appModel: AppModel
    @StateObject private var moviesModel = MoviesModel()

    private let movies = [Movie(name: "Spiderman"), Movie(name: "Batman")]

    var body: some View {
        TabView {
            NavigationStack(path: $moviesModel.path) {
                List(movies, id: \.name) { movie in
                    NavigationLink(movie.name, value: Route.detail(movie))
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Logout") {
                            appModel.logout()
                        }
                    }
                }
                .navigationDestination(for: Route.self) { route in
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
            .tabItem {
                Label("Menu", systemImage: "list.dash")
            }
            .environmentObject(moviesModel)

            NavigationStack {
                Text("Hello World!")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Logout") {
                                appModel.logout()
                            }
                        }
                    }
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

struct MovieDetailScreen: View {
    let movie: Movie

    var body: some View {
        VStack {
            Text(movie.name)
                .font(.largeTitle)
            NavigationLink("Reviews", value: Route.reviews([Review(text: "Good movie!")]))
        }
    }
}

struct ReviewListScreen: View {
    @EnvironmentObject private var appModel: AppModel
    @EnvironmentObject private var moviesModel: MoviesModel

    let reviews: [Review]

    var body: some View {
        List(reviews, id: \.text) { review in
            Text(review.text)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Pop to Root") {
                    moviesModel.popToRoot()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout") {
                    appModel.logout()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MovieListScreen()
                .navigationDestination(for: Route.self) { route in
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
    }
}
