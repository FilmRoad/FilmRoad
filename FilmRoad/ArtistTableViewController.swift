//
//  SearchTableViewController.swift
//  FilmRoad
//
//  Created by hello on 4/3/25.
//

import UIKit

class ArtistTableViewController: UITableViewController {
  
    private var currentPageItems: [FilmRoadItem] {
            let filtered = FilmDataStore.shared.items.filter { item in
                if entryType == "show" {
                    navigationItem.title = "예능"
                    return item.format == "show"
                } else {
                    navigationItem.title = "k-pop"
                    return item.format == "artist"
                }
            }
            return filtered
        }
    var uniqueTitles: [String] = []
    var entryType: String?
    let backButton = UIBarButtonItem()


    override func viewDidLoad() {
        super.viewDidLoad()
        uniqueTitles = Array(Set(currentPageItems.map { $0.mediaTitle }))
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqueTitles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = uniqueTitles[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "artist", for: indexPath)
        
        guard let artistName = cell.viewWithTag(1) as? UILabel else {return cell}
        
        artistName.text = item
        
        
        

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow,
           let targetVC = segue.destination as? ListTableViewController {
            let selectedItem = uniqueTitles[indexPath.row]
            targetVC.titleName = selectedItem
        }
    }
}
