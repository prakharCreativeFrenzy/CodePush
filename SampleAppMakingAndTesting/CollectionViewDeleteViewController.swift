

import UIKit

class CollectionViewDeleteViewController: UIViewController, delegateListingCollectionViewCell, delegateUnPopularMovieCollectionViewCell, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var movieList = [movieData]()
    lazy var movieListBelow7: [movieData] = []
    lazy var movieListAbove7: [movieData] = []
    lazy var filteredMovieListBelow7: [movieData] = []
    lazy var filteredMovieListAbove7: [movieData] = []
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        searchBar.delegate = self
        getListData()
        collectionViewWork()
    }

    func collectionViewWork() {
        collectionView.register(UINib(nibName: "ListingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListingCollectionViewCell")
        collectionView.register(UINib(nibName: "UnPopularMovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UnPopularMovieCollectionViewCell")
        collectionView.register(UINib(nibName: "CollectionReusableViewHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionReusableViewHeader")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func btnDeletePressed(index: Int) {
        print("The index of the delete Button IS: \(index)")
        deleteElement(index: index, section: 0)
    }
   
    func btnDeletePressedUnPopular(index: Int) {
        print("Delete button clicked in unpopular cell")
        deleteElement(index: index, section: 1)
    }

    func deleteElement(index: Int, section: Int) {
        if section == 0 {
            movieListAbove7.remove(at: index)
        } else {
            movieListBelow7.remove(at: index)
        }
        
        let deleteIndexPath = IndexPath(item: index, section: section)
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [deleteIndexPath])
        }
    }

    func getListData() {
        let url = "https://uptodd.com/movie/now_playing"
        
        ApiWrapper.sharedManager().getMovieList(url: url) { [weak self] (data) in
            guard let self = self else { return }
            
            print(data)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let movies = try JSONDecoder().decode([movieData].self, from: jsonData)
                print(movies)
                
                self.movieListBelow7 = movies.filter { ($0.voteAverage ?? 0) < 7 }
                self.movieListAbove7 = movies.filter { ($0.voteAverage ?? 0) >= 7 }
                self.filteredMovieListBelow7 = self.movieListBelow7
                self.filteredMovieListAbove7 = self.movieListAbove7
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error converting or decoding JSON: \(error)")
            }
        }
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        filterContentForSearchText(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredMovieListBelow7 = searchText.isEmpty ? movieListBelow7 : movieListBelow7.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
        filteredMovieListAbove7 = searchText.isEmpty ? movieListAbove7 : movieListAbove7.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
        collectionView.reloadData()
    }
}

extension CollectionViewDeleteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return isSearching ? filteredMovieListAbove7.count : movieListAbove7.count
        } else {
            return isSearching ? filteredMovieListBelow7.count : movieListBelow7.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListingCollectionViewCell", for: indexPath) as! ListingCollectionViewCell
            let movie = isSearching ? filteredMovieListAbove7[indexPath.item] : movieListAbove7[indexPath.item]
            
            if let imageView = cell.imageView {
                let urlString = "https://image.tmdb.org/t/p/w342" + (movie.posterPath ?? "")
                if let url = URL(string: urlString) {
                    imageView.loadImage(from: url, placeholder: UIImage(named: "placeholder"))
                    print("The image url is: \(url)")
                }
            }
            
            cell.delegate = self
            cell.btnDeleteOutlet.tag = indexPath.row
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnPopularMovieCollectionViewCell", for: indexPath) as! UnPopularMovieCollectionViewCell
            let movie = isSearching ? filteredMovieListBelow7[indexPath.item] : movieListBelow7[indexPath.item]
            
            if let imageView = cell.imageView {
                let urlString = "https://image.tmdb.org/t/p/w342" + (movie.posterPath ?? "")
                if let url = URL(string: urlString) {
                    imageView.loadImage(from: url, placeholder: UIImage(named: "placeholder"))
                    print("The image url is: \(url)")
                }
            }
            
            cell.lblMovieTitle.text = movie.title
            cell.lblMovieDescription.text = movie.overview
            cell.delegate = self
            cell.btnDeleteOutlet.tag = indexPath.row
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width
        return CGSize(width: width, height: indexPath.section == 0 ? 400 : 430)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("The indexpath selected is: \(indexPath.row)")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        if indexPath.section == 0 {
            nextViewController.videoUrl = (isSearching ? filteredMovieListAbove7[indexPath.row] : movieListAbove7[indexPath.row]).videoUrl ?? ""
        } else {
            nextViewController.videoUrl = (isSearching ? filteredMovieListBelow7[indexPath.row] : movieListBelow7[indexPath.row]).videoUrl ?? ""
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionReusableViewHeader", for: indexPath) as! CollectionReusableViewHeader
            headerView.lblTitle.text = indexPath.section == 0 ? "Popular Movies"  : "Unpopular Movies"
            return headerView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 50)
    }
}
