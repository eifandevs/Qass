//
//  WKWebView+Extend.swift
//  Eiger
//
//  Created by temma on 2017/02/26.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import WebKit

private var previousUrlAssociationKey: UInt8 = 0
private var requestUrlAssociationKey: UInt8 = 0
private var requestTitleAssociationKey: UInt8 = 0

extension WKWebView {

    enum NETWORK_ERROR {
        case DNS_NOT_FOUND
        case OFFLINE
        case TIMEOUT
        case INVALID_URL
        case UNAUTHORIZED
    }
    
    // 最新のリクエストURLを常に保持しておく
    // 履歴保存時やリロード時に使用する
    
    var previousUrl: String! {
        get {
            return objc_getAssociatedObject(self, &previousUrlAssociationKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &previousUrlAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // 最新のリクエストURL
    // 不正なリクエストは入らない
    var requestUrl: String! {
        get {
            return objc_getAssociatedObject(self, &requestUrlAssociationKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &requestUrlAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var requestTitle: String! {
        get {
            return objc_getAssociatedObject(self, &requestTitleAssociationKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &requestTitleAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func evaluate(script: String, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var finished = false
        
        evaluateJavaScript(script) { (result, error) in
            if error == nil {
                if result != nil {
                    completion(result as AnyObject?, nil)
                }
            } else {
                completion(nil, error as NSError?)
            }
            finished = true
        }
        
        while !finished {
            RunLoop.current.run(mode: RunLoopMode(rawValue: "NSDefaultRunLoopMode"), before: NSDate.distantFuture)
        }
    }
    
    var hasSavableUrl: Bool {
        get {
            return  previousUrl != requestUrl &&
                requestUrl.hasValidUrl
        }
    }
    
    var hasValidUrl: Bool {
        get {
            if let url = url {
                return url.absoluteString.hasValidUrl
            }
            return false
        }
    }
    
    var hasLocalUrl: Bool {
        get {
            if let url = url {
                return url.absoluteString.hasLocalUrl
            }
            return false
        }
    }
    
    func load(urlStr: String) -> Bool {
        if  urlStr.hasValidUrl {
            guard let url = URL(string: urlStr) else {
                log.error("invalud url load")
                return false
            }
            load(URLRequest(url: url))
            return true
        } else if urlStr.hasPrefix("file://") {
            loadHtml(code: urlToCode(urlStr: urlStr))
        }
        loadHtml(code: NETWORK_ERROR.INVALID_URL)
        return false
    }
    
    private func urlToCode(urlStr: String) -> NETWORK_ERROR {
        switch (urlStr as NSString).lastPathComponent {
        case "timeout.html":
            return NETWORK_ERROR.TIMEOUT
        case "dns.html":
            return NETWORK_ERROR.DNS_NOT_FOUND
        case "offline.html":
            return NETWORK_ERROR.OFFLINE
        case "authorize.html":
            return NETWORK_ERROR.UNAUTHORIZED
        default:
            return NETWORK_ERROR.INVALID_URL
        }
    }
    
    func loadHtml(code: NETWORK_ERROR) {
        let path: String = { _ in
            if code == NETWORK_ERROR.TIMEOUT { return Bundle.main.path(forResource: "timeout", ofType: "html")! }
            if code == NETWORK_ERROR.DNS_NOT_FOUND { return Bundle.main.path(forResource: "dns", ofType: "html")! }
            if code == NETWORK_ERROR.OFFLINE { return Bundle.main.path(forResource: "offline", ofType: "html")! }
            if code == NETWORK_ERROR.UNAUTHORIZED { return Bundle.main.path(forResource: "authorize", ofType: "html")! }
            return Bundle.main.path(forResource: "invalid", ofType: "html")!
        }()
        loadFileURL(URL(fileURLWithPath: path), allowingReadAccessTo: URL(fileURLWithPath: path))
    }
    
    func loadHtml(error: NSError) {
        let errorType = { () -> EGWebView.NETWORK_ERROR in
            log.error("webview load error. code: \(error.code)")
            switch error.code {
            case NSURLErrorCannotFindHost:
                return NETWORK_ERROR.DNS_NOT_FOUND
            case NSURLErrorTimedOut:
                return NETWORK_ERROR.TIMEOUT
            case NSURLErrorNotConnectedToInternet:
                return NETWORK_ERROR.OFFLINE
            default:
                return NETWORK_ERROR.INVALID_URL
            }
        }()
        loadHtml(code: errorType)
    }
    
    func takeThumbnail() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: bounds.size.width, height: bounds.size.width * DeviceDataManager.shared.aspectRate), true, 0);
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false);
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snapshotImage?.crop(w: Int(AppDataManager.shared.thumbnailSize.width * 2), h: Int((AppDataManager.shared.thumbnailSize.width * 2) * DeviceDataManager.shared.aspectRate));
    }
}