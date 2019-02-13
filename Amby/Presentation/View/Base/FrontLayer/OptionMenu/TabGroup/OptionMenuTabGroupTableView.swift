//
//  OptionMenuCooperationTableView.swift
//  Amby
//
//  Created by tenma on 2018/11/09.
//  Copyright © 2018年 eifandevs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

enum OptionMenuTabGroupTableViewAction {
    case close
}

class OptionMenuTabGroupTableView: UIView, ShadowView, OptionMenuView {
    // アクション通知用RX
    let rx_action = PublishSubject<OptionMenuTabGroupTableViewAction>()

    private let viewModel = OptionMenuTabGroupTableViewModel()
    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    deinit {
        log.debug("deinit called.")
    }

    func setup() {
        // 影
        addMenuShadow()

        // テーブルビュー監視
        tableView.delegate = self
        tableView.dataSource = self

        // OptionMenuProtocol
        _ = setupLayout(tableView: tableView)

        // カスタムビュー登録
        tableView.register(R.nib.optionMenuTabGroupTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.optionMenuTabGroupCell.identifier)

        addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.left.equalTo(snp.left).offset(0)
            make.right.equalTo(snp.right).offset(0)
            make.top.equalTo(snp.top).offset(0)
            make.bottom.equalTo(snp.bottom).offset(0)
        }
    }
}

// MARK: - TableViewDataSourceDelegate

extension OptionMenuTabGroupTableView: UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = R.reuseIdentifier.optionMenuTabGroupCell.identifier
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? OptionMenuTabGroupTableViewCell {
//            let row = viewModel.getRow(indexPath: indexPath)
//            cell.setRow(row: row)

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }
}

// MARK: - TableViewDelegate

extension OptionMenuTabGroupTableView: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        //        let row = viewModel.getRow(indexPath: indexPath)
        // TODO: 処理
        rx_action.onNext(.close)
    }
}
