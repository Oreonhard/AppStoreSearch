//
//  Utils.swift
//  SearchingAppStore
//
//  Created by 최준찬 on 2023/09/19.
//

import Foundation

func conversionScore(_ before: Double) -> String {
    let result: String
    
    if before >= 10000 {
        let score = round(before / 1000)/10
        if floor(score) == score {
            result = String(Int(score)) + "만"
        } else {
            result = String(score) + "만"
        }
    } else if before >= 1000 {
        let score = round(before / 100)/10
        if floor(score) == score {
            result = String(Int(score)) + "천"
        } else {
            result = String(score) + "천"
        }
    } else {
        result = String(Int(before))
    }
    
    return result
}

func getLanguageCode(languages: [String]) -> String {
    if let currentLang = Locale.current.languageCode {
        if languages.contains(currentLang.uppercased()) { return currentLang.uppercased() }
        else if languages.contains("EN") { return "EN" }
        else { return languages[0] }
    } else {
        if languages.contains("EN") { return "EN" }
        else { return languages[0] }
    }
}

func getTimeAgoAtNow(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko-KR")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    if let fromDate = dateFormatter.date(from: date) {
        // 오늘 날짜
        let toDate = Date()
        
        // 연도
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            return "\(interval)년 전"
        }
        
        // 월
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            return "\(interval)달 전"
        }
        
        // 일
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            return interval >= 7 ? "\(interval/7)주 전" : "\(interval)일 전"
        }
        
        // 시간
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return "\(interval)시간 전"
        }
        
        // 분
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            return "\(interval)분 전"
        }
        
        return "조금 전"
    }
    return "오래 전"
}
