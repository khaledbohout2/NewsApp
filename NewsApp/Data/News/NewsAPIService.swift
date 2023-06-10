import Combine
import Foundation

protocol NewsAPIServiceInterface {
    func fetchTopHeadlines(with country: Country, category: NewsCategory?) -> AnyPublisher<TopHeadlines, Error>
}

struct NewsAPIService: APIClient, NewsAPIServiceInterface {
    func fetchTopHeadlines(with country: Country, category: NewsCategory?) -> AnyPublisher<TopHeadlines, Error> {
        fetch(endpoint: NewsEndpoint.fetchNews(countryISO: country.iso2, category: category))
    }

}
