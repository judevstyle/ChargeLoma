//
//  RegEx.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import Foundation
/**
 
 let r = RegEx("[0-9]+\s?%")
 r.test(targetText)
 let replacedText = r.replace(targetText, with: replaceText)
 */
public class RegEx {
    
    public let internalExpression: NSRegularExpression
    public let pattern: String
    
    public init(_ pattern: String) {
        self.pattern = pattern
        self.internalExpression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    public func test(input: String) -> Bool {
        let matches = self.internalExpression.matches(in: input, options: .withoutAnchoringBounds, range: NSMakeRange(0, input.count))
        return matches.count > 0
    }
    
    public func replace(input: String, with: String) -> String {
        return self.internalExpression.stringByReplacingMatches(in: input, options: .withoutAnchoringBounds, range: NSMakeRange(0, input.count), withTemplate: with)
    }
    
    public func matchOne(input: String) -> String? {
        guard let result = self.internalExpression.firstMatch(in: input, options: .withoutAnchoringBounds, range: NSMakeRange(0, input.count)) else {
            return nil
        }
        
        if result.numberOfRanges > 1 {
            return (input as NSString).substring(with: result.range(at: 1))
        }
        
        return (input as NSString).substring(with: result.range)
    }
    
    public func match(input: String) -> [NSTextCheckingResult] {
        var results: [NSTextCheckingResult] = []
        self.internalExpression.enumerateMatches(in: input, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: input.count)) { (result, _, _) in
            if let matchedResult = result {
                results.append(matchedResult)
            }
        }
        return results
    }
    
    func matches(input: String) -> [Substring] {
        let matches = self.internalExpression.matches(in: input, options: .withoutAnchoringBounds, range:NSMakeRange(0, input.count))
        guard let m = matches.first else {
            return []
        }
        return (0..<m.numberOfRanges).compactMap { (rangeIndex) -> Substring? in
            let rng = m.range(at: rangeIndex)
            guard let swiftRange = Range(rng, in: input) else {
                return nil
            }
            return input[swiftRange]
        }
    }
}

public extension String {
    func replace(_ pattern: RegEx, with: String) -> String {
        return pattern.replace(input: self, with: with)
    }
    
    func `is`(_ pattern: RegEx) -> Bool {
        return pattern.test(input: self)
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

public extension RegEx {
    static let integer = RegEx("^\\d+$")
    static let landLine = RegEx("^02[0-9]{1,7}$")
    static let mobileNumbers = RegEx("^0[0-9]{1,9}$")
    static let validLoginNumber = RegEx("^[0-9]+$")
    static let validEmail = RegEx("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    static let newPhoneNumber = RegEx("^((\\+{1}(66){1})|(0)){1}\\d{8,9}$")
    static let versionString = RegEx("^[0-9]+\\.[0-9]+\\.[0-9]+$")
    static let majorVersion = RegEx("^([0-9]+)\\.")
    static let minorVersion = RegEx("\\.([0-9]+)\\.")
    static let revisionVersion = RegEx("\\.([0-9]+)$")
    static let indiaPhoneNumber = RegEx("^(((\\+{1})?(91){1})|(0)){1}\\d{10}$")
}

public extension String {
    
    /**
     Test if given LHS matched RHS' expression
     */
    static func ~= (lhs: String, rhs: String) -> Bool {
        return RegEx(rhs).test(input: lhs)
    }
    
    /**
     Test if given LHS matched RHS' expression
     */
    static func ~= (lhs: String, rhs: RegEx) -> Bool {
        return rhs.test(input: lhs)
    }
    
    /**
     Extract matched Regular Expression
     */
    static func <= (lhs: String, rhs: RegEx) -> [Substring]? {
        let result = rhs.matches(input: lhs)
        if result.count <= 0 {
            return nil
        }
        return result
    }
    
    /**
     Extract matched Regular Expression
     */
    static func <= (lhs: String, rhs: String) -> [Substring]? {
        let result = RegEx(rhs).matches(input: lhs)
        if result.count <= 0 {
            return nil
        }
        return result
    }
}
