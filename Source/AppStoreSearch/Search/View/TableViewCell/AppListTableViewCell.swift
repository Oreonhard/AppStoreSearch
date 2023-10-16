//
//  SearchingListCell.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/17.
//

import UIKit
import Kingfisher
import Cosmos

class AppListTableViewCell: UITableViewCell {
    
    // MARK: - Global Variable
    
    static let reuseIdentifier = "AppListTableViewCell"
    
    // MARK: - UI Component
    
    private lazy var appInfo: UIView = {
        let appInfo = UIView()
        self.backgroundColor = .clear
        appInfo.translatesAutoresizingMaskIntoConstraints = false
        
        return appInfo
    }()
    
    private lazy var appIcon: UIImageView = {
        let appIcon = UIImageView()
        appIcon.layer.cornerRadius = 10.0
        appIcon.layer.masksToBounds = true
        appIcon.layer.borderWidth = 1.0
        appIcon.layer.borderColor = CGColor(gray: 0.8, alpha: 0.5)
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        
        return appIcon
    }()
    
    private lazy var appTitle: UILabel = {
        let appTitle = UILabel()
        appTitle.font = .systemFont(ofSize: 16.0, weight: .medium)
        appTitle.translatesAutoresizingMaskIntoConstraints = false
        
        return appTitle
    }()
    
    private lazy var starRating: CosmosView = {
        let starRating = CosmosView()
        starRating.translatesAutoresizingMaskIntoConstraints = false
        starRating.settings.fillMode = .precise
        starRating.settings.updateOnTouch = false
        starRating.settings.totalStars = 5
        starRating.settings.starMargin = 0.05
        starRating.settings.starSize = 15.0
        starRating.settings.emptyBorderColor = .systemGray
        starRating.settings.filledBorderColor = .systemGray
        starRating.settings.filledColor = .systemGray
        starRating.settings.emptyBorderWidth = 1.0
        starRating.settings.filledBorderWidth = 1.0
        starRating.settings.textColor = UIColor(red: 209.0/255.0, green: 209.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        starRating.settings.textMargin = 3.0
        
        return starRating
    }()
    
    private lazy var installButton: UIButton = {
        let installButton = UIButton()
        installButton.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        installButton.layer.cornerRadius = 12.0
        installButton.setTitle("받기", for: .normal)
        installButton.setTitleColor(.systemBlue, for: .normal)
        installButton.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        
        installButton.translatesAutoresizingMaskIntoConstraints = false
        
        return installButton
    }()
    
    private lazy var previewImages: UIStackView = {
        let previewImages = UIStackView()
        previewImages.axis = .horizontal
        previewImages.alignment = .fill
        previewImages.distribution = .fillEqually
        previewImages.spacing = 10.0
        previewImages.backgroundColor = .clear
        previewImages.translatesAutoresizingMaskIntoConstraints = false
        
        return previewImages
    }()
    
    // MARK: - Override Function
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        addContentView()
        setAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        previewImages.arrangedSubviews.forEach({
            previewImages.removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
    }
    
}

// MARK: - Custon Function
extension AppListTableViewCell {
    
    func bindUI(appInfo: AppInfo) {
        self.appTitle.text = appInfo.appTitle
        
        if let imageURL = URL(string: appInfo.appIcon) {
            self.appIcon.kf.setImage(with: imageURL)
        }
        
        appInfo.previewImages.forEach({
            if let imageURL = URL(string: $0), previewImages.arrangedSubviews.count < 3 {
                let previewImage = UIImageView()
                previewImage.layer.cornerRadius = 10.0
                previewImage.layer.borderWidth = 1.0
                previewImage.layer.borderColor = CGColor(gray: 0.8, alpha: 0.5)
                previewImage.layer.masksToBounds = true
                previewImage.kf.setImage(with: imageURL)
                previewImages.addArrangedSubview(previewImage)
            }
        })
        
        starRating.rating = appInfo.starRating
        starRating.text = conversionScore(appInfo.reviewCount)
    }
    
    private func addContentView() {
        contentView.addSubview(appInfo)
        appInfo.addSubview(appIcon)
        appInfo.addSubview(appTitle)
        appInfo.addSubview(starRating)
        appInfo.addSubview(installButton)
        
        contentView.addSubview(previewImages)
    }
    
    private func setAutolayout() {
        NSLayoutConstraint.activate([
            appInfo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            appInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            appInfo.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0),
            appInfo.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.0),
            appInfo.heightAnchor.constraint(equalToConstant: 75.0)
        ])
        
        NSLayoutConstraint.activate([
            appIcon.centerYAnchor.constraint(equalTo: appInfo.centerYAnchor),
            appIcon.leftAnchor.constraint(equalTo: appInfo.leftAnchor),
            appIcon.heightAnchor.constraint(equalTo: appInfo.heightAnchor, multiplier: 0.85),
            appIcon.widthAnchor.constraint(equalTo: appIcon.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            installButton.rightAnchor.constraint(equalTo: appInfo.rightAnchor, constant: -10.0),
            installButton.centerYAnchor.constraint(equalTo: appInfo.centerYAnchor),
            installButton.widthAnchor.constraint(equalToConstant: 73.0),
            installButton.heightAnchor.constraint(equalToConstant: 25.0)
        ])
        
        NSLayoutConstraint.activate([
            appTitle.topAnchor.constraint(equalTo: appIcon.topAnchor),
            appTitle.leftAnchor.constraint(equalTo: appIcon.rightAnchor, constant: 10.0),
            appTitle.rightAnchor.constraint(equalTo: installButton.leftAnchor, constant: -20.0)
        ])
        
        NSLayoutConstraint.activate([
            starRating.bottomAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: -5.0),
            starRating.leftAnchor.constraint(equalTo: appIcon.rightAnchor, constant: 8.0),
            starRating.rightAnchor.constraint(equalTo: installButton.leftAnchor, constant: -20.0)
        ])
        
        NSLayoutConstraint.activate([
            previewImages.topAnchor.constraint(equalTo: appInfo.bottomAnchor, constant: 15.0),
            previewImages.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0),
            previewImages.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.0),
            previewImages.heightAnchor.constraint(equalToConstant: 255.0)
        ])
    }
    
}
