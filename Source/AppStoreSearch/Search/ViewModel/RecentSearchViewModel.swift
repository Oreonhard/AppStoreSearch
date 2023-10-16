//
//  RecentSearchViewModel.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/20.
//

import Foundation
import UIKit
import CoreData

class RecentSearchViewModel {
    private(set) var recentSearchKeywords = [RecentSearchKeyword]() {
        didSet {
            self.bindRecentSearchTableView()
        }
    }
    var bindRecentSearchTableView: ( () -> () ) = {}
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }()
    
    func saveRecentSearchKeyword(keyword: String) {
        removeDuplicateKeyword(newKeyword: keyword)
        
        let entity = NSEntityDescription.entity(forEntityName: "RecentSearchKeyword", in: context)
        
        guard let entity = entity  else { return }
        let recentSearchKeyword = NSManagedObject(entity: entity, insertInto: context)
        recentSearchKeyword.setValue(keyword, forKey: "keyword")
        
        do {
            try context.save()
        } catch {
            print("Core Data Saving Error")
            debugPrint(error)
        }
        
        getRecentSearchKeyword()
    }
    
    func getRecentSearchKeyword() {
        do {
            let request = RecentSearchKeyword.fetchRequest()
            let result = try context.fetch(request)
            recentSearchKeywords = result.reversed()
        } catch {
            print("Core Data Get Error")
            debugPrint(error)
        }
    }
    
    private func removeDuplicateKeyword(newKeyword: String) {
        var result = [RecentSearchKeyword]()
        do {
            result = try context.fetch(RecentSearchKeyword.fetchRequest()) as! [RecentSearchKeyword]
        } catch {
            print("Core Data Get Error")
            debugPrint(error)
        }
        
        guard !result.isEmpty else { return }
        
        result.filter({ $0.keyword == newKeyword}).forEach({ context.delete($0) })
        if result.filter({ $0.keyword != newKeyword}).count > 4 {
            for i in 0 ..< result.filter({ $0.keyword != newKeyword}).count - 4 {
                context.delete(result[i])
            }
        }
    }
}
