//
//  SearchingResultTableVC.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/17.
//

import UIKit

class SearchResultTableVC: UITableViewController {
    enum mode {
        case searchView
        case listView
    }
    
    // MARK: - Global Variable
    
    var viewMode: mode = .searchView
    
    weak var searchingVC: UISearchController?
    weak var recentSearchViewModel: RecentSearchViewModel?
    let viewModel = SearchingViewModel()
    var searchResultCount: Int = 0
    
    // MARK: - Override function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 높이 값 구하기
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow) , name: UIResponder.keyboardDidShowNotification, object: nil)
        
        self.tableView.separatorStyle = .none
        self.tableView.register(AppListTableViewCell.self, forCellReuseIdentifier: AppListTableViewCell.reuseIdentifier)
        self.tableView.accessibilityIdentifier = "searchList"
        
        viewModel.bindSearchingTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.appLists.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewMode == .searchView {
            return 42.0
        } else {
            return 390.0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appInfo = viewModel.appLists[indexPath.row]
        
        if viewMode == .searchView {
            let cell = AutoKeywordTableViewCell(style: .default, reuseIdentifier: AutoKeywordTableViewCell.reuseIdentifier)
            cell.frame = .init(x: 15.0, y: 0.0, width: tableView.frame.width - 15.0, height: cell.frame.height)
            
            let label = appInfo.appTitle
            cell.bindUI(label)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppListTableViewCell.reuseIdentifier) as? AppListTableViewCell else {
                return UITableViewCell()
            }
            cell.bindUI(appInfo: appInfo)
            
            return cell
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewMode == .searchView {
            searchingVC?.searchBar.text = viewModel.appLists[indexPath.row].appTitle
            searchingVC?.searchBar.endEditing(true)
        } else {
            let detailVC = AppDetailTableVC()
            detailVC.appInfo = viewModel.appLists[indexPath.row]
            self.presentingViewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchResultTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewMode = .searchView
        viewModel.getSearchingAppList(text: searchText, limit: searchResultCount)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText != "" {
            viewMode = .listView
            recentSearchViewModel?.saveRecentSearchKeyword(keyword: searchText)
            viewModel.getSearchingAppList(text: searchText, limit: nil)
        } else {
            viewMode = .searchView
            tableView.reloadData()
        }
    }
}

// MARK: - Custom function

extension SearchResultTableVC {
    @objc func keyboardDidShow(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        
        // 키보드가 가리는 영역에는 검색결과가 나오지 않게끔 처리
        searchResultCount = Int(floor((self.tableView.frame.height - keyboardHeight) / 42.0)) - 2
    }
}
