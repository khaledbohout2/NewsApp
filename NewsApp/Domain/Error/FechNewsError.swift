enum FechNewsError: Error {
    case faildFindNews
    case failedOnMergingNews
    case failedFetchNews

    var message: String {
        switch self {
        case .faildFindNews:
            return "Failed find News"
        case .failedOnMergingNews:
            return "Failed merging the news into a list"
        case .failedFetchNews:
            return "Failed fetching news for this country"
        }
    }
}
