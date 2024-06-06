

import UIKit
import WebKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    lazy var videoUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadYouTubeVideo(urlString: videoUrl)
        
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        print("Back button pressed ")
        navigationController?.popViewController(animated: true)
        
    }
    
    func loadYouTubeVideo(urlString: String) {
         guard let url = URL(string: urlString) else {
             return
         }
         let request = URLRequest(url: url)
         webView.load(request)
     }
    
}
