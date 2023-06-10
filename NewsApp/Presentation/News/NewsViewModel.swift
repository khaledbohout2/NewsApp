import Combine

final class NewsViewModel {
    private let fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCase

    @Published private(set) var articles: [Article] = []
    @Published private(set) var state: ViewState = .loading
    private var subscriptions = Set<AnyCancellable>()

    var newsListTitle: String {
        UserDataService.sharedInstance.selectedFilters?.1 == .allNews ? "All News" : UserDataService.sharedInstance.selectedFilters?.1.rawValue ?? "All News"
    }
    init(fetchTopHeadlinesUseCase: FetchTopHeadlinesUseCase) {
        self.fetchTopHeadlinesUseCase = fetchTopHeadlinesUseCase
    }
    
    func viewDidLoad() {
        fetchTopHeadlines()
    }
    
    func fetchTopHeadlines() {
        articles.removeAll()
        fetchTopHeadlinesUseCase.perform(with: UserDataService.sharedInstance.selectedFilters?.0 ?? Country(name: "Canada", iso2: "ca"), category: UserDataService.sharedInstance.selectedFilters?.1)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("error: \(error)")
                    self.state = .error(message: ViewModelError.faildTopHeadlinesLoading.message)
                }
            } receiveValue: {[unowned self] topHeadlines in
                guard let receivedArticles = topHeadlines.articles else { return }
                self.articles = receivedArticles
                self.state = .success
            }.store(in: &subscriptions)

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
