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
    private var itemsURL: [FilmRoadItemWithURL] = []
    private var selectedFormat: String = "movie"
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var page = 1
    
    private var currentPageItems: [FilmRoadItemWithURL] {
        let filtered = itemsURL.filter { $0.format == selectedFormat }
        let startIndex = (page - 1) * 20
        let endIndex = min(startIndex + 20, filtered.count)
        guard startIndex < filtered.count else { return [] }
        return Array(filtered[startIndex..<endIndex])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
        collectionView.register(TabHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TabHeaderView.identifier)
    }
    
    private func fetchData() {
        activityIndicator.startAnimating()
        print("📡 데이터 로드 시작...")
        
        saveData.saveData {
            DispatchQueue.main.async {
                self.itemsURL = self.saveData.itemsURL
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
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
        if page < Int(ceil(Double(itemsURL.count) / 20.0)) {
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
        cell.backgroundColor = .lightGray
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
            let maxPage = Int(ceil(Double(itemsURL.filter { $0.format == selectedFormat }.count) / 20.0))
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
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}
