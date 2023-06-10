import Foundation
import Combine

final class FetchCountriesUseCase {
    
    private let newsRepository: NewsRepository
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }
    
    func perform() -> AnyPublisher<CountriesList, Error> {
        newsRepository.fetchCountries()
    }
}
