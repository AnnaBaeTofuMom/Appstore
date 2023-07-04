//
//  AppHeaderView.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import UIKit

class AppHeaderView: UIView {
    let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.7
        imageView.layer.borderColor = UIColor(white: 0.8, alpha: 0.8).cgColor
        return imageView
    }()
    
    let nameStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "카카오뱅크"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "멋진 은행 카카오뱅크"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 1
        return label
    }()
    
    let rateLable: UILabel = {
        let label = UILabel()
        label.text = "별별별 2.4"
        label.font = .systemFont(ofSize: 11)
        label.textColor = .lightGray
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        [thumbnailView, nameStack].forEach { self.addSubview($0) }
        [nameLabel, descLabel, rateLable].forEach { nameStack.addArrangedSubview($0) }
    }
    
    private func makeConstraints() {
        thumbnailView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(66)
        }
        
        nameStack.snp.makeConstraints { make in
            make.top.equalTo(thumbnailView.snp.top)
            make.leading.equalTo(thumbnailView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(thumbnailView.snp.bottom)
        }
    }

}
