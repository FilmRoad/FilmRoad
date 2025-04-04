//
//  TabHeaderView.swift
//  FilmRoad
//
//  Created by Song Kim on 4/4/25.
//

import UIKit

class TabHeaderView: UICollectionReusableView {
    static let identifier = "TabHeaderView"
    
    private let movieButton = UIButton(type: .system)
    private let dramaButton = UIButton(type: .system)
    private let underlineView = UIView()
    
    var didSelectTab: ((String) -> Void)?
    private var selectedButton: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setSelected(movieButton, isInit: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let buttonStack = UIStackView()

    private func setupView() {
        backgroundColor = .white

        movieButton.setTitle("영화", for: .normal)
        dramaButton.setTitle("드라마", for: .normal)
        
        [movieButton, dramaButton].forEach {
            $0.setTitleColor(.gray, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
            $0.backgroundColor = .clear
        }

        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.addArrangedSubview(movieButton)
        buttonStack.addArrangedSubview(dramaButton)

        addSubview(buttonStack)
        addSubview(underlineView)

        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        underlineView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: topAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 44),
            
            underlineView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
            underlineView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            underlineView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        underlineView.backgroundColor = .black

        movieButton.addTarget(self, action: #selector(movieTapped), for: .touchUpInside)
        dramaButton.addTarget(self, action: #selector(dramaTapped), for: .touchUpInside)
    }

    @objc private func movieTapped() {
        setSelected(movieButton)
        didSelectTab?("movie")
    }

    @objc private func dramaTapped() {
        setSelected(dramaButton)
        didSelectTab?("drama")
    }

    private func setSelected(_ button: UIButton, isInit: Bool = false) {
        guard selectedButton != button || isInit else { return }

        [movieButton, dramaButton].forEach {
            $0.setTitleColor(.gray, for: .normal)
        }
        button.setTitleColor(.black, for: .normal)

        selectedButton = button

        UIView.animate(withDuration: 0.25) {
            if button == self.movieButton {
                self.underlineView.frame.origin.x = 0
            } else {
                self.underlineView.frame.origin.x = self.frame.width / 2
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if selectedButton == movieButton {
            underlineView.frame.origin.x = 0
        } else {
            underlineView.frame.origin.x = frame.width / 2
        }
    }
}
