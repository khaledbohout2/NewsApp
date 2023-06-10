import Foundation
import Combine

final class NewsDataRepository: NewsRepository {
    
    private let countriesLoadingService: CountriesLoaderInterface
    private let newsService: NewsAPIServiceInterface
    
    
    init(countriesLoadingService: CountriesLoaderInterface,
         newsService: NewsAPIServiceInterface) {
        self.countriesLoadingService = countriesLoadingService
        self.newsService = newsService
    }
    
    func fetchTopHeadlines(with country: Country, category: NewsCategory?) -> AnyPublisher<TopHeadlines, Error> {
        newsService.fetchTopHeadlines(with: country, category: category)
    }
    
    func fetchCountries() -> AnyPublisher<CountriesList, Error> {
        countriesLoadingService.loadCountries()
    }
    
    func fetchCategories() -> AnyPublisher<[NewsCategory], Error> {
        Just(NewsCategory.allCases).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
