import UIKit

class SearchTableViewController: UITableViewController {
    let items = FilmDataStore.shared.itemsURL
    var titleArr: [FilmRoadItemWithURL] = []
    var filteredTitleArr: [FilmRoadItemWithURL] = []  // 자동완성 결과를 담을 배열
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // 자동완성 기능을 위한 필터링 함수
    func searchWithKeyword(_ keyword: String?) {
        guard let keyword = keyword, !keyword.isEmpty else {
            filteredTitleArr = []
            tableView.reloadData()
            return
        }
        
        // 필터링된 자동완성 항목을 filteredTitleArr에 저장
        filteredTitleArr = items.filter { $0.mediaTitle.lowercased().contains(keyword.lowercased()) }
        
        // 테이블뷰 갱신
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 자동완성 결과를 기반으로 행 수를 반환
        return filteredTitleArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용하고 데이터 추가
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
        let title = filteredTitleArr[indexPath.row]
        let lblText = cell.viewWithTag(1) as? UILabel
        lblText?.text = title.mediaTitle
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 세그웨이를 통해 데이터 전달
        let destinationVC = segue.destination as? ListTableViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedItem = filteredTitleArr[indexPath.row]
        destinationVC?.titleName = selectedItem.mediaTitle
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 버튼 클릭 시 자동완성 필터링 실행
        searchWithKeyword(searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    // 실시간으로 텍스트 입력을 감지하고 필터링
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWithKeyword(searchText)
    }
}


