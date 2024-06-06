

import UIKit
import Alamofire

class ApiWrapper: NSObject{
    // MARK: Singleton Instance
    
    static let _sharedManager = ApiWrapper()
    
    class func sharedManager() -> ApiWrapper{
        return _sharedManager
    }
    
    func getMovieList(url: String, completion: @escaping ([[String: Any]]) -> Void) {
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonArray = value as? [[String: Any]], !jsonArray.isEmpty {
                    // Handle the array of dictionaries
                    print(jsonArray)
                    completion(jsonArray) // For example, taking the first dictionary
                } else if let jsonDict = value as? [[String: Any]] {
                    // Handle the dictionary
                    print(jsonDict)
                    completion(jsonDict)
                } else {
                    print("Unexpected response format")
                    completion([[:]])
                }
            case .failure(let error):
                print("Request failed: \(error)")
                completion([[:]])
            }
        }
    }

}
