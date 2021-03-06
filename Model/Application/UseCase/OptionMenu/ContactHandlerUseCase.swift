//
//  ContactHandlerUseCase.swift
//  Amby
//
//  Created by tenma on 2018/08/23.
//  Copyright © 2018年 eifandevs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public enum ContactCaseAction {
    case present
}

/// コンタクトユースケース
public final class ContactHandlerUseCase {
    public static let s = ContactHandlerUseCase()

    /// アクション通知用RX
    public let rx_action = PublishSubject<ContactCaseAction>()

    private init() {}

    /// コンタクト画面表示
    public func open() {
        rx_action.onNext(.present)
    }
}
