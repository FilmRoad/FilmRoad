//
//  FooterView.swift
//  FilmRoad
//
//  Created by Song Kim on 4/4/25.
//

import UIKit

class FooterView: UICollectionReusableView {
    private let previousButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let pageLabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // 버튼 타이틀
        previousButton.setTitle("◀︎ 이전", for: .normal)
        nextButton.setTitle("다음 ▶︎", for: .normal)

        // 페이지 라벨 스타일
        pageLabel.textAlignment = .center
        pageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        pageLabel.textColor = .darkGray

        // 스택 뷰 설정
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // 스택에 추가
        stackView.addArrangedSubview(previousButton)
        stackView.addArrangedSubview(pageLabel)
        stackView.addArrangedSubview(nextButton)
        stackView.tintColor = .black

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configure(previousAction: Selector, nextAction: Selector, target: Any, currentPage: Int, maxPage: Int) {
        previousButton.addTarget(target, action: previousAction, for: .touchUpInside)
        nextButton.addTarget(target, action: nextAction, for: .touchUpInside)

        previousButton.isEnabled = currentPage > 1
        nextButton.isEnabled = currentPage < maxPage

        previousButton.setTitleColor(previousButton.isEnabled ? .black : .lightGray, for: .normal)
        nextButton.setTitleColor(nextButton.isEnabled ? .black : .lightGray, for: .normal)

        // 현재 페이지 라벨 업데이트
        pageLabel.text = "\(currentPage) / \(maxPage)"
    }
}
