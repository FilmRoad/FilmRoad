//
//  SaveData.swift
//  FilmRoad
//
//  Created by Song Kim on 4/3/25.
//

import UIKit

class SaveData {
    private let filmRoadService = FilmLoadAPI()
    var items: [FilmRoadItem] = []
    var itemsURL: [FilmRoadItemWithURL] = []
    
    func saveData(completion: @escaping () -> Void) {
        print("📡 영화/드라마 데이터 요청 시작...")
        
        filmRoadService.fetchFilmRoadData { items in
            if items.isEmpty {
                print("❌ 데이터가 없습니다.")
                completion()
                return
            }
            
            print("✅ API 응답 완료, 데이터 수: \(items.count)")
            var uniqueTitles = Set<String>()
            self.items = items.filter { uniqueTitles.insert($0.mediaTitle).inserted }
            
            print("🎬 중복 제거 후 데이터 수: \(self.items.count)")
            
            let dispatchGroup = DispatchGroup()
            
            for item in self.items {
                dispatchGroup.enter()
                self.saveTitleAndImage(item: item) {
                    print("✅ \(item.mediaTitle) - 이미지 URL 로드 완료")
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                print("🔥 모든 이미지 URL 로드 완료! 총 \(self.itemsURL.count)개")
                completion()
            }
        }
    }
    
    func saveTitleAndImage(item: FilmRoadItem, completion: @escaping () -> Void) {
        if item.format == "drama" {
            print("🎭 드라마 포스터 요청: \(item.mediaTitle)")
            dramaWithImage(item.mediaTitle) { drama in
                guard let posterPath = drama?.first?.posterPath else {
                    print("❌ \(item.mediaTitle) 포스터 없음")
                    completion()
                    return
                }
                let posterURL = "https://image.tmdb.org/t/p/original\(posterPath)"
                self.appendToItemsURL(item: item, posterURL: posterURL)
                completion()
            }
        } else if item.format == "movie" {
            print("🎬 영화 포스터 요청: \(item.mediaTitle)")
            movieWithImage(item.mediaTitle) { movie in
                guard let posterPath = movie?.first?.posterPath else {
                    print("❌ \(item.mediaTitle) 포스터 없음")
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
            self.itemsURL.append(FilmRoadItemWithURL(
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
            print("🖼️ 저장 완료: \(item.mediaTitle) -> \(posterURL)")
        }
    }
}
