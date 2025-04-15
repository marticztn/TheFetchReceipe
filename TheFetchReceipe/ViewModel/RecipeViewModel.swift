import Foundation

enum RecipeServiceError: Error {
    case invalidURL, malformedData
}

class RecipeViewModel: ObservableObject {
    @Published var tapID: UUID?
    @Published var recipes: [String: [Recipe]] = [:]
    
    func fetchRecipes() async throws -> [String: [Recipe]] {
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json") else {
            throw RecipeServiceError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let recipeResponse = try JSONDecoder().decode(RecipeArray.self, from: data)
        
        // Categorization (by type/cuisine)
        var recipeDict: [String: [Recipe]] = [:]
        for recipe in recipeResponse.recipes {
            recipeDict[recipe.cuisine, default: []].append(recipe)
        }
        
        return recipeDict
    }
}
