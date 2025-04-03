//
//  FilmLoadAPI.swift
//  FlimRoad
//
//  Created by Song Kim on 4/3/25.
//

import UIKit

class FilmLoadAPI: NSObject, XMLParserDelegate {
    private var items: [FilmRoadItem] = []
    private var currentItem: [String: String] = [:]
    private var currentElement: String = ""
    private var currentValue: String = ""
    private var completion: (([FilmRoadItem]) -> Void)?
    
    func fetchFilmRoadData(completion: @escaping ([FilmRoadItem]) -> Void) {
        self.completion = completion
        let endPoint = "http://api.kcisa.kr/openapi/API_TOU_048/request?serviceKey=\(Key.filmRoadKey)"
        guard let url = URL(string: endPoint) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            let parser = XMLParser(data: data)
            parser.delegate = self
            if parser.parse() {
                DispatchQueue.main.async {
                    self.completion?(self.items.filter { $0.format == "drama" || $0.format == "movie" })
                }
            }
        }.resume()
    }
    
    // MARK: - XMLParserDelegate Methods
    func parserDidStartDocument(_ parser: XMLParser) {
        items.removeAll()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentItem = [:]
        }
        currentValue = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let filmRoadItem = createFilmRoadItem(from: currentItem) {
                items.append(filmRoadItem)
            }
        } else {
            currentItem[elementName] = currentValue
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.completion?(self.items.filter { $0.format == "drama" || $0.format == "movie" })
        }
    }
    
    // MARK: - Helper Method
    private func createFilmRoadItem(from dict: [String: String]) -> FilmRoadItem? {
        guard let placeName = dict["placeName"],
              let format = dict["format"],
              let mediaTitle = dict["mediaTitle"],
              let address = dict["address"],
              let tel = dict["tel"],
              let coordinates = dict["coordinates"],
              let issuedDate = dict["issuedDate"],
              let subDescription = dict["subDescription"],
              let description = dict["description"] else { return nil }
        
        return FilmRoadItem(
            placeName: placeName,
            format: format,
            mediaTitle: mediaTitle,
            address: address,
            tel: tel,
            coordinates: coordinates,
            issuedDate: issuedDate,
            type: dict["type"],
            subDescription: subDescription,
            description: description
        )
    }
}
