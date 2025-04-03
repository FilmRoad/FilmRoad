//
//  SaveData.swift
//  FilmRoad
//
//  Created by Song Kim on 4/3/25.
//

class SaveData {
    private let filmRoadService = FilmLoadAPI()
    var items: [FilmRoadItem] = []
    var itemsURL: [FilmRoadItemWithURL] = []
    
    func saveData() {
        filmRoadService.fetchFilmRoadData { items in
            
            if items.isEmpty {
                print("❌ 데이터가 없습니다.")
                return
            }
            print("✅ 데이터 수: \(items.count)")
            var uniqueTitles = Set<String>()
            self.items = items.filter { uniqueTitles.insert($0.mediaTitle).inserted && $0.format == "drama" }
            
            print("🎬 중복 제거 후 데이터 수: \(self.items.count)")
            
            self.saveTitleAndImage(for: self.items) {
                print("✅ 모든 이미지 URL 로드 완료! titleNameAndImage: \(titleNameAndImage.count)")
            }
            
        }
    }
    
    
    func saveTitleAndImage(item: FilmRoadItem) {
        var updatedImageData: [ImageData] = []
        for item in items {
            dramaWithImage(title) { drama in
            guard let posterPath = drama?.first?.posterPath else { return }
            let posterURL = "https://image.tmdb.org/t/p/original\(posterPath)"
                
            }
        }

    }
}
