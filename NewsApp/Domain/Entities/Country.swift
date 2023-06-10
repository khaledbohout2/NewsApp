import Foundation

// MARK: - Country
struct Country: Codable, Hashable {
    fileprivate let id = UUID()
    let name, iso2: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

typealias CountriesList = [Country]
