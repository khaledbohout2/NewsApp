import UIKit
import Combine

class NewsViewController: UITableViewController, Alertable {
    
    private let viewModel: NewsViewModel
    private var coordinator: MainCoordinator
    
    private var subscriptions = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.attachAnchors(to: (navigationController?.view)!)
        return loadingView
    }()
    
    init(viewModel: NewsViewModel, coordinator: MainCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(style: .plain)
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   setupNavigationBarButtons()
        prepareTableView()
        viewModel.viewDidLoad()
    }
    
    private func prepareTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor =  .lightGrayBackground
        tableView.register(NewsTableViewCell.nib, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
        tableView.rowHeight = 100
        tableView.dataSource = dataSource
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshNewsList), for: .valueChanged)
    }
    
    private func bindUI() {
        viewModel.$articles
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [unowned self] articles in
                self.updateData(with: articles)
                self.endRefreshing()
            }.store(in: &subscriptions)
        
        
            viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
                self.render(state)
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
    
    private func endRefreshing() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - TableView
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, Article> {
        return UITableViewDiffableDataSource<Int, Article>(tableView: tableView, cellProvider: {tableView, indexPath, article in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell else { fatalError("Cannot create news cell") }
            cell.configure(with: article)
            return cell
        })
    }
    
    private func updateData(with articles: [Article]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Article>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(articles, toSection: 0)
        DispatchQueue.main.async {
            self.title = self.viewModel.newsListTitle
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let article = self.dataSource.itemIdentifier(for: indexPath) else { return }
            self.coordinator.newsDetails(with: article)
            tableView.isUserInteractionEnabled = true
        }
    }
    
    @objc private func refreshNewsList() {
        viewModel.fetchTopHeadlines()
    }

    enum Icons: String {
        case filterIcon
    }
}
