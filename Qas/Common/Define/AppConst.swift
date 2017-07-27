//
//  AppDataManager.swift
//  Eiger
//
//  Created by tenma on 2017/02/07.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import UIKit

class AppConst {
    static let headerViewHeight = 45 + DeviceConst.statusBarHeight
    static let headerFieldWidth = DeviceConst.displaySize.width / 1.8
    static let edgeSwipeErea: CGFloat = 15.0
    static let optionMenuCellHeight: CGFloat = 50
    static let optionMenuSize: CGSize = CGSize(width: 250, height: 450)
    static let thumbnailSize = CGSize(width: 105, height: 105 * UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height)
    static let searchPath = "https://www.google.co.jp/search?q="
    static let locationIndexKey = "locationIndex"
    static let autoScrollIntervalKey = "autoScrollInterval"
    static let appFont = "Avenir"
    static let eachHistoryPath = DeviceConst.cachesPath + "/each_history.dat"
    static let eachHistoryUrl = URL(fileURLWithPath: AppConst.eachHistoryPath)
    static let commonHistoryPath = DeviceConst.cachesPath + "/common_history"
    static let thumbnailBaseFolderPath = DeviceConst.cachesPath + "/thumbnails"
    static let realmPath = DeviceConst.cachesPath + "/database"
    
    static func thumbnailFolderPath(folder: String) -> String {
        let path = thumbnailBaseFolderPath + "/\(folder)"
        Util.createFolder(path: path)
        return path
    }
    
    static func thumbnailPath(folder: String) -> String {
        let path = thumbnailBaseFolderPath + "/\(folder)"
        Util.createFolder(path: path)
        return path + "/thumbnail.png"
    }
    
    static func thumbnailUrl(folder: String) -> URL {
        let path = DeviceConst.cachesPath + "/thumbnails/\(folder)"
        Util.createFolder(path: path)
        return URL(fileURLWithPath: path + "/thumbnail.png")
    }
    
    static func thumbnailFolderUrl(folder: String) -> URL {
        let path = DeviceConst.cachesPath + "/thumbnails/\(folder)"
        return URL(fileURLWithPath: path)
    }
    
    static func commonHistoryUrl(date: String) -> URL {
        let path = DeviceConst.cachesPath + "/common_history"
        Util.createFolder(path: path)
        return URL(fileURLWithPath: path + "/\(date).dat")
    }
    
    static func commonHistoryFilePath(date: String) -> String {
        let path = DeviceConst.cachesPath + "/common_history"
        return path + "/\(date).dat"
    }
}