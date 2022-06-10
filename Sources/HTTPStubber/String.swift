import Foundation

extension String {
    func replacingCharacters(matche regex: String, with replacement: String) throws -> String {
        let regex = try NSRegularExpression(pattern: regex, options: [])
        let range = NSMakeRange(0, (self as NSString).length)
        return regex.stringByReplacingMatches(in: self, range: range, withTemplate: replacement)
    }
    
    func inserted(_ newElement: Character, at index: String.Index) -> String {
        var string = self
        string.insert(newElement, at: index)
        return string
    }
}
