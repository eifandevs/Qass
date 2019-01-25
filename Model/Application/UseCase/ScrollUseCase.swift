//
//  ScrollUseCase.swift
//  Amby
//
//  Created by tenma on 2018/08/23.
//  Copyright © 2018年 eifandevs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public enum ScrollUseCaseAction {
    case scrollUp
    case autoScroll
}

/// スクロールユースケース
public final class ScrollUseCase {
    public static let s = ScrollUseCase()

    /// アクション通知用RX
    public let rx_action = PublishSubject<ScrollUseCaseAction>()

    public var autoScrollInterval: CGFloat {
        get {
            return CGFloat(settingDataModel.autoScrollInterval)
        }
        set(value) {
            settingDataModel.autoScrollInterval = Float(value)
        }
    }

    /// models
    private var settingDataModel: SettingDataModelProtocol!

    private init() {
        setupProtocolImpl()
    }

    private func setupProtocolImpl() {
        settingDataModel = SettingDataModel.s
    }

    /// スクロールアップ
    public func scrollUp() {
        rx_action.onNext(.scrollUp)
    }

    /// 自動スクロール
    public func autoScroll() {
        rx_action.onNext(.autoScroll)
    }
}
