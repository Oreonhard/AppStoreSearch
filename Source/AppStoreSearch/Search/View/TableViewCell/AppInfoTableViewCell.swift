//
//  AppInfoTableViewCell.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/18.
//

import UIKit

enum InfoType: Int {
    case score = 0
    case limitAge
    case chart
    case developer
    case language
}

class AppInfoTableViewCell: UITableViewCell {
    
    // MARK: - Global Variable
    
    static let reuseIdentifier = "AppInfoTableViewCell"
    
    var appInfo: AppInfo!
    
    // MARK: - UI Component
    
    private lazy var appInfos: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 0.0
        flowlayout.itemSize = CGSize(width: 110.0, height: 80.0)
        flowlayout.sectionInset = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        
        let appInfos = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        appInfos.showsHorizontalScrollIndicator = false
        appInfos.dataSource = self
        appInfos.register(AppInfoCollectionViewCell.self, forCellWithReuseIdentifier: AppInfoCollectionViewCell.reuseIdentifier)
        appInfos.translatesAutoresizingMaskIntoConstraints = false
        
        return appInfos
    }()
    
    // MARK: - Override Function
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AppInfoTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppInfoCollectionViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? AppInfoCollectionViewCell, let type = InfoType(rawValue: indexPath.row) {
            cell.addContentView(infoType: type)
            cell.setAutoLayout(infoType: type)
            cell.bindUI(infoType: type, appInfo: appInfo)
            cell.setLine(infoType: type)
        }
        
        return cell
    }
}

extension AppInfoTableViewCell {
    
    private func addContentView() {
        contentView.addSubview(appInfos)
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            appInfos.topAnchor.constraint(equalTo: contentView.topAnchor),
            appInfos.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            appInfos.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            appInfos.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            appInfos.heightAnchor.constraint(equalToConstant: 100.0)
        ])
    }
    
    func bindUI(appInfo: AppInfo) {
        self.appInfo = appInfo
    }
}
