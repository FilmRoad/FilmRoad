//
//  ListTableViewController.swift
//  FilmRoad
//
//  Created by hello on 4/3/25.
//

import UIKit

class ListTableViewController: UITableViewController {
    var titleName: String?
    var data: [FilmRoadItem] = []
    
    let backButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let titleName = titleName {
            data = FilmDataStore.shared.items.filter { $0.mediaTitle == titleName }
        }
        print("🎯 필터링된 데이터 수: \(data.count)")
        tableView.reloadData()
        
        backButton.title = ""
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        
        let titleLB = cell.viewWithTag(1) as? UILabel
        let addressLB = cell.viewWithTag(2) as? UILabel
        let contentLB = cell.viewWithTag(3) as? UILabel

        titleLB?.text = data[indexPath.row].placeName
        addressLB?.text = data[indexPath.row].address
        contentLB?.text = data[indexPath.row].description
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = tableView.indexPathForSelectedRow,
              let targetVC = segue.destination as? DetailViewController
        else {return}
        let place = data[indexPath.row]
        print("프리페어 넘겨주는 값 출력: \(place)")
        targetVC.place = place
    }
}
