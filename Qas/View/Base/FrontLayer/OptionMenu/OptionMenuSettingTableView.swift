//
//  OptionMenuSettingTableView.swift
//  Qas
//
//  Created by temma on 2017/12/17.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class OptionMenuSettingTableView: UIView, ShadowView, OptionMenuView {
    // メニュークローズ通知用RX
    let rx_optionMenuSettingDidClose = PublishSubject<Void>()
    
    let viewModel = OptionMenuSettingTableViewModel()
    @IBOutlet weak var tableView: UITableView!

    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib() {
        let view = Bundle.main.loadNibNamed(R.nib.optionMenuSettingTableView.name, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        
        // 影
        addMenuShadow()
        
        // テーブルビュー監視
        tableView.delegate = self
        tableView.dataSource = self
        
        // OptionMenuProtocol
        _ = setup(tableView: tableView)
        
        // カスタムビュー登録
        tableView.register(R.nib.optionMenuSettingSliderTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.optionMenuSettingSliderCell.identifier)
        tableView.register(R.nib.optionMenuSettingTableViewCell(), forCellReuseIdentifier: R.reuseIdentifier.optionMenuSettingCell.identifier)
        
        self.addSubview(view)
    }
}

// MARK: - TableViewDataSourceDelegate
extension OptionMenuSettingTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = viewModel.getRow(indexPath: indexPath)
        
        if row.cellType == .autoScroll {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.optionMenuSettingSliderCell.identifier, for: indexPath) as! OptionMenuSettingSliderTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.optionMenuSettingCell.identifier, for: indexPath) as! OptionMenuSettingTableViewCell
            cell.setViewModelData(row: row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label : PaddingLabel = PaddingLabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: frame.size.width, height: viewModel.sectionHeight)))
        label.backgroundColor = UIColor.black
        label.textAlignment = .left
        label.text = viewModel.getSection(section: section).title
        label.textColor = UIColor.white
        label.font = UIFont(name: AppConst.APP_FONT, size: viewModel.sectionFontSize)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.sectionHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellCount(section: section)
    }
}

// MARK: - TableViewDelegate
extension OptionMenuSettingTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = viewModel.getRow(indexPath: indexPath)
        switch row.cellType {
        case .commonHistory:
            viewModel.deleteCommonHistoryDataModel()
        case .bookMark:
            viewModel.deleteFavoriteDataModel()
        case .form:
            viewModel.deleteFormDataModel()
        case .searchHistory:
            viewModel.deleteSearchHistoryDataModel()
        case .cookies:
            viewModel.deleteCookies()
        case .siteData:
            viewModel.deleteCaches()
        case .all:
            viewModel.deleteAll()
        default:
            break
        }
        rx_optionMenuSettingDidClose.onNext(())
    }
}
