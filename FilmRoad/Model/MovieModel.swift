//
//  TMDBModel.swift
//  FilmLoad
//
//  Created by Song Kim on 4/3/25.
//
// 영화 포스터 API

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let posterPath: String
    let title: String
    
    enum CodingKeys: String, CodingKey{
        case posterPath = "poster_path"
        case title
    }
}
