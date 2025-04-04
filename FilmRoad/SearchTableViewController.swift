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
        print("서치함수")
        guard let keyword else {return}
        print("keyword출력 : \(keyword)")
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
    

}
extension SearchTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWithKeyword(searchBar.text)
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("취소")
    }
}
