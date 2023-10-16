//
//  AppPreviewCollectionViewCell.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/19.
//

import UIKit

class AppPreviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Global Variable
    
    static let reuseIdentifier = "AppPreviewCollectionViewCell"
    
    // MARK: - UI Component
    
    lazy var previewImage: UIImageView = {
        let previewImage = UIImageView()
        previewImage.layer.cornerRadius = 30.0
        previewImage.layer.borderWidth = 1.0
        previewImage.layer.borderColor = CGColor(gray: 0.8, alpha: 0.5)
        previewImage.layer.masksToBounds = true
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        
        return previewImage
    }()
    
    var imageURL: String! {
        didSet {
            setImage()
        }
    }
    
    // MARK: - Override function
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContentView()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Custom Function

extension AppPreviewCollectionViewCell {
    
    private func addContentView() {
        contentView.addSubview(previewImage)
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            previewImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            previewImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            previewImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            previewImage.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    private func setImage() {
        if let url = URL(string: imageURL) {
            previewImage.kf.setImage(with: url)
        }
    }
}
