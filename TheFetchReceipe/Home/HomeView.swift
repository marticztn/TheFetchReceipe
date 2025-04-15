import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HomeHeader()
            
            Spacer()
            
            if recipeViewModel.recipes.isEmpty || recipeViewModel.fetchFailed {
                NoRecipeView(isFailed: $recipeViewModel.fetchFailed)
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
            recipeViewModel.fetchFailed = true
        }
    }
    
}

#Preview {
    HomeView()
}
