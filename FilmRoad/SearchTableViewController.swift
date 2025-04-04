//
//  SearchTableViewController.swift
//  FilmRoad
//
//  Created by hello on 4/3/25.
//

import UIKit

class SearchTableViewController: UITableViewController {
    let items = FilmDataStore.shared.itemsURL
    var titleArr: [FilmRoadItemWithURL] = []
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    
    func searchWithKeyword(_ keyword: String?){
        guard let keyword else {return}
        titleArr = items.filter{$0.mediaTitle.contains(keyword)}
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
        
        let title = titleArr[indexPath.row]
        let lblText = cell.viewWithTag(1) as? UILabel
        
        lblText?.text = title.mediaTitle
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ListTableViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let selectedItem = titleArr[indexPath.row]
        destinationVC?.titleName = selectedItem.mediaTitle
    }
}

extension SearchTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWithKeyword(searchBar.text)
        searchBar.resignFirstResponder()
    }
}
