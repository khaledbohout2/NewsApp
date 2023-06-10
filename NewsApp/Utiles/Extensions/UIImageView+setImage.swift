import Kingfisher
import UIKit

extension UIImageView {
    
    func setImage(with imageUrl : String? ) {
        
        let placeholderName = "noImage"

        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            self.image = UIImage(named : placeholderName)
            return
        }
        
        let resource = ImageResource(downloadURL: url, cacheKey: imageUrl)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: resource, placeholder: UIImage(named : placeholderName) , options: nil)
    }
}
