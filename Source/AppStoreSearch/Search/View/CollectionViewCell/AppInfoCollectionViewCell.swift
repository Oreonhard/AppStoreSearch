//
//  AppInfoCollectionViewCell.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/18.
//

import UIKit
import Cosmos

class AppInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Global Variable
    
    static let reuseIdentifier = "AppInfoCollectionViewCell"
    
    // MARK: - UI Component
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5.0
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.textColor = .systemGray
        topLabel.font = .systemFont(ofSize: 12.0)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return topLabel
    }()
    
    lazy var middleLabel: UILabel = {
        let middleLabel = UILabel()
        middleLabel.textColor = .systemGray
        middleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 22.0)
        middleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return middleLabel
    }()
    
    lazy var bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.textColor = .systemGray
        bottomLabel.font = .systemFont(ofSize: 12.0)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return bottomLabel
    }()
    
    lazy var starRating: CosmosView = {
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
        
        return starRating
    }()
    
    lazy var iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        return icon
    }()
    
    lazy var topLine: CALayer = {
       let topLine = CALayer()
        topLine.backgroundColor = UIColor.separator.cgColor
        
        return topLine
    }()
    
    lazy var rightLine: CALayer = {
       let rightLine = CALayer()
        rightLine.backgroundColor = UIColor.separator.cgColor
        
        return rightLine
    }()
}

// MARK: - Custom Function

extension AppInfoCollectionViewCell {
    
    func addContentView(infoType: InfoType) {
        contentView.addSubview(stackView)
        contentView.layer.addSublayer(topLine)
        contentView.layer.addSublayer(rightLine)
        
        stackView.addArrangedSubview(topLabel)
        switch infoType {
        case .limitAge, .chart, .language:
            stackView.addArrangedSubview(middleLabel)
            stackView.addArrangedSubview(bottomLabel)
        case .score:
            stackView.addArrangedSubview(middleLabel)
            stackView.addArrangedSubview(starRating)
        case .developer:
            stackView.addArrangedSubview(iconImageView)
            stackView.addArrangedSubview(bottomLabel)
        }
    }
    
    func setAutoLayout(infoType: InfoType) {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        if infoType == .developer {
            NSLayoutConstraint.activate([
                iconImageView.widthAnchor.constraint(equalToConstant: 30.0),
                iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
            ])
        }
    }
    
    func setLine(infoType: InfoType) {
        topLine.frame = CGRectMake(0.0, -10.0, self.frame.width, 0.5)
        
        if infoType != .language {
            rightLine.frame = CGRectMake(self.frame.width, self.frame.height/4 , 0.5, self.frame.height/2)
        }
    }
    
    func bindUI(infoType: InfoType, appInfo: AppInfo) {
        switch infoType {
        case .score:
            topLabel.text = conversionScore(appInfo.reviewCount) + "개의 평가"
            middleLabel.text = String(round(appInfo.starRating * 10)/10)
            starRating.rating = appInfo.starRating
        case .limitAge:
            topLabel.text = "연령"
            middleLabel.text = appInfo.ageLimit
            bottomLabel.text = "세"
        case .chart:
            topLabel.text = "차트"
            middleLabel.text = "#1" // 데이터가 없어서 하드코딩
            bottomLabel.text = appInfo.categories[0]
        case .developer:
            topLabel.text = "개발자"
            iconImageView.image = UIImage(systemName: "person.crop.square")?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = .systemGray
            bottomLabel.text = appInfo.developer
        case .language:
            topLabel.text = "언어"
            let langCode = getLanguageCode(languages: appInfo.languages)
            middleLabel.text = langCode
            bottomLabel.text = appInfo.languages.count > 2 ? "+ \(appInfo.languages.count-1)개 언어" : Locale.current.localizedString(forLanguageCode: langCode)
        }
    }
    
}
