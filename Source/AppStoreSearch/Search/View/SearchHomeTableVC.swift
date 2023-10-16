//
//  SearchingViewController.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/16.
//

import UIKit

class SearchHomeTableVC: UITableViewController {
    
    // MARK: - Global Variable
    
    let viewModel = RecentSearchViewModel()
    
    // MARK: - UI Component
    
    lazy var profileButton: UIButton = {
        let profileButton = UIButton()
        profileButton.setImage(.init(systemName: "person.circle"), for: .normal)
        profileButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        profileButton.layer.borderColor = UIColor.clear.cgColor
        profileButton.layer.borderWidth =  0.8
        profileButton.layer.cornerRadius = 17.5
        
        return profileButton
    }()
    
    lazy var sectionLabel: UILabel = {
        let sectionLabel = UILabel()
        sectionLabel.textColor = .black
        sectionLabel.font = .systemFont(ofSize: 21.0, weight: .heavy)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 15.0
        sectionLabel.attributedText = NSAttributedString(string: "최근 검색어", attributes: [.paragraphStyle:paragraphStyle])
        
        return sectionLabel
    }()
    
    // MARK: - Override function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.accessibilityIdentifier = "recentSearchList"
        
        self.view.backgroundColor = .white
        self.tableView.separatorStyle = .none
        self.tableView.register(RecentTableViewCell.self, forCellReuseIdentifier: RecentTableViewCell.reuseIdentifier)
        
        setNavigationBar()
        setSearchController()
        
        viewModel.bindRecentSearchTableView = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.getRecentSearchKeyword()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionLabel
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentSearchKeywords.count
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RecentTableViewCell.reuseIdentifier) as? RecentTableViewCell {
            cell.frame = .init(x: 15.0, y: 0.0, width: tableView.frame.width - 30.0, height: cell.frame.height)
            cell.bindUI(viewModel.recentSearchKeywords[indexPath.row].keyword!)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationItem.searchController?.searchBar.text = viewModel.recentSearchKeywords[indexPath.row].keyword!
        self.navigationItem.searchController?.searchBar.becomeFirstResponder()
        self.navigationItem.searchController?.searchBar.endEditing(true)
    }
}

// MARK: - Custom function

extension SearchHomeTableVC {
    func setNavigationBar() {
        self.navigationController?.navigationBar.accessibilityIdentifier = "searchNavigationBar"
        
        // 상단 검색 Title 셋팅
        self.navigationItem.title = "검색"
        
        // 우측 상단 프로필 버튼 셋팅
        guard let classType = NSClassFromString("_UINavigationBarLargeTitleView") else { return }
        for subView in self.navigationController!.navigationBar.subviews {
            if subView.isKind(of: classType) {
                subView.addSubview(profileButton)
                
                guard let largeTitleLabel = subView.subviews.first as? UILabel else { return }
                profileButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    profileButton.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25.0),
                    profileButton.centerYAnchor.constraint(equalTo: largeTitleLabel.centerYAnchor, constant: -5.0),
                    profileButton.widthAnchor.constraint(equalToConstant: 35.0),
                    profileButton.heightAnchor.constraint(equalTo: profileButton.widthAnchor),
                    profileButton.imageView!.widthAnchor.constraint(equalTo: profileButton.widthAnchor),
                    profileButton.imageView!.heightAnchor.constraint(equalTo: profileButton.widthAnchor)
                ])
            }
        }
    }
    
    func setSearchController() {
        let searchResultView = SearchResultTableVC()
        let searchView = UISearchController(searchResultsController: searchResultView)
        searchResultView.recentSearchViewModel = viewModel
        searchResultView.searchingVC = searchView
        searchView.searchBar.delegate = searchResultView
        searchView.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchView.searchBar.setValue("취소", forKey: "cancelButtonText")
        self.navigationItem.searchController = searchView
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}
