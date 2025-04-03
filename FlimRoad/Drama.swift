
//
//  File.swift
//  FlimRoad
//
//  Created by hello on 4/3/25.
//
import Kingfisher
import Alamofire
import UIKit

var drama: [Drama]?

func dramaWithImage(_ q: String){
    
    let params: Parameters = ["query" : q, "api_key" : Key.mediaKey, "language" : "ko-KR"]
    
    let endPoint = "https://api.themoviedb.org/3/search/tv"
    
    AF.request(endPoint, parameters: params).responseDecodable(of: DramaResponse.self) { response in
        
        switch response.result{
        case .success(let root):
            drama = root.results
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        guard let drama,
              let tvPoster = drama.first
        else {return}
        
        print(tvPoster.name)
        print(tvPoster.posterPath)
    }

}


//
//if let poster = media?.first{
//    print(poster.title)
//    print(poster.posterPath)
//}
