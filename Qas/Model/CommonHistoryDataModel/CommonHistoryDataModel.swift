//
//  CommonHistoryModel.swift
//  Qas
//
//  Created by temma on 2017/10/29.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import UIKit

final class CommonHistoryDataModel {
    static let s = CommonHistoryDataModel()
    
    /// 閲覧履歴
    var histories = [CommonHistory]()

    /// 閲覧履歴の永続化
    func store() {
        if histories.count > 0 {
            // commonHistoryを日付毎に分ける
            var commonHistoryByDate: [String: [CommonHistory]] = [:]
            for item in histories {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
                dateFormatter.dateFormat = AppConst.DATE_FORMAT
                let key = dateFormatter.string(from: item.date)
                if commonHistoryByDate[key] == nil {
                    commonHistoryByDate[key] = [item]
                } else {
                    commonHistoryByDate[key]?.append(item)
                }
            }
            
            // 日付毎に分けた閲覧履歴を日付毎に保存していく
            for (key, value) in commonHistoryByDate {
                let commonHistoryUrl = Util.commonHistoryUrl(date: key)
                
                let saveData: [CommonHistory] = { () -> [CommonHistory] in
                    do {
                        let data = try Data(contentsOf: commonHistoryUrl)
                        let old = NSKeyedUnarchiver.unarchiveObject(with: data) as! [CommonHistory]
                        let saveData: [CommonHistory] = value + old
                        return saveData
                    } catch let error as NSError {
                        log.error("failed to read common history: \(error)")
                        return value
                    }
                }()
                
                let commonHistoryData = NSKeyedArchiver.archivedData(withRootObject: saveData)
                do {
                    try commonHistoryData.write(to: commonHistoryUrl)
                    log.debug("store common history")
                } catch let error as NSError {
                    log.error("failed to write common history: \(error)")
                }
            }
            histories = []
        }
    }

    /// 閲覧履歴の検索
    /// 検索ワードと検索件数を指定する
    func select(title: String, readNum: Int) -> [CommonHistory] {
        let manager = FileManager.default
        var readFiles: [String] = []
        var result: [CommonHistory] = []
        do {
            let list = try manager.contentsOfDirectory(atPath: AppConst.PATH_COMMON_HISTORY)
            readFiles = list.map({ (path: String) -> String in
                return path.substring(to: path.index(path.startIndex, offsetBy: 8))
            }).reversed()
            
            if readFiles.count > 0 {
                let latestFiles = readFiles.prefix(readNum)
                var allCommonHistory: [CommonHistory] = []
                latestFiles.forEach({ (keyStr: String) in
                    do {
                        let data = try Data(contentsOf: Util.commonHistoryUrl(date: keyStr))
                        let commonHistory = NSKeyedUnarchiver.unarchiveObject(with: data) as! [CommonHistory]
                        allCommonHistory = allCommonHistory + commonHistory
                    } catch let error as NSError {
                        log.error("failed to read common history. error: \(error.localizedDescription)")
                    }
                })
                let hitCommonHistory = allCommonHistory.filter({ (commonHistoryItem) -> Bool in
                    return commonHistoryItem.title.lowercased().contains(title)
                })
                
                // 重複の削除
                hitCommonHistory.forEach({ (item) in
                    if result.count == 0 {
                        result.append(item)
                    } else {
                        let resultTitles: [String] = result.map({ (item) -> String in
                            return item.title
                        })
                        if !resultTitles.contains(item.title) {
                            result.append(item)
                        }
                    }
                })
            }
            
        } catch let error as NSError {
            log.error("failed to read common history. error: \(error.localizedDescription)")
        }
        return result
    }
    
    /// 閲覧履歴の期限切れチェック
    func expireCheck() {
        let manager = FileManager.default
        var readFiles: [String] = []
        let saveTerm = Int(UserDefaults.standard.integer(forKey: AppConst.KEY_HISTORY_SAVE_TERM))
        do {
            let list = try manager.contentsOfDirectory(atPath: AppConst.PATH_COMMON_HISTORY)
            readFiles = list.map({ (path: String) -> String in
                return path.substring(to: path.index(path.startIndex, offsetBy: 8))
            }).reversed()
            
            if readFiles.count > saveTerm {
                let deleteFiles = readFiles.suffix(from: saveTerm)
                deleteFiles.forEach({ (key) in
                    try! FileManager.default.removeItem(atPath: Util.commonHistoryPath(date: key))
                })
                log.debug("deleteCommonHistory: \(deleteFiles)")
            }
            
        } catch let error as NSError {
            log.error("failed to delete common history. error: \(error.localizedDescription)")
        }
    }
    
    /// 特定の閲覧履歴を削除する
    /// [日付: [id, id, ...]]
    func delete(historyIds: [String: [String]]) {
        // 履歴
        for (key, value) in historyIds {
            let commonHistoryUrl = Util.commonHistoryUrl(date: key)
            let saveData: [CommonHistory]? = { () -> [CommonHistory]? in
                do {
                    let data = try Data(contentsOf: commonHistoryUrl)
                    let old = NSKeyedUnarchiver.unarchiveObject(with: data) as! [CommonHistory]
                    let saveData = old.filter({ (historyItem) -> Bool in
                        return !value.contains(historyItem._id)
                    })
                    return saveData
                } catch let error as NSError {
                    log.error("failed to read: \(error)")
                    return nil
                }
            }()
            
            if let saveData = saveData {
                if saveData.count > 0 {
                    let commonHistoryData = NSKeyedArchiver.archivedData(withRootObject: saveData)
                    do {
                        try commonHistoryData.write(to: commonHistoryUrl)
                        log.debug("store common history")
                    } catch let error as NSError {
                        log.error("failed to write: \(error)")
                    }
                } else {
                    try! FileManager.default.removeItem(atPath: Util.commonHistoryPath(date: key))
                    log.debug("remove common history file. date: \(key)")
                }
            }
        }
    }
    
    /// 閲覧履歴を全て削除
    func delete() {
        Util.deleteFolder(path: AppConst.PATH_COMMON_HISTORY)
        Util.createFolder(path: AppConst.PATH_COMMON_HISTORY)
    }

}