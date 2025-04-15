import SwiftUI

struct RecipeTypeRowView: View {
    
    var type: String
    var recipes: [Recipe]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConfigs.defaultPadding / 2) {
            Text(type)
                .foregroundStyle(.black.opacity(0.7))
                .font(.system(size: AppConfigs.cardRecipeTypeFontSize, weight: .bold))
                .padding(.leading, AppConfigs.defaultPadding)
                .shadow(color: .black.opacity(0.3), radius: 3, y: 3)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppConfigs.defaultPadding) {
                    ForEach(recipes, id: \.id) { recipe in
                        RecipeCard(recipe: recipe)
                    }
                }
                .padding(.horizontal, AppConfigs.defaultPadding)
            }
        }
    }
}
