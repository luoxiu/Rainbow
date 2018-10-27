import Foundation

extension NSRegularExpression {

    static func match(_ s: String, pattern: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return [] }
        guard let matches = regex.matches(in: s, options: [], range: NSRange(location: 0, length: s.count)).first else { return [] }

        var captures: [String] = []
        for i in 0..<matches.numberOfRanges {
            let range = matches.range(at: i)
            if range.length == 0 { continue }
            captures.append(NSString(string: s).substring(with: range) as String)
        }
        return captures
    }
}
