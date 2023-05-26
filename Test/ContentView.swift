// GlobalNavigationApp
// Copyright (c) 2023 Webbo, Inc.

import SwiftUI

struct Movie: Hashable {
    let name: String
}

struct Review: Hashable {
    let text: String
}

struct LoginScreen: View {
    var body: some View {
        NavigationLink("Login", value: Route.list)
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
    
    let reviews: [Review]

    var body: some View {
        List(reviews, id: \.text) { review in
            Text(review.text)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout") {
                    appModel.logout()
                }
            }
        }
    }
}

struct MovieListScreen: View {
    let movies = [Movie(name: "Spiderman"), Movie(name: "Batman")]

    var body: some View {
        List(movies, id: \.name) { movie in
            NavigationLink(movie.name, value: Route.detail(movie))
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
