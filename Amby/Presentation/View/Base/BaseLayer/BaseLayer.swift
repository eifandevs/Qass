//
//  BaseLayer.swift
//  Eiger
//
//  Created by tenma on 2017/03/02.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum BaseLayerAction {
    case invalidate(swipeDirection: EdgeSwipeDirection)
}

/// ヘッダーとボディとフッターの管理
/// BaseViewからの通知をHeaderViewに伝える
class BaseLayer: UIView {
    /// アクション通知用RX
    let rx_action = PublishSubject<BaseLayerAction>()

    let viewModel = BaseLayerViewModel()
    let headerViewOriginY: (max: CGFloat, min: CGFloat) = (0, -(AppConst.BASE_LAYER.HEADER_HEIGHT - AppConst.DEVICE.STATUS_BAR_HEIGHT))
    let baseViewOriginY: (max: CGFloat, min: CGFloat) = (AppConst.BASE_LAYER.HEADER_HEIGHT, AppConst.DEVICE.STATUS_BAR_HEIGHT)
    private var headerView: HeaderView
    private let footerView: FooterView
    private let baseView: BaseView
    private var searchMenuTableView: SearchMenuTableView? // 検索ビュー
    private var grepOverlay: UIButton? // グレップ中のオーバーレイ
    private var isTouchEndAnimating = false
    private var isHeaderViewEditing = false // 検索中
    private var isHeaderViewGreping = false // グレップ中

    override init(frame: CGRect) {
        // ヘッダービュー
        headerView = HeaderView(frame: CGRect(x: 0, y: headerViewOriginY.max, width: AppConst.DEVICE.DISPLAY_SIZE.width, height: AppConst.BASE_LAYER.HEADER_HEIGHT))
        // フッタービュー
        footerView = FooterView(frame: CGRect(x: 0, y: AppConst.DEVICE.DISPLAY_SIZE.height - AppConst.BASE_LAYER.FOOTER_HEIGHT, width: AppConst.DEVICE.DISPLAY_SIZE.width, height: AppConst.BASE_LAYER.FOOTER_HEIGHT))
        // ベースビュー
        baseView = BaseView(frame: CGRect(x: 0, y: baseViewOriginY.max, width: AppConst.DEVICE.DISPLAY_SIZE.width, height: AppConst.BASE_LAYER.BASE_HEIGHT - AppConst.BASE_LAYER.HEADER_HEIGHT + AppConst.DEVICE.STATUS_BAR_HEIGHT))
        super.init(frame: frame)

        addSubview(baseView)
        addSubview(headerView)
        addSubview(footerView)

        setupRx(frame: frame)
    }

    /// setup rx
    private func setupRx(frame: CGRect) {
        // キーボード監視
        // キーボード表示の処理(フォームの自動設定)
        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardDidShow, object: nil)
            .subscribe { [weak self] _ in
                guard let `self` = self else { return }
                if !self.isHeaderViewEditing && self.viewModel.canAutoFill {
                    // 自動入力オペ要求
                    self.viewModel.autoFill()
                } else {
                    log.warning("cannot autofill")
                }
            }
            .disposed(by: rx.disposeBag)

        // フォアグラウンド時にベースビューの位置をMinにする
        NotificationCenter.default.rx.notification(.UIApplicationWillEnterForeground, object: nil)
            .subscribe { [weak self] _ in
                guard let `self` = self else { return }
                self.baseView.slideToMax()
            }
            .disposed(by: rx.disposeBag)

        // BaseViewアクション監視
        baseView.rx_action
            .subscribe { [weak self] action in
                guard let `self` = self, let action = action.element else { return }
                log.eventIn(chain: "BaseView.rx_action. action: \(action)")
                switch action {
                case let .swipe(direction):
                    // 検索中の場合は、検索画面を閉じる
                    if self.searchMenuTableView != nil {
                        log.debug("close search menu.")
                        self.endEditingWithHeader()
                        self.validateUserInteraction()
                    } else {
                        self.rx_action.onNext(.invalidate(swipeDirection: direction))
                    }
                case let .slide(distance):
                    self.headerView.slide(value: distance)
                case .slideToMax: self.headerView.slideToMax()
                case .slideToMin: self.headerView.slideToMin()
                default: break
                }
                log.eventOut(chain: "BaseView.rx_action. action: \(action)")
            }
            .disposed(by: rx.disposeBag)

