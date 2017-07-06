//
//  Thumbnail.swift
//  Weasel
//
//  Created by temma on 2017/07/06.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation
import UIKit

class Thumbnail: UIButton {
    var isFront = false {
        didSet {
            frontBar.alpha = isFront ? 1 : 0
        }
    }
    private let frontBar = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        frontBar.frame = CGRect(origin: CGPoint(x: 0, y: frame.size.height - 4), size: CGSize(width: frame.size.width, height: 4))
        frontBar.backgroundColor = UIColor.rasberry
        frontBar.alpha = 0
        addSubview(frontBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
