//
//  Double.swift
//  Rainbow
//
//  Created by Quentin MED on 2018/10/22.
//

import Foundation

extension Double {
    
    func clamp(min: Double, max: Double) -> Double {
        if self < min { return min }
        if self > max { return max }
        return self
    }
}
