//
//  SaveData.swift
//  FilmRoad
//
//  Created by Song Kim on 4/3/25.
//

import UIKit
import Foundation

class FilmDataStore {
    static var shared = FilmDataStore() // 어디서든 접근 가능

    private init() {}

    var items: [FilmRoadItem] = []
    var itemsURL: [FilmRoadItemWithURL] = []

    func reset() {
        items = []
        itemsURL = []
    }
}

class SaveData {
    private let filmRoadService = FilmLoadAPI()

    func saveData(completion: @escaping () -> Void) {
        print("📡 영화/드라마 데이터 요청 시작...")
        
        filmRoadService.fetchFilmRoadData { items in
            if items.isEmpty {
                print("❌ 데이터가 없습니다.")
                completion()
                return
            }
            
            print("✅ API 응답 완료, 데이터 수: \(items.count)")
            FilmDataStore.shared.items = items
            print(FilmDataStore.shared.items.count)
            
            var uniqueTitles = Set<String>()
            let filteredItems = items.filter { uniqueTitles.insert($0.mediaTitle).inserted }
            print("🎬 중복 제거 후 이미지 로딩할 데이터 수: \(filteredItems.count)")
            
            let dispatchGroup = DispatchGroup()
            
            for item in filteredItems {
                dispatchGroup.enter()
                self.saveTitleAndImage(item: item) {
                    print("✅ \(item.mediaTitle) - 이미지 URL 로드 완료")
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                print("🔥 모든 이미지 URL 로드 완료! 총 \(FilmDataStore.shared.itemsURL.count)개")
                completion()
            }
        }
    }

    func saveTitleAndImage(item: FilmRoadItem, completion: @escaping () -> Void) {
        if item.format == "drama" {
            dramaWithImage(item.mediaTitle) { drama in
                guard let posterPath = drama?.first?.posterPath else {
                    completion()
                    return
                }
                let posterURL = "https://image.tmdb.org/t/p/original\(posterPath)"
                self.appendToItemsURL(item: item, posterURL: posterURL)
                completion()
            }
        } else if item.format == "movie" {
            movieWithImage(item.mediaTitle) { movie in
                guard let posterPath = movie?.first?.posterPath else {
                    completion()
                    return
                }
                let posterURL = "https://image.tmdb.org/t/p/original\(posterPath)"
                self.appendToItemsURL(item: item, posterURL: posterURL)
                completion()
            }
        } else {
            completion()
        }
    }

    private func appendToItemsURL(item: FilmRoadItem, posterURL: String) {
        DispatchQueue.main.async {
            FilmDataStore.shared.itemsURL.append(FilmRoadItemWithURL(
                placeName: item.placeName,
                format: item.format,
                mediaTitle: item.mediaTitle,
                address: item.address,
                tel: item.tel,
                coordinates: item.coordinates,
                issuedDate: item.issuedDate,
                type: item.type,
                subDescription: item.subDescription,
                description: item.description,
                url: posterURL
            ))
        }
    }
}
