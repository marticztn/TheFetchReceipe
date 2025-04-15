import SwiftUI

@main
struct TheFetchReceipeApp: App {
    
    @StateObject private var recipeViewModel = RecipeViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(recipeViewModel)
        }
    }
}
