import SwiftUI

struct RecipeCard: View {
    
    var recipe: Recipe
    
    let cardRecipeWidth: CGFloat = 130.0
    let cardrecipeHeight: CGFloat = 160.0
    let cardRecipeNameFontSize: CGFloat = 13.0
    
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: recipe.photo_url_small ?? "")!) { phase in
                if let image = phase.image {
                    image
                        .tint(recipeViewModel.tapID == recipe.id ? .black.opacity(0.7) : .clear)
                        .overlay {
                            overlayButtons
                        }
                    
                    // TODO: Cache the downloaded image here...
                    
                } else if phase.error != nil {
                    Image(systemName: "triangle.fill")
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .frame(width: cardRecipeWidth, height: cardRecipeWidth)
            .mask(RoundedRectangle(cornerRadius: 15.0))
            .shadow(color: .black.opacity(0.3), radius: 5, y: 3)
            
            Text(recipe.name)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .font(.system(size: cardRecipeNameFontSize, weight: .semibold))
        }
        .contentShape(Rectangle())
        .frame(width: cardRecipeWidth, height: cardrecipeHeight, alignment: .topLeading)
        .onTapGesture {
            showRecipeDetails()
        }
    }
    
    var overlayButtons: some View {
        HStack {
            if recipe.photo_url_large != nil {
                Image(systemName: "photo")
            }
            
            if recipe.source_url != nil {
                Image(systemName: "network")
            }
            
            if recipe.youtube_url != nil {
                Image(systemName: "play.rectangle.fill")
            }
        }
        .font(.system(size: 20, weight: .bold))
        .foregroundStyle(.regularMaterial)
    }
    
    private func showRecipeDetails() {
        recipeViewModel.tapID = (recipe.id == recipeViewModel.tapID) ? UUID() : recipe.id
    }
}
