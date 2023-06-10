import UIKit

class NewsTableViewCell: UITableViewCell, CellReusable {

    @IBOutlet
    private weak var titleLabel: UILabel!
    @IBOutlet
    private weak var publishedAtLabel: UILabel!
    @IBOutlet
    private weak var sourceLabel: UILabel!
    @IBOutlet
    private weak var newsImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    func configure(with article: Article) {
        titleLabel.text = article.title
        publishedAtLabel.text = article.publishedAtTimeAgo
        sourceLabel.text = article.source.name
        guard let imageUrlString = article.urlToImage else { return }
        newsImageView.setImage(with: imageUrlString)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            }, completion: { [weak self] finished in
                UIView.animate(withDuration: 0.2) {
                    self?.transform = .identity
                }
            })
        }
    }

}
