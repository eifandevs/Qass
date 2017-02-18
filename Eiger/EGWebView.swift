//
//  EGWebView.swift
//  Eiger
//
//  Created by temma on 2017/02/05.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import WebKit
import SpringIndicator

class EGWebView: WKWebView {
    enum NETWORK_ERROR {
        case DNS_NOT_FOUND
        case TIMEOUT
        case INVALID_URL
        case UNAUTHORIZED
    }
    
    var previousUrl: URL? = nil // リロードしたページを履歴に登録しないためのフラグ
    var isHistoryRequest: Bool = false // ページを戻る(進む)のリクエストかどうか
    private let refreshControl = SpringIndicator.Refresher()
    
    init(pool: WKProcessPool) {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = pool
        // Cookie, Cache, その他Webデータを端末内に残す
        configuration.websiteDataStore = WKWebsiteDataStore.default()
        configuration.allowsPictureInPictureMediaPlayback = true
        super.init(frame: CGRect.zero, configuration: configuration)
        isOpaque = true
        allowsLinkPreview = true
        
        // プルダウンリフレッシュ
        refreshControl.indicator.lineCap = true
        refreshControl.indicator.lineColor = UIColor.frenchBlue
        refreshControl.addTarget(self, action: #selector(EGWebView.onRefresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        refreshControl.endRefreshing() // 初回起動時に表示される問題を修正
        
    }
    
    func onRefresh() {
        reload()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func load(urlStr: String) -> Bool {
        if (validUrl(urlStr: urlStr)) {

            let encodedURL = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            guard let url = URL(string: encodedURL!) else {
                log.error("invalud url load")
                return false
            }
            super.load(URLRequest(url: url))
            return true
        }
        loadHtml(code: NETWORK_ERROR.INVALID_URL)
        return false
    }
    
    private func validUrl(urlStr: String) -> Bool {
        return (urlStr != "http://") && (urlStr != "https://") &&
               ((urlStr.hasPrefix("http://") == true) || (urlStr.hasPrefix("https://") == true))
    }
    
    func loadHtml(code: NETWORK_ERROR) {
        let path: String = { _ in
            if code == NETWORK_ERROR.TIMEOUT { return Bundle.main.path(forResource: "timeout", ofType: "html")! }
            if code == NETWORK_ERROR.DNS_NOT_FOUND { return Bundle.main.path(forResource: "dns", ofType: "html")! }
            if code == NETWORK_ERROR.UNAUTHORIZED { return Bundle.main.path(forResource: "authorize", ofType: "html")! }
            return Bundle.main.path(forResource: "invalid", ofType: "html")!
        }()
            
        super.loadFileURL(URL(fileURLWithPath: path), allowingReadAccessTo: URL(fileURLWithPath: path))
    }
    
    func loadHtml(error: NSError) {
        let errorType = { () -> EGWebView.NETWORK_ERROR in
            switch error.code {
            case -1003:
                return NETWORK_ERROR.DNS_NOT_FOUND
            case -1001:
                return NETWORK_ERROR.TIMEOUT
            default:
                return NETWORK_ERROR.INVALID_URL
            }
        }()
        loadHtml(code: errorType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
