import Foundation
import Combine

final class FetchCategoriesUseCase {
    
    private let newsRepository: NewsRepository
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }

    func perform() -> AnyPublisher<[NewsCategory], Error> {
        newsRepository.fetchCategories()
    }
}

