import XCTest
@testable import TheFetchRecipe

final class TheFetchRecipeTests: XCTestCase {

    // Check JSON parsing & grouping
    func testRecipeParsingAndGrouping() throws {
        let jsonString = """
        {
          "recipes": [
            {
              "uuid": "11111111-1111-1111-1111-111111111111",
              "cuisine": "Italian",
              "name": "Test Pasta",
              "photo_url_large": "http://example.com/large.jpg",
              "photo_url_small": "http://example.com/small.jpg",
              "source_url": "http://example.com/source",
              "youtube_url": "http://youtube.com/watch?v=abc123"
            },
            {
              "uuid": "22222222-2222-2222-2222-222222222222",
              "cuisine": "Chinese",
              "name": "Test Noodles",
              "photo_url_large": "http://example.com/large2.jpg",
              "photo_url_small": "http://example.com/small2.jpg",
              "source_url": "http://example.com/source2",
              "youtube_url": null
            }
          ]
        }
        """
        let data = jsonString.data(using: .utf8)!
        
        let recipeArray = try JSONDecoder().decode(RecipeArray.self, from: data)
        XCTAssertEqual(recipeArray.recipes.count, 2, "should decode 2 recipes")
        
        var groupedRecipes = [String: [Recipe]]()
        for recipe in recipeArray.recipes {
            groupedRecipes[recipe.cuisine, default: []].append(recipe)
        }
        
        XCTAssertEqual(groupedRecipes["Italian"]?.count, 1, "Italian cuisine should have 1 recipe")
        XCTAssertEqual(groupedRecipes["Chinese"]?.count, 1, "Chinese suite should have 1 recipe")
    }
    
    // Check if invalid json throws an error
    func testInvalidJSONThrowsError() throws {
        let invalidJSONString = "this is not a valid JSON"
        let data = invalidJSONString.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(RecipeArray.self, from: data), "Invalid JSON should throw an error")
    }
    
    // Check optional JSON fields
    func testRecipeParsingWithMissingOptionalFields() throws {
        let jsonString = """
        {
          "recipes": [
            {
              "uuid": "33333333-3333-3333-3333-333333333333",
              "cuisine": "Mexican",
              "name": "Tacos"
            }
          ]
        }
        """
        let data = jsonString.data(using: .utf8)!
        let recipeArray = try JSONDecoder().decode(RecipeArray.self, from: data)
        
        XCTAssertEqual(recipeArray.recipes.count, 1, "Should parse exactly one recipe")
        let recipe = recipeArray.recipes.first!
        XCTAssertEqual(recipe.cuisine, "Mexican")
        XCTAssertEqual(recipe.name, "Tacos")
        XCTAssertNil(recipe.photo_url_large, "photo_url_large should be nil")
        XCTAssertNil(recipe.photo_url_small, "photo_url_small should be nil")
        XCTAssertNil(recipe.source_url, "source_url should be nil")
        XCTAssertNil(recipe.youtube_url, "youtube_url should be nil")
    }
    
    // Check difference recipes for the same cuisine/type
    func testMultipleRecipesSameCuisineGrouping() throws {
        let jsonString = """
        {
          "recipes": [
            {
              "uuid": "11111111-1111-1111-1111-111111111111",
              "cuisine": "Indian",
              "name": "Curry",
              "photo_url_large": null,
              "photo_url_small": null,
              "source_url": null,
              "youtube_url": null
            },
            {
              "uuid": "22222222-2222-2222-2222-222222222222",
              "cuisine": "Indian",
              "name": "Biryani",
              "photo_url_large": null,
              "photo_url_small": null,
              "source_url": null,
              "youtube_url": null
            },
            {
              "uuid": "33333333-3333-3333-3333-333333333333",
              "cuisine": "Italian",
              "name": "Pasta",
              "photo_url_large": null,
              "photo_url_small": null,
              "source_url": null,
              "youtube_url": null
            }
          ]
        }
        """
        let data = jsonString.data(using: .utf8)!
        let recipeArray = try JSONDecoder().decode(RecipeArray.self, from: data)
        
        var groupedRecipes = [String: [Recipe]]()
        for recipe in recipeArray.recipes {
            groupedRecipes[recipe.cuisine, default: []].append(recipe)
        }
        
        XCTAssertEqual(groupedRecipes["Indian"]?.count, 2, "Indian cuisine should have 2 recipes")
        XCTAssertEqual(groupedRecipes["Italian"]?.count, 1, "Italian cuisine should have 1 recipe")
    }
}
