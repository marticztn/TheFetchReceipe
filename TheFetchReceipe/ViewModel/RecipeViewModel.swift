import Foundation

enum RecipeServiceError: Error {
    case invalidURL
}


class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
            throw RecipeServiceError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let recipeResponse = try JSONDecoder().decode(RecipeArray.self, from: data)
        
        await MainActor.run {
            self.recipes = recipeResponse.recipes
        }
        
        return self.recipes
    }
}
