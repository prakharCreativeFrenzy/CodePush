
import UIKit

protocol delegateUnPopularMovieCollectionViewCell: AnyObject {

    func btnDeletePressedUnPopular(index:Int)
    
}

class UnPopularMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieDescription: UILabel!
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    
    weak var delegate: delegateUnPopularMovieCollectionViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        viewMain.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
    }
    
    @IBAction func btnDeletePressed(_ sender: UIButton) {
        
        print("Button Delete Pressed in UnPopular Movie Cell")
        delegate?.btnDeletePressedUnPopular(index: sender.tag)
        
    }
    
}
