//
//  BaseModels.swift
//  Eiger
//
//  Created by tenma on 2017/02/07.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import Bond
import WebKit

protocol BaseViewModelDelegate {
    func baseViewModelDidChangeWebView(index: Int)
}

class BaseViewModel {
    
    // リクエストURL(jsのURL)
    var requestUrl: String {
        get {
            return (!eachHistory[locationIndex].url.isEmpty) ? eachHistory[locationIndex].url : defaultUrl
        }
    }
    
    var delegate: BaseViewModelDelegate?
    
    // クッキーの共有
    var processPool = WKProcessPool()
    
    // 最新のリクエストURL(wv.url)。エラーが発生した時用
    var latestRequestUrl: String = ""
    
    // webviewの数
    var webViewCount: Int {
        get {
            return eachHistory.count
        }
    }

    // 現在表示しているwebviewのインデックス
    var locationIndex: Int  = UserDefaults.standard.integer(forKey: AppDataManager.shared.locationIndexKey) {
        didSet {
            log.debug("location index changed. \(oldValue) -> \(locationIndex)")
        }
    }
    
    // 全てのwebViewの履歴
    private var commonHistory: [CommonHistoryItem] = []
    
    // webViewそれぞれの履歴とカレントページインデックス
    private var eachHistory: [EachHistoryItem] = []
    
    // 通知センター
    let center = NotificationCenter.default
    
    var defaultUrl: String {
        get {
            return UserDefaults.standard.string(forKey: AppDataManager.shared.defaultUrlKey)!
        }
        set(url) {
            UserDefaults.standard.set(url, forKey: AppDataManager.shared.defaultUrlKey)
        }
    }
    
    var currentContext: String? {
        get {
            return eachHistory.count > locationIndex ? eachHistory[locationIndex].context : nil
        }
    }
    
    init() {
        center.addObserver(self,
                           selector: #selector(type(of: self).baseViewAddWebView(notification:)),
                           name: .baseViewAddWebView,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(type(of: self).baseViewChangeWebView(notification:)),
                           name: .baseViewChangeWebView,
                           object: nil)
        
        // eachHistory読み込み
        do {
            let data = try Data(contentsOf: AppDataManager.shared.eachHistoryPath)
            eachHistory = NSKeyedUnarchiver.unarchiveObject(with: data) as! [EachHistoryItem]
            log.debug("each history read. url: \n\(requestUrl)")
        } catch let error as NSError {
            eachHistory.append(EachHistoryItem())
            log.error("failed to read each history: \(error)")
        }
        center.post(name: .footerViewLoad, object: eachHistory)
    }
    
// MARK: Public Method
    
    func notifyAddWebView() {
        eachHistory.append(EachHistoryItem())
        locationIndex = eachHistory.count - 1
        center.post(name: .footerViewAddWebView, object: ["context": currentContext])
    }
    
    func notifyStartLoadingWebView(object: [String: Any]?) {
        center.post(name: .footerViewStartLoading, object: object)
    }
    
    func notifyEndLoadingWebView(object: [String: Any]?) {
        center.post(name: .footerViewEndLoading, object: object)
    }
    
    func saveHistory(wv: EGWebView) {
        if let requestUrl = wv.requestUrl, let requestTitle = wv.requestTitle {
            // Common History
            let common = CommonHistoryItem(url: requestUrl, title: requestTitle, date: Date())
            commonHistory.append(common)
            log.debug("save history. url: \(common.url)")
            
            // Each History
            for history in eachHistory {
                if history.context == wv.context {
                    history.url = common.url
                    history.title = common.title
                    break
                }
            }
        }
    }
    
    func storeHistory() {
        UserDefaults.standard.set(locationIndex, forKey: AppDataManager.shared.locationIndexKey)
        storeCommonHistory()
        storeEachHistory()
        commonHistory = []
    }
    
// MARK: Notification受信
    
    @objc private func baseViewAddWebView(notification: Notification) {
        log.debug("[BaseView Event]: baseViewAddWebView")
        notifyAddWebView()
    }
    
    
    @objc private func baseViewChangeWebView(notification: Notification) {
        log.debug("[BaseView Event]: baseViewChangeWebView")
        let index = notification.object as! Int
        delegate?.baseViewModelDidChangeWebView(index: index)
    }
    
// MARK: Private Method
    
    private func storeCommonHistory() {
        if commonHistory.count > 0 {
            // commonHistoryを日付毎に分ける
            var commonHistoryByDate: [String: [CommonHistoryItem]] = [:]
            for item in commonHistory {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
                dateFormatter.dateFormat = "yyyyMMdd"
                let key = dateFormatter.string(from: item.date)
                if commonHistoryByDate[key] == nil {
                    commonHistoryByDate[key] = [item]
                } else {
                    commonHistoryByDate[key]?.append(item)
                }
            }
            
            for (key, value) in commonHistoryByDate {
                let commonHistoryPath = AppDataManager.shared.commonHistoryPath(date: key)
                
                let saveData: [CommonHistoryItem] = { () -> [CommonHistoryItem] in
                    do {
                        let data = try Data(contentsOf: commonHistoryPath)
                        let old = NSKeyedUnarchiver.unarchiveObject(with: data) as! [CommonHistoryItem]
                        let saveData: [CommonHistoryItem] = old + value
                        return saveData
                    } catch let error as NSError {
                        log.error("failed to read: \(error)")
                        return value
                    }
                }()
                
                let commonHistoryData = NSKeyedArchiver.archivedData(withRootObject: saveData)
                do {
                    try commonHistoryData.write(to: commonHistoryPath)
                    log.debug("store common history")
                } catch let error as NSError {
                    log.error("failed to write: \(error)")
                }
            }
        }
    }
    
    private func storeEachHistory() {
        if commonHistory.count > 0 {
            let eachHistoryData = NSKeyedArchiver.archivedData(withRootObject: eachHistory)
            do {
                try eachHistoryData.write(to: AppDataManager.shared.eachHistoryPath)
                log.debug("store each history")
            } catch let error as NSError {
                log.error("failed to write: \(error)")
            }
        }
    }
}
