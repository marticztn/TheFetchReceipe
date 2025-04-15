import Foundation

struct Recipe: Codable, Identifiable {
    var id: UUID
    var cuisine: String
    var name: String
    var photo_url_large: String?
    var photo_url_small: String?
    var source_url: String?
    var youtube_url: String?
    
    // For decoding references
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photo_url_large
        case photo_url_small
        case source_url
        case youtube_url
    }
}
