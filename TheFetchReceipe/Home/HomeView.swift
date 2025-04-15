import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HomeHeader()
            
            if recipeViewModel.recipes.isEmpty {
                NoRecipeView()
            } else {
                RecipeView()
            }
        }
        .task {
            await loadRecipes()
        }
    }
    
    private func loadRecipes() async {
        do {
            recipeViewModel.recipes = try await recipeViewModel.fetchRecipes()
        } catch {
            print("[ERROR] HomeView - Failed to fetch recipes: \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    HomeView()
}
