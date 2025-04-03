//
//  FilmRoadModel.swift
//  FilmLoad
//
//  Created by Song Kim on 4/3/25.
//

import Foundation

// 관광지 API 호출 모델
struct APIResponse: Codable {
    let header: ResponseHeader
    let body: ResponseBody
}

struct ResponseHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

struct ResponseBody: Codable {
    let items: [FilmRoadItem]
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct FilmRoadItem: Codable {
    let placeName: String
    let format: String
    let mediaTitle: String
    let address: String
    let tel: String
    let coordinates: String
    let issuedDate: String
    let type: String?
    let subDescription: String
    let description: String
}

struct FilmRoadItemWithURL: Codable {
    let placeName: String
    let format: String
    let mediaTitle: String
    let address: String
    let tel: String
    let coordinates: String
    let issuedDate: String
    let type: String?
    let subDescription: String
    let description: String
    let url: String
}
