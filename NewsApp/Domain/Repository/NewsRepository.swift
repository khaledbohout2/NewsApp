import Combine

protocol NewsRepository {
    func fetchTopHeadlines(with country: Country, category: NewsCategory?) -> AnyPublisher<TopHeadlines, Error>
    func fetchCountries() -> AnyPublisher<CountriesList, Error>
    func fetchCategories() -> AnyPublisher<[NewsCategory], Error>
}
