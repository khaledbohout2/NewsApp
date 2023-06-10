import UIKit

class LoadingView: UIView {
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .yellow
        return loadingIndicator
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        isHidden = true
        addSubview(loadingIndicator)
        addSubview(titleLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            titleLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func show() {
        isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hide() {
        isHidden = true
        loadingIndicator.stopAnimating()
    }
    
}
