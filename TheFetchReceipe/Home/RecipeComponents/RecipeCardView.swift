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
                        .overlay {
                            Rectangle()
                                .fill(isClickedSelf() ? .black.opacity(0.7) : .clear)
                            
                            if isClickedSelf() {
                                overlayButtons
                            }
                        }
                    
                    // TODO: Cache the downloaded image here...
                    
                } else if phase.error != nil {
                    Image(systemName: "triangle.fill")
                } else {
                    ProgressView()
                        .scaleEffect(1.3)
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
            showRecipeOptions()
        }
    }
    
    // MARK: - View components
    
    var overlayButtons: some View {
        HStack {
            if recipe.photo_url_large != nil {
                Image(systemName: "photo")
                    .onTapGesture {
                        enlargeCard()
                    }
            }
            
            if recipe.source_url != nil {
                Image(systemName: "network")
                    .onTapGesture {
                        openInSafari(url: recipe.source_url)
                    }
            }
            
            if recipe.youtube_url != nil {
                Image(systemName: "play.rectangle.fill")
                    .onTapGesture {
                        openInSafari(url: recipe.youtube_url)
                    }
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8)).animation(.spring(bounce: 0.25)))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(.system(size: 20, weight: .bold))
        .foregroundStyle(.regularMaterial)
    }
    
    // MARK: - Private functions
    
    private func showRecipeOptions() {
        withAnimation(.spring(duration: 0.5, bounce: 0.25)) {
            recipeViewModel.tapID = isClickedSelf() ? nil : recipe.id
        }
    }
    
    private func isClickedSelf() -> Bool {
        recipeViewModel.tapID == recipe.id
    }
    
    private func enlargeCard() {
        
    }
    
    private func openInSafari(url: String?) {
        guard let sourceUrlString = url,
              let url = URL(string: sourceUrlString),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
