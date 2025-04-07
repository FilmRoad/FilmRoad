//
//  MainCollectionViewController.swift
//  FilmRoad
//
//  Created by hello on 4/3/25.
//

import UIKit
import Kingfisher

class MainCollectionViewController: UICollectionViewController {
    private var saveData = SaveData()
    private var selectedFormat: String = "movie"
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var isLoading: Bool = true
    var page = 1
    
    let backButton = UIBarButtonItem()

    private var currentPageItems: [FilmRoadItemWithURL] {
        let filtered = FilmDataStore.shared.itemsURL.filter { $0.format == selectedFormat }
        let startIndex = (page - 1) * 20
        let endIndex = min(startIndex + 20, filtered.count)
        guard startIndex < filtered.count else { return [] }
        return Array(filtered[startIndex..<endIndex])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupActivityIndicator()
        setupNavigationBarAppearance()
        fetchData()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false

        backButton.title = ""
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    private func setupNavigationBar() {
        let logoImage = UIImage(named: "logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        let logoItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoItem
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
        collectionView.register(TabHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TabHeaderView.identifier)
    }
    
    private func fetchData() {
        isLoading = true
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        print("📡 데이터 로드 시작...")
        
        saveData.saveData {
            DispatchQueue.main.async {
                self.isLoading = false
                self.collectionView.reloadData() // footer 다시 보여주기 위해 reload
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc private func previousPage() {
        if page > 1 {
            page -= 1
            collectionView.reloadData()
            collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    @objc private func nextPage() {
        let filteredCount = FilmDataStore.shared.itemsURL.filter { $0.format == selectedFormat }.count
        if page < Int(ceil(Double(filteredCount) / 20.0)) {
            page += 1
            collectionView.reloadData()
            collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPageItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
        let imageView = cell.viewWithTag(1) as? UIImageView
        
        let imageData = currentPageItems[indexPath.row]
        
        if let url = URL(string: imageData.url) {
            imageView?.kf.setImage(with: url)
        }
        return cell
    }
}

// 콜렉션뷰 사이즈
extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let spacing: CGFloat = 20
        let totalSpacing = spacing * (itemsPerRow - 1)
        
        let width = (collectionView.frame.width - totalSpacing - 40) / itemsPerRow
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// 헤더 푸터
extension MainCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TabHeaderView.identifier, for: indexPath) as! TabHeaderView
            header.didSelectTab = { [weak self] selected in
                self?.selectedFormat = selected
                self?.page = 1
                self?.collectionView.reloadData()
            }
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath) as! FooterView
            let maxPage = Int(ceil(Double(FilmDataStore.shared.itemsURL.filter { $0.format == selectedFormat }.count) / 20.0))
            footer.configure(
                previousAction: #selector(previousPage),
                nextAction: #selector(nextPage),
                target: self,
                currentPage: page,
                maxPage: maxPage
            )
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return isLoading ? .zero : CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}

extension MainCollectionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView.indexPathsForSelectedItems?.first,
           let destinationVC = segue.destination as? ListTableViewController {
            let selectedItem = currentPageItems[indexPath.row]
            destinationVC.titleName = selectedItem.mediaTitle
        }
    }
}
