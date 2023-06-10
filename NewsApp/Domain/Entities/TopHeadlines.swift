import Foundation

// MARK: - TopHeadlines
struct TopHeadlines: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable, Hashable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
    let id = UUID()
    
    var publishedAtTimeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: publishedAt, relativeTo: Date())
    }

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}
