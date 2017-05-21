//
//  Util.swift
//  Eiger
//
//  Created by temma on 2017/02/14.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import UIKit

class Util {
    static let shared: Util = Util()
    private init() {}

    func foregroundViewController() -> UIViewController {
        var vc = UIApplication.shared.keyWindow?.rootViewController;
        while ((vc!.presentedViewController) != nil) {
            vc = vc!.presentedViewController;
        }
        return vc!;
    }
    
    func presentWarning(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(defaultAction)
        Util.shared.foregroundViewController().present(alert, animated: true, completion: nil)
    }
    
    func presentAlert(title: String, message: String, completion: @escaping (() -> ())) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            completion()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        Util.shared.foregroundViewController().present(alert, animated: true, completion: nil)
    }
}