        // HeaderViewアクション監視
        headerView.rx_action
            .subscribe { [weak self] action in
                log.eventIn(chain: "HeaderView.rx_action")
                guard let `self` = self, let action = action.element else { return }

                switch action {
                case .beginSearching: self.beginSearching(frame: frame)
                case .endEditing:
                    // ヘッダーのクローズボタン押下 or 検索開始
                    // ヘッダーフィールドやヘッダービューはすでにクローズ処理を実施しているので、サーチメニューの削除をする
                    self.endEditing()
                case .beginGreping: self.beginGreping(frame: frame)
                case .endGreping:
                    // ヘッダーのクローズボタン押下 or 検索開始
                    // ヘッダーフィールドやヘッダービューはすでにクローズ処理を実施しているので、サーチメニューの削除をする
                    self.endGreping()
                }
                log.eventOut(chain: "HeaderView.rx_action")
            }
            .disposed(by: rx.disposeBag)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        log.debug("deinit called.")
    }

    // MARK: Public Method

    func validateUserInteraction() {
        baseView.validateUserInteraction()
    }

    /// 解放処理
    func mRelease() {
        baseView.removeFromSuperview()
        headerView.removeFromSuperview()
        footerView.removeFromSuperview()
    }

    // MARK: Private Method

    /// 検索開始
    private func beginSearching(frame: CGRect) {
        baseView.slideToMax()

        isHeaderViewEditing = true
        searchMenuTableView = SearchMenuTableView(frame: CGRect(origin: CGPoint(x: 0, y: headerView.frame.size.height), size: CGSize(width: frame.size.width, height: frame.size.height - headerView.frame.size.height)))
        // サーチメニューアクション監視
        searchMenuTableView!.rx_action
            .subscribe { [weak self] action in
                log.eventIn(chain: "SearchMenuTableView.rx_action")
                guard let `self` = self, let action = action.element else { return }

                switch action {
                case .endEditing:
                    self.headerView.closeKeyBoard()
                case .close:
                    // サーチメニューのクローズ要求を受けて、ヘッダービューにクローズ要求を送り、自分はサーチメニューの削除をする
                    self.endEditingWithHeader()
                }
                log.eventOut(chain: "SearchMenuTableView.rx_action")
            }
            .disposed(by: rx.disposeBag)

        addSubview(searchMenuTableView!)
        searchMenuTableView!.getModelData()
    }

    /// 編集モード終了
    private func endEditing() {
        EGApplication.sharedMyApplication.egDelegate = baseView
        isHeaderViewEditing = false
        searchMenuTableView!.removeFromSuperview()
        searchMenuTableView = nil
    }

    private func endEditingWithHeader() {
        endEditing()
        headerView.endEditing(headerFieldUpdate: false)
    }

    private func beginGreping(frame: CGRect) {
        baseView.slideToMax()

        isHeaderViewGreping = true
        grepOverlay = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: headerView.frame.size.height), size: CGSize(width: frame.size.width, height: frame.size.height - headerView.frame.size.height)))

        // グレップ中に画面をタップ
        grepOverlay!.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.endGrepingWithHeader()
            })
            .disposed(by: rx.disposeBag)

        addSubview(grepOverlay!)
    }

    /// グレップモード終了
    private func endGreping() {
        EGApplication.sharedMyApplication.egDelegate = baseView
        isHeaderViewGreping = false
        grepOverlay!.removeFromSuperview()
        grepOverlay = nil
    }

    private func endGrepingWithHeader() {
        endGreping()
        headerView.endGreping()
    }
}

// MARK: EGApplication Delegate

extension BaseLayer: EGApplicationDelegate {

    // MARK: Screen Event

    func screenTouchBegan(touch _: UITouch) {
    }

    func screenTouchEnded(touch _: UITouch) {
    }

    func screenTouchMoved(touch _: UITouch) {
    }

    func screenTouchCancelled(touch _: UITouch) {
    }
}