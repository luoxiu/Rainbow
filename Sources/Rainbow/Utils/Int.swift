//
//  Int.swift
//  Rainbow
//
//  Created by Quentin MED on 2018/10/22.
//

import Foundation

extension Int {
    
    func clamp(min: Int, max: Int) -> Int {
        if self < min { return min }
        if self > max { return max }
        return self
    }
    
    var hex: String {
        var s = String(self, radix: 16, uppercase: false)
        if s.count < 2 { s = "0" + s }
        return s
    }
}
