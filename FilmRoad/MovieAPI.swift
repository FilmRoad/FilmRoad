//
//  File.swift
//  FlimRoad
//
//  Created by hello on 4/3/25.
//
import Kingfisher
import Alamofire
import UIKit


var movie: [Movie]?

func movieWithImage(_ q: String){
    
    let params: Parameters = ["query" : q, "api_key" : Key.mediaKey, "language" : "ko-KR"]
    let endPoint = "https://api.themoviedb.org/3/search/movie"
    
    AF.request(endPoint, parameters: params).responseDecodable(of: MovieResponse.self) { response in
        switch response.result{
        case .success(let root):
            movie = root.results
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        guard let movie,
              let moviePoster = movie.first
        else {return}
        
        print(moviePoster.title)
        print(moviePoster.posterPath)
    }

}
