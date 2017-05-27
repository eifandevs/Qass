//
//  HeaderViewModel.swift
//  Eiger
//
//  Created by temma on 2017/04/30.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import UIKit

protocol HeaderViewModelDelegate {
    func headerViewModelDidChangeProgress(progress: CGFloat)
    func headerViewModelDidChangeField(text: String)
}

class HeaderViewModel {
    // 通知センター
    private let center = NotificationCenter.default
    
    var delegate: HeaderViewModelDelegate?

    init () {
        center.addObserver(self,
                           selector: #selector(type(of: self).applicationDidBecomeActive(notification:)),
                           name: .UIApplicationDidBecomeActive,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(type(of: self).headerViewModelWillChangeProgress(notification:)),
                           name: .headerViewModelWillChangeProgress,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(type(of: self).headerViewModelWillChangeField(notification:)),
                           name: .headerViewModelWillChangeField,
                           object: nil)
    }

// MARK: Public Method

    func notifyHistoryBackWebView() {
        center.post(name: .baseViewModelWillHistoryBackWebView, object: nil)
    }

    func notifyHistoryForwardWebView() {
        center.post(name: .baseViewModelWillHistoryForwardWebView, object: nil)
    }
    
    func notifyChangeWebView(text: String) {
        center.post(name: .baseViewModelWillSearchWebView, object: text)
    }

    func notifyRegisterAsFavorite() {
        center.post(name: .baseViewModelWillRegisterAsFavorite, object: nil)
    }
    
    func notifyRemoveWebView() {
        center.post(name: .baseViewModelWillRemoveWebView, object: nil)
    }
    
// MARK: Notification受信
    
    @objc private func headerViewModelWillChangeProgress(notification: Notification) {
        delegate?.headerViewModelDidChangeProgress(progress: notification.object as! CGFloat)
    }
    
    @objc private func headerViewModelWillChangeField(notification: Notification) {
        log.debug("[HeaderView Event]: headerViewModelWillChangeField")
        delegate?.headerViewModelDidChangeField(text: notification.object as! String)
    }
    
    @objc private func applicationDidBecomeActive(notification: Notification) {
        // プログレスバーの初期化
        delegate?.headerViewModelDidChangeProgress(progress: 0)
    }
}
