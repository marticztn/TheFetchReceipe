import SwiftUI

@main
struct TheFetchRecipeApp: App {
    
    @StateObject private var recipeViewModel = RecipeViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(recipeViewModel)
        }
    }
}
