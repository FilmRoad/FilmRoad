//
//  MainCollectionViewController.swift
//  FilmRoad
//
//  Created by hello on 4/3/25.
//

import UIKit
import Kingfisher

class MainCollectionViewController: UICollectionViewController {
    private var saveData = SaveData() // 데이터 저장 관리 클래스
    private var itemsURL: [FilmRoadItemWithURL] = []  // 포스터 포함된 데이터
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 로딩 인디케이터 설정
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func fetchData() {
        activityIndicator.startAnimating()
        print("📡 데이터 로드 시작...")
        
        saveData.saveData {
            DispatchQueue.main.async {
                self.itemsURL = self.saveData.itemsURL.filter { $0.format == "drama" } // 드라마만 필터링
                print("✅ 컬렉션 뷰 데이터 갱신 완료: \(self.itemsURL.count)개")
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsURL.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
        cell.backgroundColor = .lightGray
        let imageView = cell.viewWithTag(1) as? UIImageView
        
        let imageData = itemsURL[indexPath.row]
        
        if let url = URL(string: imageData.url) {
            print("🔗 이미지 로드: \(imageData.mediaTitle) -> \(url)")
            imageView?.kf.setImage(with: url)
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
