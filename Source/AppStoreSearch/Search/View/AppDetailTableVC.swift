//
//  AppDetailTableVC.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/18.
//

import UIKit

protocol AppDetailDelegate: AnyObject {
    func selectedPreviewImage(index: Int, previewImages: [String])
    func layoutChangeNeeded()
}

class AppDetailTableVC: UITableViewController {
    enum RowModule: Int {
        case appTitle = 0
        case appInfo
        case appPreview
        case appDescription
        case appDeveloper
        case appReleaseNote
    }
    
    // MARK: - Global Variable
    
    var appInfo: AppInfo!
    
    // MARK: - UI Component
    
    lazy var installButton: UIButton = {
        let installButton = UIButton()
        installButton.alpha = 0.0
        installButton.backgroundColor = .systemBlue
        installButton.layer.cornerRadius = 15.0
        installButton.setTitle("받기", for: .normal)
        installButton.setTitleColor(.white, for: .normal)
        installButton.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        
        installButton.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([
            installButton.widthAnchor.constraint(equalToConstant: 75.0),
            installButton.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        
        return installButton
    }()
    
    lazy var appIcon: UIImageView = {
        let appIcon = UIImageView()
        appIcon.alpha = 0.0
        appIcon.layer.cornerRadius = 5.0
        appIcon.layer.masksToBounds = true
        appIcon.layer.borderWidth = 1.0
        appIcon.layer.borderColor = CGColor(gray: 0.8, alpha: 0.5)
        
        appIcon.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([
            appIcon.widthAnchor.constraint(equalToConstant: 30.0),
            appIcon.heightAnchor.constraint(equalTo: appIcon.widthAnchor)
        ])
        
        return appIcon
    }()
    
    // MARK: - Override Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityIdentifier = "appDetailView"
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
        self.tableView.register(AppTitleTableViewCell.self, forCellReuseIdentifier: AppTitleTableViewCell.reuseIdentifier)
        self.tableView.register(AppInfoTableViewCell.self, forCellReuseIdentifier: AppInfoTableViewCell.reuseIdentifier)
        self.tableView.register(AppPreviewTableViewCell.self, forCellReuseIdentifier: AppPreviewTableViewCell.reuseIdentifier)
        self.tableView.register(AppDescriptionTableViewCell.self, forCellReuseIdentifier: AppDescriptionTableViewCell.reuseIdentifier)
        self.tableView.register(ReleaseNoteTableViewCell.self, forCellReuseIdentifier: ReleaseNoteTableViewCell.reuseIdentifier)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: installButton)
        self.navigationItem.titleView = appIcon
        if let imageURL = URL(string: appInfo.appIcon) {
            appIcon.kf.setImage(with: imageURL)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /**
         indexPath.row 별 영역
         - 0: 앱 아이콘, 앱 이름, 받기 버튼 영역
         - 1: 리뷰 점수, 연령 등 앱 부가 정보 영역
         - 2: 미리보기 영역
         - 3: 앱 설명 영역
         - 4: 개발자 이름 영역
         - 5: 새로운 기능 영역
         **/
        let row = indexPath.row
        if RowModule(rawValue: row) == .appTitle
            , let appTitle = tableView.dequeueReusableCell(withIdentifier: AppTitleTableViewCell.reuseIdentifier) as? AppTitleTableViewCell {
            appTitle.bindUI(appInfo: appInfo)
            
            return appTitle
        } else if RowModule(rawValue: row) == .appInfo
                    , let appInfos = tableView.dequeueReusableCell(withIdentifier: AppInfoTableViewCell.reuseIdentifier) as? AppInfoTableViewCell {
            appInfos.bindUI(appInfo: appInfo)

            return appInfos
        } else if RowModule(rawValue: row) == .appPreview
                    , let appPreviews = tableView.dequeueReusableCell(withIdentifier: AppPreviewTableViewCell.reuseIdentifier) as? AppPreviewTableViewCell {
            appPreviews.delegate = self
            appPreviews.bindUI(appInfo: appInfo)
            
            return appPreviews
        } else if RowModule(rawValue: row) == .appDescription
                    , let appDescription = tableView.dequeueReusableCell(withIdentifier: AppDescriptionTableViewCell.reuseIdentifier) as? AppDescriptionTableViewCell{
            appDescription.delegate = self
            appDescription.bindUI(appInfo: appInfo)
            
            return appDescription
        } else if RowModule(rawValue: row) == .appDeveloper {
            let developerCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            developerCell.selectionStyle = .none
            developerCell.accessoryType = .disclosureIndicator
            developerCell.textLabel?.text = appInfo.developer
            developerCell.textLabel?.font = .systemFont(ofSize: 14.0, weight: .light)
            developerCell.textLabel?.textColor = .systemBlue
            developerCell.detailTextLabel?.text = "개발자"
            developerCell.detailTextLabel?.font = .systemFont(ofSize: 12.0, weight: .light)
            developerCell.detailTextLabel?.textColor = .systemGray
            
            return developerCell
        } else if RowModule(rawValue: row) == .appReleaseNote
                    , let _ = appInfo.releaseNotes, let newRelease = tableView.dequeueReusableCell(withIdentifier: ReleaseNoteTableViewCell.reuseIdentifier) as? ReleaseNoteTableViewCell {
            newRelease.delegate = self
            newRelease.bindUI(appInfo: appInfo)
            
            return newRelease
        } else {
            return UITableViewCell()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeDisplayNavigationItem(offsetY: scrollView.contentOffset.y)
    }
}

// MARK: - AppDetailDelegate

extension AppDetailTableVC: AppDetailDelegate {
    
    func selectedPreviewImage(index: Int, previewImages: [String]) {
        let appFullPreview = AppFullPreviewVC()
        appFullPreview.seletedIndex = index
        appFullPreview.previewImages = previewImages
        appFullPreview.modalPresentationStyle = .fullScreen
        
        self.present(appFullPreview, animated: true)
    }
    
    func layoutChangeNeeded() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}

// MARK: - Custon Function

extension AppDetailTableVC {
    
    func changeDisplayNavigationItem(offsetY: CGFloat) {
        guard let appTitleCell = self.tableView.cellForRow(at: .init(row: RowModule.appTitle.rawValue, section: 0)) as? AppTitleTableViewCell else { return }
        
        if offsetY < -16.0 {
            self.installButton.isUserInteractionEnabled = false
            appTitleCell.hiddenTitleItem(hidden: false)
            UIView.animate(withDuration: 0.3, animations: { self.appIcon.alpha = 0.0 })
            UIView.animate(withDuration: 0.3, animations: { self.installButton.alpha = 0.0 })
        } else {
            self.installButton.isUserInteractionEnabled = true
            appTitleCell.hiddenTitleItem(hidden: true)
            UIView.animate(withDuration: 0.3, animations: { self.appIcon.alpha = 1.0 })
            UIView.animate(withDuration: 0.3, animations: { self.installButton.alpha = 1.0 }, completion: {_ in self.installButton.isUserInteractionEnabled = true })
        }
        
        /**
         navigationbar.titleview 가 scrollView.contentOffset.y 값이
         특정 구간에서 alpha 값이 1로 고정되는 이슈 대응 (시뮬레이터 확인)
         **/
        if offsetY <= -20.0 {
            self.appIcon.isHidden = true
        } else {
            self.appIcon.isHidden = false
        }
    }
    
}
