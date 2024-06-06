
import UIKit

protocol delegateListingCollectionViewCell: AnyObject {

    func btnDeletePressed(index:Int)
    
}

class ListingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    weak var delegate: delegateListingCollectionViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        viewMain.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
    }
    
    @IBAction func btnDeletePressed(_ sender: UIButton) {
        
        print("Button Delete Pressed.")
        delegate?.btnDeletePressed(index: sender.tag)
    }
    
}
