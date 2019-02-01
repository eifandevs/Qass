//
//  Array+Extend.swift
//  Qas
//
//  Created by temma on 2017/08/01.
//  Copyright © 2017年 eifaniori. All rights reserved.
//

import Foundation

extension Array {
    /// 移動
    mutating func move(from: Int, to: Int) -> Array {
        let item = self[from]
        remove(at: from)
        insert(item, at: to)
        return self
    }

    /// 複数のオブジェクトを安全にとりだす
    func objects(for: Int) -> Array {
        if count == 0 {
            return self
        }
        guard 0 ... count - 1 ~= `for` else {
            return objects(for: count - 1)
        }
        return Array(self[0 ... `for`])
    }
}

// 配列の重複を削除
extension Array where Element: Equatable {
    /// オブジェクト指定で削除
    mutating func remove<T: Equatable>(obj: T) -> Array {
        self = filter({ $0 as? T != obj })
        return self
    }
}