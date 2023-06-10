import Foundation
import Combine

final class FetchTopHeadlinesUseCase {

    private let newsRepository: NewsRepository

    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }

    func perform(with country: Country, category: NewsCategory?) -> AnyPublisher<TopHeadlines, Error> {
        newsRepository.fetchTopHeadlines(with: country, category: category)
    }

}
