import UIKit
import Combine

class NewsDetailsViewController: UIViewController {
    
    private let viewModel: NewsDetailsViewModel
    private var coordinator: MainCoordinator

    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet
    private weak var titleLabel: UILabel!
    @IBOutlet
    private weak var publishedAtLabel: UILabel!
    @IBOutlet
    private weak var sourceLabel: UILabel!
    @IBOutlet
    private weak var descriptionLabel: UILabel!
    @IBOutlet
    private weak var newsImageView: UIImageView!
    
    init(viewModel: NewsDetailsViewModel, coordinator: MainCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: "NewsDetailsViewController", bundle: nil)
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    private func bindUI() {
        viewModel.articleSubject
            .sink { [unowned self] article in
                self.updateUI(with: article)
            }.store(in: &subscriptions)
    }
    
    private func updateUI(with article: Article) {
        self.title = article.title
        titleLabel.text = article.title
        publishedAtLabel.text = article.publishedAtTimeAgo
        sourceLabel.text = article.source.name
        descriptionLabel.text = article.articleDescription
        guard let imageUrlString = article.urlToImage else { return }
        newsImageView.setImage(with: imageUrlString)
    }

}
