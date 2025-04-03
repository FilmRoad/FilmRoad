//
//  TMDBModel.swift
//  FilmLoad
//
//  Created by Song Kim on 4/3/25.
//
// 드라마 포스터 API

import Foundation

struct DramaResponse: Codable {
    let results: [Drama]
}

struct Drama: Codable {
    let posterPath: String
    let name: String
    
    enum CodingKeys: String, CodingKey{
        case posterPath = "poster_path"
        case name
    }
}
