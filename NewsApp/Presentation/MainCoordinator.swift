import UIKit

final class MainCoordinator: Coordinator {
    
    var children = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let firstLaunch = UserDefaultsService.sharedInstance.firstLaunch, firstLaunch else {
            onboard()
            return
        }
        newsLis()
    }
    
    func onboard() {
        let countriesLoadingService = CountriesLoader(fileName: "countries", fileType: "json")
        let newsRepository = NewsDataRepository(countriesLoadingService: countriesLoadingService,
                                                newsService: NewsAPIService())
        let fetchCountriesUseCase = FetchCountriesUseCase(newsRepository: newsRepository)
        let fetchCategoriesUseCase = FetchCategoriesUseCase(newsRepository: newsRepository)
        let viewModel = OnboardingViewModel(fetchCountriesUseCase: fetchCountriesUseCase, fetchCategoriesUseCase: fetchCategoriesUseCase)
        let onboardingVC = OnboardingVC(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(onboardingVC, animated: false)
    }
    
    func newsLis() {
        let countriesLoadingService = CountriesLoader(fileName: "countries", fileType: "json")
        
        let newsRepository = NewsDataRepository(countriesLoadingService: countriesLoadingService,
                                                newsService: NewsAPIService())
        let fetchTopHeadlinesUseCase = FetchTopHeadlinesUseCase(newsRepository: newsRepository)
        let viewModel = NewsViewModel(fetchTopHeadlinesUseCase: fetchTopHeadlinesUseCase)
        let newsVC = NewsViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(newsVC, animated: false)
    }
    
    func newsDetails(with article: Article) {
        let viewModel =  NewsDetailsViewModel(with: article)
        let newsDetailsVC = NewsDetailsViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(newsDetailsVC, animated: true)
    }
    
}
