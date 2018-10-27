import Foundation

extension Double {
    
    func clamp(min: Double, max: Double) -> Double {
        if self < min { return min }
        if self > max { return max }
        return self
    }
}
