//
//  MainCollectionViewController.swift
//  FilmRoad
//
//  Created by hello on 4/3/25.
//

import UIKit
import Kingfisher

class MainCollectionViewController: UICollectionViewController {
    private var items: [FilmRoadItem] = []  // 데이터를 저장할 배열
    private let filmRoadService = FilmLoadAPI() // 서비스 객체
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func fetchData() {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleNameAndImage.filter { $0.format == "drama" }.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
        cell.backgroundColor = .lightGray
        let imageView = cell.viewWithTag(1) as? UIImageView
        
        let imageData = titleNameAndImage[indexPath.row]
        
        if let url = URL(string: imageData.url) {
            imageView?.kf.setImage(with: url) // ✅ Kingfisher로 비동기 이미지 로드
        }
        
        return cell
    }
}

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

