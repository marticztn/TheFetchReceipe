import SwiftUI

struct RecipeView: View {
    
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 45) {
                ForEach(Array(recipeViewModel.recipes).sorted { $0.key < $1.key }, id: \.key) { recipes in
                    RecipeTypeRowView(type: recipes.key, recipes: recipes.value)
                }
            }
            .padding(.top, 20)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)).animation(.spring(bounce: 0.25)))
        .refreshable {
            Task {
                recipeViewModel.recipes = try await recipeViewModel.fetchRecipes()
            }
        }
    }
}
