//
//  AppTitleTableViewCell.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/18.
//

import UIKit

class AppTitleTableViewCell: UITableViewCell {
    
    // MARK: - Global Variable
    
    static let reuseIdentifier = "AppTitleTableViewCell"
    
    // MARK: - UI Component
    
    private lazy var appIcon: UIImageView = {
        let appIcon = UIImageView()
        appIcon.layer.cornerRadius = 18.0
        appIcon.layer.masksToBounds = true
        appIcon.layer.borderWidth = 1.0
        appIcon.layer.borderColor = CGColor(gray: 0.8, alpha: 0.5)
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        
        return appIcon
    }()
    
    private lazy var appTitle: UILabel = {
        let appTitle = UILabel()
        appTitle.font = .systemFont(ofSize: 20.0, weight: .semibold)
        appTitle.translatesAutoresizingMaskIntoConstraints = false
        
        return appTitle
    }()
    
    private lazy var installButton: UIButton = {
        let installButton = UIButton()
        installButton.backgroundColor = .systemBlue
        installButton.layer.cornerRadius = 15.0
        installButton.setTitleColor(.white, for: .normal)
        installButton.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        
        installButton.translatesAutoresizingMaskIntoConstraints = false
        
        return installButton
    }()
    
    private lazy var shareButton: UIButton = {
        let installButton = UIButton()
        installButton.translatesAutoresizingMaskIntoConstraints = false
        
        return installButton
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
}

// MARK: - Custom Function

extension AppTitleTableViewCell {
    
    private func addContentView() {
        contentView.addSubview(appIcon)
        contentView.addSubview(appTitle)
        contentView.addSubview(installButton)
        contentView.addSubview(shareButton)
    }
    
    private func setAutolayout() {
        NSLayoutConstraint.activate([
            appIcon.topAnchor.constraint(equalTo: contentView.topAnchor),
            appIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0),
            appIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0),
            appIcon.heightAnchor.constraint(equalToConstant: 100.0),
            appIcon.widthAnchor.constraint(equalTo: appIcon.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            appTitle.topAnchor.constraint(equalTo: appIcon.topAnchor),
            appTitle.leftAnchor.constraint(equalTo: appIcon.rightAnchor, constant: 13.0),
            appTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0)
        ])
        
        NSLayoutConstraint.activate([
            installButton.bottomAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: -5.0),
            installButton.leftAnchor.constraint(equalTo: appIcon.rightAnchor, constant: 13.0),
            installButton.widthAnchor.constraint(equalToConstant: 75.0),
            installButton.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.bottomAnchor.constraint(equalTo: installButton.bottomAnchor),
            shareButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.0),
            shareButton.widthAnchor.constraint(equalToConstant: 30.0),
            shareButton.heightAnchor.constraint(equalTo: shareButton.widthAnchor)
        ])
    }
    
    func bindUI(appInfo: AppInfo) {
        installButton.setTitle("받기", for: .normal)
        shareButton.setImage(.init(systemName: "square.and.arrow.up"), for: .normal)
        appTitle.text = appInfo.appTitle
        
        if let imageURL = URL(string: appInfo.appIcon) {
            appIcon.kf.setImage(with: imageURL)
        }
    }
    
    func hiddenTitleItem(hidden: Bool) {
        if hidden {
            self.installButton.isUserInteractionEnabled = false
            self.shareButton.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: { self.appIcon.alpha = 0.0 })
            UIView.animate(withDuration: 0.3, animations: { self.installButton.alpha = 0.0 })
            UIView.animate(withDuration: 0.3, animations: { self.shareButton.alpha = 0.0 })
        } else {
            self.installButton.isUserInteractionEnabled = true
            self.shareButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3, animations: { self.appIcon.alpha = 1.0 })
            UIView.animate(withDuration: 0.3, animations: { self.installButton.alpha = 1.0 })
            UIView.animate(withDuration: 0.3, animations: { self.shareButton.alpha = 1.0 })
        }
    }
}
