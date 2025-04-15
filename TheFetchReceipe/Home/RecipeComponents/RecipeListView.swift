import SwiftUI

struct RecipeList: View {
    
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(recipeViewModel.recipes, id: \.id) { recipe in
                    RecipeCard(recipe: recipe)
                }
            }
        }
    }
}
