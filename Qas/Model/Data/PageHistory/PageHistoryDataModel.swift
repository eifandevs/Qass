//
//  PageHistoryModel.swift
//  Qas
//
//  Created by temma on 2017/10/29.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PageHistoryDataModel {
    /// ページインサート通知用RX
    let rx_pageHistoryDataModelDidInsert = PublishSubject<(pageHistory: PageHistory, at: Int)>()
    /// ページ追加通知用RX
    let rx_pageHistoryDataModelDidAppend = PublishSubject<PageHistory>()
    /// ページ変更通知用RX
    let rx_pageHistoryDataModelDidChange = PublishSubject<String>()
    /// ページ削除通知用RX
    let rx_pageHistoryDataModelDidRemove = PublishSubject<(deleteContext: String, currentContext: String?, deleteIndex: Int)>()
    /// ページリロード通知用RX
    let rx_pageHistoryDataModelDidReload = PublishSubject<()>()
    /// ページロード開始通知用RX
    let rx_pageHistoryDataModelDidStartLoading = PublishSubject<String>()
    /// ページロード終了通知用RX
    let rx_pageHistoryDataModelDidEndLoading = PublishSubject<String>()
    /// ページレンダリング終了通知用RX
    let rx_pageHistoryDataModelDidEndRendering = PublishSubject<String>()
    
    static let s = PageHistoryDataModel()

    /// 通知センター
    private let center = NotificationCenter.default
    
    /// 現在表示しているwebviewのコンテキスト
    var currentContext: String = UserDefaults.standard.string(forKey: AppConst.KEY_CURRENT_CONTEXT)! {
        didSet {
            log.debug("current context changed. \(oldValue) -> \(currentContext)")
            previousContext = oldValue
            UserDefaults.standard.set(currentContext, forKey: AppConst.KEY_CURRENT_CONTEXT)
        }
    }
    var previousContext: String?

    /// webViewそれぞれの履歴とカレントページインデックス
    public private(set) var histories = [PageHistory]()
    
    /// 現在のページ情報
    var currentHistory: PageHistory? {
        return D.find(histories, callback: { $0.context == currentContext })
    }
    
    /// 現在の位置
    var currentLocation: Int {
        return D.findIndex(histories, callback: { $0.context == currentContext })!
    }
    
    /// 最新ページを見ているかフラグ
    private var isViewingLatest: Bool {
        return currentLocation == histories.count - 1
    }
    
    /// ページヒストリー保存件数
    private let pageHistorySaveCount = UserDefaults.standard.integer(forKey: AppConst.KEY_PAGE_HISTORY_SAVE_COUNT)
    
    private init() {
    }
    
    /// 初期化
    func initialize() {
        // pageHistory読み込み
        do {
            let data = try Data(contentsOf: AppConst.PATH_URL_PAGE_HISTORY)
            histories = NSKeyedUnarchiver.unarchiveObject(with: data) as! [PageHistory]
            log.debug("page history read.")
        } catch let error as NSError {
            let pageHistory = PageHistory()
            histories.append(pageHistory)
            currentContext = pageHistory.context
            log.warning("failed to read page history: \(error)")
        }
    }
    
    /// ロード開始
    func startLoading(context: String) {
        rx_pageHistoryDataModelDidStartLoading.onNext(context)
    }
    
    /// ロード終了
    func endLoading(context: String) {
        if let _ = D.find(histories, callback: { $0.context == context }) {
            rx_pageHistoryDataModelDidEndLoading.onNext(context)
        } else {
            log.warning("pageHistoryDataModelDidEndLoading not fired. history is deleted.")
        }
    }

    /// 描画終了
    func endRendering(context: String) {
        if let _ = D.find(histories, callback: { $0.context == context }) {
            rx_pageHistoryDataModelDidEndRendering.onNext(context)
        } else {
            log.warning("pageHistoryDataModelDidEndRendering not fired. history is deleted.")
        }
    }
    
    /// 過去のページを閲覧しているかのフラグ
    func isPastViewing(context: String) -> Bool {
        let history = D.find(histories, callback: { $0.context == context })!
        return history.backForwardList.count != 0 && history.listIndex != history.backForwardList.count - 1
    }
    
    /// 直近URL取得
    func getMostForwardUrl(context: String) -> String? {
        if let history = D.find(histories, callback: { $0.context == context }), let url = history.backForwardList.last, !url.isEmpty {
            return url
        }
        return nil
    }
    
    /// 前回URL取得
    func getBackUrl(context: String) -> String? {
        if let history = D.find(histories, callback: { $0.context == context }), history.listIndex > 0 {
            // インデックス調整
            history.listIndex -= 1
            
            return history.backForwardList[history.listIndex]
        }
        return nil
    }
    
    /// 次URL取得
    func getForwardUrl(context: String) -> String? {
        if let history = D.find(histories, callback: { $0.context == context }), history.listIndex < history.backForwardList.count - 1 {
            // インデックス調整
            history.listIndex += 1
            
            return history.backForwardList[history.listIndex]
        }
        return nil
    }
    
    /// ページ読み込み完了後のページ更新
    func update(context: String, url: String, title: String, operation: PageHistory.Operation) {
        histories.forEach({
            if $0.context == context {
                $0.url = url
                $0.title = title

                /// 通常の遷移の場合（ヒストリバックやフォワードではない）
                if operation == .normal {
                    // リスト更新
                    if !isPastViewing(context: context) {
                        $0.backForwardList.append($0.url)
                    } else {
                        // ヒストリーバック -> 通常遷移の場合は、履歴リストを再構築する
                        $0.backForwardList = Array($0.backForwardList.prefix($0.listIndex + 1))
                        $0.backForwardList.append($0.url)
                    }

                    // 保存件数を超えた場合は、削除する
                    if $0.backForwardList.count > pageHistorySaveCount {
                        $0.backForwardList = Array($0.backForwardList.suffix(pageHistorySaveCount))
                    }
                    
                    // インデックス調整
                    $0.listIndex = $0.backForwardList.count - 1
                    
                }
                
                return
            }
        })
    }
    
    /// ページ挿入(new window event)
    func insert(url: String?) {
        if isViewingLatest {
            // 最新ページを見ているなら、insertではないので、appendに切り替える
            append(url: url)
        } else {
            let newPage = PageHistory(url: url ?? "")
            histories.insert(newPage, at: currentLocation + 1)
            currentContext = newPage.context
            rx_pageHistoryDataModelDidInsert.onNext((pageHistory: newPage, at: currentLocation))
        }
    }
    
    /// ページ追加
    func append(url: String?) {
        let newPage = PageHistory(url: url ?? "")
        histories.append(newPage)
        currentContext = newPage.context
        rx_pageHistoryDataModelDidAppend.onNext(newPage)
    }
    
    /// ページコピー
    func copy() {
        if let currentHistory = currentHistory {
            if isViewingLatest {
                // 最新ページを見ているなら、insertではないので、appendに切り替える
                let newPage = PageHistory(url: currentHistory.url, title: currentHistory.title)
                histories.append(newPage)
                currentContext = newPage.context
                rx_pageHistoryDataModelDidAppend.onNext(newPage)
            } else {
                let newPage = PageHistory(url: currentHistory.url, title: currentHistory.title)
                histories.insert(newPage, at: currentLocation + 1)
                currentContext = newPage.context
                rx_pageHistoryDataModelDidInsert.onNext((pageHistory: newPage, at: currentLocation))
            }
        }
    }
    
    /// ページリロード
    func reload() {
        rx_pageHistoryDataModelDidReload.onNext(())
    }
    
    /// ぺージインデックス取得
    func getIndex(context: String) -> Int? {
        return D.findIndex(histories, callback: { $0.context == context })
    }
    
    /// 指定ページの削除
    func remove(context: String) {
        // 削除インデックス取得
        let deleteIndex = D.findIndex(histories, callback: { $0.context == context })!
        
        // フロントの削除かどうか
        if context == currentContext {
            histories.remove(at: deleteIndex)
            // 削除した結果、ページが存在しない場合は作成する
            if histories.count == 0 {
                rx_pageHistoryDataModelDidRemove.onNext((deleteContext: context, currentContext: nil, deleteIndex: deleteIndex))
                let pageHistory = PageHistory()
                histories.append(pageHistory)
                currentContext = pageHistory.context
                rx_pageHistoryDataModelDidAppend.onNext(pageHistory)
                
                return
            } else {
                // 最後の要素を削除した場合は、前のページに戻る
                if deleteIndex == histories.count {
                    currentContext = histories[deleteIndex - 1].context
                } else {
                    currentContext = histories[deleteIndex].context
                }
            }
        } else {
            histories.remove(at: deleteIndex)
        }
        rx_pageHistoryDataModelDidRemove.onNext((deleteContext: context, currentContext: currentContext, deleteIndex: deleteIndex))
    }
    
    /// 表示中ページの変更
    func change(context: String) {
        currentContext = context
        rx_pageHistoryDataModelDidChange.onNext(currentContext)
    }
    
    /// 前ページに変更
    func goBack() {
        if histories.count > 0 {
            let targetContext = histories[0...histories.count - 1 ~= currentLocation - 1 ? currentLocation - 1 : histories.count - 1].context
            currentContext = targetContext
            rx_pageHistoryDataModelDidChange.onNext(currentContext)
        }
    }
    
    /// 次ページに変更
    func goNext() {
        if histories.count > 0 {
            let targetContext = histories[0...histories.count - 1 ~= currentLocation + 1 ? currentLocation + 1 : 0].context
            currentContext = targetContext
            rx_pageHistoryDataModelDidChange.onNext(currentContext)
        }
    }
    
    /// 表示中ページの保存
    func store() {
        if histories.count > 0 {
            let pageHistoryData = NSKeyedArchiver.archivedData(withRootObject: histories)
            do {
                try pageHistoryData.write(to: AppConst.PATH_URL_PAGE_HISTORY)
                log.debug("store page history")
            } catch let error as NSError {
                log.error("failed to write: \(error)")
            }
        }
    }
    
    /// 全データの削除
    func delete() {
        histories = []
        Util.deleteFolder(path: AppConst.PATH_PAGE_HISTORY)
    }
}
