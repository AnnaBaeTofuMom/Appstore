//
//  RecentSearchHeaderView.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import UIKit

import SnapKit

class RecentSearchHeaderView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 500))
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init with coder")
    }
    
    private func configure() {
        self.addSubview(label)
    }
    
    private func makeConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}
