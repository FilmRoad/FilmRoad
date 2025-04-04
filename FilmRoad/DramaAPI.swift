
//
//  File.swift
//  FlimRoad
//
//  Created by hello on 4/3/25.
//

import Alamofire
import UIKit

var drama: [Drama]?

func dramaWithImage(_ q: String, completion: @escaping ([Drama]?) -> Void) {
    
    let params: Parameters = ["query" : q, "api_key" : Key.mediaKey, "language" : "ko-KR"]
    
    let endPoint = "https://api.themoviedb.org/3/search/tv"
    
    AF.request(endPoint, parameters: params).responseDecodable(of: DramaResponse.self) { response in
        
        switch response.result{
        case .success(let root):
            drama = root.results
            completion(root.results)
        case .failure(let error):
            print(error.localizedDescription)
            completion(nil)
        }
    }
}
