import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        ZStack {
            if recipeViewModel.recipes.isEmpty {
                NoRecipeView()
            } else {
                RecipeList()
            }
        }
        .padding()
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
