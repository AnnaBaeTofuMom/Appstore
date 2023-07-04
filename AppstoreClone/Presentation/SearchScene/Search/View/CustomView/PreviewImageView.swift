//
//  PreviewImageView.swift
//  AppstoreClone
//
//  Created by 경원이 on 2023/07/04.
//

import UIKit

class PreviewImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.contentMode = .scaleAspectFill
        self.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
    }
}
