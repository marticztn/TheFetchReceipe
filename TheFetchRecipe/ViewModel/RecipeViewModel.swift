import Foundation

enum RecipeServiceError: Error {
    case invalidURL
}

class RecipeViewModel: ObservableObject {
    let goodURLStr = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    let malformedURLStr = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    let emptyURLStr = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    
    @Published var fetchFailed: Bool = false
    @Published var tapID: UUID?
    @Published var recipes: [String: [Recipe]] = [:]
    
    func fetchRecipes() async throws -> [String: [Recipe]] {
        guard let url = URL(string: goodURLStr) else {
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
