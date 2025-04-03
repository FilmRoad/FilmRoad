//
//  Model.swift
//  FilmLoad
//
//  Created by hello on 4/2/25.
//

import Foundation

// 최상위 응답 구조
struct APIResponse: Codable {
    let header: ResponseHeader
    let body: ResponseBody
}

// 응답 헤더
struct ResponseHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

// 응답 바디
struct ResponseBody: Codable {
    let items: [ResponseItem]
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

// 개별 장소 아이템
struct ResponseItem: Codable {
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
