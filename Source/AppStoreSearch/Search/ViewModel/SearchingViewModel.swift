//
//  SearchingViewModel.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/17.
//

import Foundation
import Alamofire

class SearchingViewModel {
    private(set) var appLists = [AppInfo]() {
        didSet {
            self.bindSearchingTableView()
        }
    }
    var bindSearchingTableView: ( () -> () ) = {}
    
    // request 후에 결과 값을 Return 하는 함수
    func getSearchingAppList(text: String, limit: Int?) {
        clearAppLists()
        guard let searchKeyword = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        var apiURL = "https://itunes.apple.com/search?term=\(searchKeyword)&country=Kr&entity=software&lang=ko"
        if let limit = limit { apiURL += "&limit=\(limit)" }
        AF.session.getAllTasks(completionHandler: { taskArr in
            taskArr.forEach({ $0.cancel()})
            
            AF.request(apiURL).responseDecodable(of: APIResult.self, completionHandler: { response in
                switch response.result {
                case .success(let result):
                    self.appLists = result.appLists
                case .failure(let err):
                    debugPrint(err)
                }
            })
        })
    }
    
    func clearAppLists() {
        appLists.removeAll()
    }
}
