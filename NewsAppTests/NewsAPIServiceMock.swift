import Combine
import Foundation
@testable import NewsApp

final class NewsAPIServiceMock: NewsAPIServiceInterface {
    var articles: [Article]?
    var topHeadlines: TopHeadlines?

    func fetchTopHeadlines(with country: Country, category: NewsCategory?) -> AnyPublisher<TopHeadlines, Error> {
        guard let topHeadlines = topHeadlines, let _ = topHeadlines.articles else {
            return Fail(error: FechNewsError.faildFindNews)
                .eraseToAnyPublisher()
        }
        return Just(topHeadlines)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
    }

}
