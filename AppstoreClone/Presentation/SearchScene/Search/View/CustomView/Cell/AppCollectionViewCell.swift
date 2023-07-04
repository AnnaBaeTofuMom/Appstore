//
//  AppCollectionViewCell.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import UIKit

class AppCollectionViewCell: UICollectionViewCell {
    let header = AppHeaderView()
    
    let previewStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    let firstPreview = PreviewImageView(frame: .zero)
    let secondPreview = PreviewImageView(frame: .zero)
    let thridPreview = PreviewImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        [header, previewStack].forEach { contentView.addSubview($0) }
        [firstPreview, secondPreview, thridPreview].forEach { previewStack.addArrangedSubview($0)}
    }
    
    private func makeConstraints() {
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(66)
        }
        
        previewStack.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(8)
        }
    }
    
    func makePreviews(urls: [String]) {
        let array = [firstPreview, secondPreview, thridPreview]
        if urls.count >= 3 {
            for i in 0...2 {
                let imageview = array[i]
                let url = URL(string: urls[i])!
                imageview.kf.setImage(with: url)
            }
        } else {
            for i in 0..<urls.count {
                let imageview = array[i]
                let url = URL(string: urls[i])!
                imageview.kf.setImage(with: url)
            }
        }
    }
}
