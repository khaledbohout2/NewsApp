import Foundation
import Combine

final class OnboardingViewModel {
    private let fetchCountriesUseCase: FetchCountriesUseCase
    private let fetchCategoriesUseCase: FetchCategoriesUseCase

    @Published private(set) var filters: (CountriesList, [NewsCategory]) = ([], [])
    @Published private(set) var state: ViewState = .loading
    private var subscriptions = Set<AnyCancellable>()
    
    var selectedFilters: (Country, NewsCategory)?
    
    var defaultFilters: (Country, NewsCategory) {
        return (filters.0.first(where: { $0.iso2?.lowercased() == "us" })!, NewsCategory.allNews)
    }
    
    init(fetchCountriesUseCase: FetchCountriesUseCase,
         fetchCategoriesUseCase: FetchCategoriesUseCase) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }
    
    func viewDidLoad() {
        fetchFilters()
    }
    
    private func fetchFilters() {
        fetchCountriesUseCase.perform()
            .combineLatest(fetchCategoriesUseCase.perform())
            .sink { completion in
                if case .failure(let error) = completion {
                    print("error: \(error)")
                    self.state = .error(message: ViewModelError.faildFiltersLoading.message)
                }
            } receiveValue: { countries, categories in
                self.filters = (countries, categories)
                self.selectedFilters = self.defaultFilters
            }.store(in: &subscriptions)

    }

    func didUpdateFilters(selectedFilters: (Country, NewsCategory)) {
        UserDataService.sharedInstance.selectedFilters = selectedFilters
        UserDefaultsService.sharedInstance.firstLaunch = true
    }

    enum ViewModelError: Error {
        case faildFiltersLoading
        case faildTopHeadlinesLoading

        var message: String {
            switch self {
            case .faildFiltersLoading:
                return "Failed to load Filters"
            case .faildTopHeadlinesLoading:
                return "Failed to load top headlines from API"
            }
        }
    }

}
