import UIKit
import Combine

class OnboardingVC: UIViewController, UITableViewDelegate, Alertable {

    enum Section: String, CaseIterable {
        case country = "Select Country"
        case category = "Select Category"
    }

    @IBOutlet
    private weak var tableView: UITableView!
    @IBOutlet
    private weak var okayButton: UIButton!
    
    private lazy var dataSource = makeDataSource()
    private let viewModel: OnboardingViewModel
    private var subscriptions = Set<AnyCancellable>()

    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.attachAnchors(to: (navigationController?.view)!)
        return loadingView
    }()
    
    private let cellIdentifier = "FilterCell"
    
    var selectedFilters: (Country, NewsCategory)?
    private var coordinator: MainCoordinator

    
    init(viewModel: OnboardingViewModel, coordinator: MainCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: "OnboardingVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedFilters = viewModel.selectedFilters
    }
    
    private func setupUI() {
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        okayButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    private func bindUI() {
        viewModel.$filters
            .sink { [unowned self] countries, categories in
                self.updateData(with: countries, categories: categories)
            }.store(in: &subscriptions)
    }
    
    private func render(_ state: ViewState) {
        switch state {
        case .loading:
            loadingView.show()
        case .error(let message):
            loadingView.hide()
            showAlert(message: message)
        case .success:
            loadingView.hide()
        }
    }

    // MARK: - TableView
    private func makeDataSource() -> DataSource {
        let myDatasource =
        DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType {
            case .country:
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
                guard let country = itemIdentifier as? Country else { fatalError("Cannot create country cell")}
                
                var content = cell.defaultContentConfiguration()
                content.text = country.name
                cell.contentConfiguration = content
                cell.accessoryType = country == self.selectedFilters?.0 ? .checkmark : .none
                cell.selectionStyle = .none
                return cell
            case .category:
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
                guard let category = itemIdentifier as? NewsCategory else { fatalError("Cannot create category cell")}
                
                var content = cell.defaultContentConfiguration()
                content.text = category.rawValue
                cell.contentConfiguration = content
                cell.accessoryType = category == self.selectedFilters?.1 ? .checkmark : .none
                cell.selectionStyle = .none
                return cell
            }
            
        }
                
        return myDatasource
    }
    
    private func updateData(with countries: CountriesList, categories: [NewsCategory]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapshot.appendSections([Section.country, Section.category])
        snapshot.appendItems(countries, toSection: .country)
        snapshot.appendItems(categories, toSection: .category)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = Section.allCases[indexPath.section]
        switch sectionType {
        case .country:
            selectedFilters?.0 = viewModel.filters.0[indexPath.row]
        case .category:
            selectedFilters?.1 = viewModel.filters.1[indexPath.row]
        }
        tableView.reloadData()
    }
    
    @IBAction private func okayButtonAction(_ sender: UIButton) {
        guard let selectedFilters = selectedFilters else {
            self.showAlert(message: "please select country and category")
            return
        }
        viewModel.didUpdateFilters(selectedFilters: selectedFilters)
        self.coordinator.newsLis()
    }

}


class DataSource: UITableViewDiffableDataSource<OnboardingVC.Section, AnyHashable>  {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return OnboardingVC.Section.allCases[section].rawValue
        }
}
