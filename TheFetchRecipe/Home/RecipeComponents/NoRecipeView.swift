import SwiftUI

struct NoRecipeView: View {
    
    @Binding var isFailed: Bool
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "arrow.clockwise.circle.fill")
                .foregroundStyle(AppConfigs.defaultThemeColor)
                .font(.system(size: 50))
                .onTapGesture {
                    Task {
                        recipeViewModel.recipes = try await recipeViewModel.fetchRecipes()
                    }
                }
            
            Text(isFailed ? "Oops!\nThe data is corrupted\nPlease try again" : "No Recipe Found")
                .multilineTextAlignment(.center)
                .font(.system(size: 25))
                .fontWeight(.bold)
                .padding(.bottom, 8)
        }
        .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity.combined(with: .scale(scale: 0.9)).animation(.spring(bounce: 0.25)))
    }
}
