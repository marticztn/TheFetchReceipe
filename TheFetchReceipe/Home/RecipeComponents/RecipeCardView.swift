import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: recipe.photo_url_small ?? "")!) { phase in
                if let image = phase.image {
                    image
                    // TODO: Cache the downloaded image here...
                    
                } else if phase.error != nil {
                    Image(systemName: "triangle.fill")
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            
            Text(recipe.name)
                .fontWeight(.bold)
            Text(recipe.cuisine)
                .fontWeight(.semibold)
        }
        .onTapGesture {
            showRecipeDetails()
        }
        .background {
            RoundedRectangle(cornerRadius: AppConfigs.cardRecipeCornerRadius)
        }
    }
    
    private func showRecipeDetails() {
        
    }
}
