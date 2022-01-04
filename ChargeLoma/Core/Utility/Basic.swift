//
//  Basic.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import Foundation
import UIKit
import CoreMedia
// MARK: - Shorthand
/**
 Shorthand for posting Notification
 */
public extension Notification.Name {
    func post(object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }
}

/**
 Shorthand for creating UIColor object
 */
public extension UIColor {
    /**
     Example: UIColor(rgb: 0xFF33AA)
     */
    convenience init(rgb: UInt) {
        self.init(displayP3Red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat((rgb & 0x0000FF) >> 0) / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(rgbFromString: String) {
        let rgbFromStringValue = UInt(RegEx("^0x").replace(input: rgbFromString, with: ""),radix: 16)!
        self.init(displayP3Red: CGFloat((rgbFromStringValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbFromStringValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat((rgbFromStringValue & 0x0000FF) >> 0) / 255.0,
                  alpha: 1.0)
    }
    
    static func rgbFrom(string: String) -> UIColor? {
        var cString: String = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return nil
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor( red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                        alpha: 1.0)
    }
}

public func gradient(frame: CGRect) -> CAGradientLayer {
    let layer = CAGradientLayer()
    layer.frame = frame
    layer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.init(white: 0, alpha: 0.9).cgColor]
    return layer
}

public func whiteGradient(frame: CGRect) -> CAGradientLayer {
    let layer = CAGradientLayer()
    layer.frame = frame
    layer.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
    return layer
}

public func addGradient(areaView: UIView) -> UIView {
    let colorTop    = UIColor(red: 167/255, green: 169/255, blue: 171/255, alpha: 1.0).cgColor /* #a7a9ab */
    let colorBottom = UIColor(red: 218/255, green: 222/255, blue: 225/255, alpha: 1.0).cgColor /* #dadee1 */
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [ colorTop, colorBottom]
    gradientLayer.locations = [ 0.0, 1.0]
    gradientLayer.frame = CGRect(x: 0, y: 0, width: areaView.bounds.width + 1000, height: areaView.bounds.height)
    areaView.layer.addSublayer(gradientLayer)
    
    return areaView
}

// create nav bottom bar shadows
public func addNavBarBottomGradientView(areaView: UIView) -> UIView {
    let colorTop = UIColor(red: 74/255, green: 81/255, blue: 88/255, alpha: 1.0).cgColor /* #4a5158 */
    let colorBottom = UIColor(red: 104/255, green: 116/255, blue: 126/255, alpha: 1.0).cgColor /* #68747e */
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [ colorTop, colorBottom]
    gradientLayer.locations = [ 0.0, 1.0]
    gradientLayer.frame = CGRect(x: 0, y: 0, width: areaView.bounds.width + 1000, height: areaView.bounds.height)
    areaView.layer.addSublayer(gradientLayer)
    
    return areaView
}

/**
 Internal Helper Class to facilitate setNamedTimeout method.
 */
fileprivate class TimeoutRepo {
    
    static let shared = TimeoutRepo()
    
    fileprivate var timeouts = [String: Timer]()
    
    private init() { }
}

/**
 setTimeout()
 
 Shorthand method for create a delayed block to be execute on started Thread.
 
 This method returns ``Timer`` instance, so that user may execute the block
 within immediately or keep the reference for further cancelation by calling
 ``Timer.invalidate()``
 
 Example:
    let timer = setTimeout(0.3) {
        // do something
    }
    timer.invalidate()      // cancel it.
 */
public func setTimeout(_ delay: TimeInterval, block: @escaping () -> Void) -> Timer {
    return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
}

/**
 setNamedTimeout()
 
 Sometime setTimeout() might be called repeatedly which invoked the same function
 over and over, while what author need to achieve is just a single call.
 
 To make that happen author, must save the reference of Timer instance returned
 and invalidated it before next enqueue.So that after certain delay the method
 within block will be executed once.
 
 This method will do just that, by given a name as a unique identification of the
 delay.
 */
public func setNamedTimeout(_ name: String, delay: TimeInterval, block: @escaping () -> Void) {
    _ = dispatch(.main) {
        TimeoutRepo.shared.timeouts[name]?.invalidate()
        TimeoutRepo.shared.timeouts[name] = Timer.scheduledTimer(timeInterval: delay, target: BlockOperation {
            TimeoutRepo.shared.timeouts.removeValue(forKey: name)
            block()
        }, selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
}

/**
 setInternval()
 
 Similar to setTimeout() this method will return ``Timer`` instance however, this
 method will execute repeatedly.
 
 Warning using this method with caution, it is recommended that the block to utilise
 this method should call [unowned self] or [weak self] to announce OS that it should not
 hold strong reference to this block.
 
 In addition, ``Timer`` returned should kept as member variable, and call invalidated()
 when the block no longer required. such as deinit, or viewDidDisappear()
 */
public func setInterval(_ interval: TimeInterval, block: @escaping () -> Void) -> Timer {
    return Timer.scheduledTimer(timeInterval: interval, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: true)
}

/**
 UITableView.register(nibCellClassName:String)
 
 Shorthand method to register the class as a UITableViewCell. (Reuse Id is exact as className itself)
 */
public extension UITableView {
    func register(nibCellClassName: String) {
        let nib = UINib(nibName: nibCellClassName, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: nibCellClassName)
    }
    
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}

/**
 UICollectionView.register(nibCellClassName:String)
 
 Shorthand method to register the class as a UICollectionViewCell. (Reuse Id is exact as className itself).
 */
public extension UICollectionView {
    func register(headerNibClassName: String) {
        let nib = UINib(nibName: headerNibClassName, bundle: .main)
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerNibClassName)
    }
    
    func register(footerNibClassName: String) {
        let nib = UINib(nibName: footerNibClassName, bundle: .main)
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerNibClassName)
    }
    
    func register(nibCellClassName: String) {
        let nib = UINib(nibName: nibCellClassName, bundle: .main)
        self.register(nib, forCellWithReuseIdentifier: nibCellClassName)
    }
    
    func isIndexPathExists(_ indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections,
              indexPath.row < numberOfItems(inSection: indexPath.section)
            else { return false }
        return true
    }
    
}

public extension CGRect {
    static func make(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

public extension CGPoint {
    static func make(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}

public extension CGFloat {
    var radians: CGFloat { return self * (CGFloat(Double.pi) / 180) }
    var degrees: CGFloat { return self * (180 / CGFloat(Double.pi)) }
}

public extension Int {
    var radians: CGFloat { return CGFloat(self) * CGFloat(Double.pi) / 180 }
    
    var currencyWithComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let numText = numberFormatter.string(from: self as NSNumber) else {
            return ""
        }
        return numText
    }

    func getUnitBytes() -> (value: Double, symbol: String) {
        var count = 0
        var value:Double = Double(self)
        
        while value > 1024 {
            value /= 1024
            count += 1
        }
        
        switch count {
        case 0:
            return (value: value, symbol: "Bytes")
        case 1:
            return (value: value, symbol: "kB")
        case 2:
            return (value: value, symbol: "MB")
        case 3:
            return (value: value, symbol: "GB")
        case 4:
            return (value: value, symbol: "TB")
        default:
            return (value: value, symbol: "Unlimited")
        }
    }
    
}

public extension String {
    
    func parseDuration() -> TimeInterval {
        guard !self.isEmpty else {
            return 0
        }
        var interval: Double = 0
        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        return interval
    }
    
    func substring(_ from: Int, length: Int) -> String {
        let begin = self.index(self.startIndex, offsetBy: from)
        let end = self.index(self.startIndex, offsetBy: (from+length))
        return String(self[begin..<end])
    }
    
    subscript(index: Int) -> Character? {
        get {
            if self.count > index {
                let index = self.index(self.startIndex, offsetBy:index)
                return self[index]
            }
            return nil
        }
    }
    
    func length() -> Int {
        return self.count
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func trimWhitespaces() -> String {
        return self.replace(target: " ", withString: "")
    }
    
    func underline(color: UIColor) -> NSMutableAttributedString {
        let titleString = NSMutableAttributedString(string: self)
        titleString.addAttribute(.underlineStyle,
                                 value: NSUnderlineStyle.single.rawValue,
                                 range: NSMakeRange(0, self.count))
        titleString.addAttribute(.foregroundColor,
                                 value: color,
                                 range: NSMakeRange(0, self.count))
        return titleString
    }
    
    func formatPrice() -> String {
        let largeNumber = Int(self) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:largeNumber)) ?? self
    }
}

/**
 Sequence Helpers
 */
public extension Sequence {
    
    typealias Element = Iterator.Element
    
    func some(_ block: (Element) -> Bool) -> Bool {
        return first(where: block) != nil
    }
    
    func all(_ block: (Element) -> Bool) -> Bool {
        return first(where: { !block($0) }) == nil
    }
    
    /// Example Case
    /// let value = list.filter(where: { $0.value == case }, limit: XXX)
    /// print(value)
    func filter(where isIncluded: (Iterator.Element) -> Bool, limit: Int) -> [Iterator.Element] {
        var result : [Iterator.Element] = []
        result.reserveCapacity(limit)
        var count = 0
        var it = makeIterator()

        // While limit not reached and there are more elements ...
        while count < limit, let element = it.next() {
            if isIncluded(element) {
                result.append(element)
                count += 1
            }
        }
        return result
    }
}

public extension Date {
    
    func format(pattern: String = "yyyy'-'MM'-'dd", timezoneOffset: Int? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = pattern
        if let timezoneOffset = timezoneOffset {
            dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        }
        return dateFormatter.string(from: self)
    }
}

public extension TimeZone {
    
    static let appDefault = TimeZone(identifier: "Asia/Bangkok")
}

public extension UIView {
    
    func capture() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        self.layer.render(in: currentContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    var snapshot: UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isPhoneNumber: Bool {
        let regexNumbersOnly = try! NSRegularExpression(pattern: "^0[0-9]{9}", options: [])
        return regexNumbersOnly.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil) {
                if (self.count >= 6 && self.count <= 20) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } catch {
            return false
        }
    }

    func makeNumberFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        if let number = Float(self) {
            let myNumber = NSNumber(value:number)
            if let format = formatter.string(from: myNumber) {
                return format
            }
        }
        
        return self
    }
}

public extension String {
    
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

public extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

public extension String {
    func splitText() -> String {
        let string = self
        let array = string.components(separatedBy: ",")
        print(array)
        return (array.count > 0) ? array.first! : string
    }
}

public extension NSAttributedString {
    
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

// function การทำงานแบบ thread : backgrund, main
public extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}

public extension URL {
    func getKeyVals() -> Dictionary<String, String>? {
        var results: [String: String] = [:]
        guard let keyValues = self.query?.components(separatedBy: "&") else {
            return nil
        }
        if keyValues.count > 0 {
            for pair in keyValues {
                let kv = pair.components(separatedBy: "=")
                if kv.count > 1 {
                    results.updateValue(kv[1], forKey: kv[0])
                }
            }
        }
        return results
    }
}

public extension CMTime {
    var durationText: String {
        let totalSeconds = CMTimeGetSeconds(self)
        let hours = Int(totalSeconds.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
        
    }
}

public extension NSRange {
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}


public class GradientView: UIView {
    
    @IBInspectable public var startColor: UIColor = .black { didSet { updateColors() } }
    @IBInspectable public var endColor: UIColor = .white { didSet { updateColors() } }
    @IBInspectable public var startLocation: Double = 0.05 { didSet { updateLocations() } }
    @IBInspectable public var endLocation: Double = 0.95 { didSet { updateLocations() } }
    @IBInspectable public var horizontalMode: Bool = false { didSet { updatePoints() } }
    @IBInspectable public var diagonalMode: Bool = false { didSet { updatePoints() } }
    
    override public class var layerClass: AnyClass { return CAGradientLayer.self }
    
    public var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    public func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    public func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    public func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}

// get date tomorow
public extension Date {
    
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    func getTomorrowDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let tomorrow = self.tomorrow {
            let tomorrowString = dateFormatter.string(from: tomorrow)
            return tomorrowString
        }
        return ""
    }
}

public extension String {
    func addParametersGetUrl(parameters: [String: String]) -> String {
        var resultUrl = ""
        var resultParas = ""
        
        var subParameter = "&"
        if self.lowercased().range(of: "?") == nil {
            subParameter = "?"
        }
        
        for parameter in parameters {
            resultParas += "\(subParameter)\(parameter.key)=\(parameter.value)"
            subParameter = "&"
        }
        resultUrl = "\(self)\(resultParas)"
        
        return resultUrl
    }
    
    func validateParametersGetUrl() -> String {
        var resultUrl = ""
        var subParameter = "&"
        
        if self.lowercased().range(of: "?") == nil {
            subParameter = "?"
        }
        
        resultUrl = "\(self)\(subParameter)"
        return resultUrl
    }
}

public extension UIViewController {
    func checkFacebookInstalled() -> Bool {
        if let url = URL(string: "fb://") {
            let isInstalled = UIApplication.shared.canOpenURL(url)
            return isInstalled
        }
        return false
    }
    
    func checkInstagramInstalled() -> Bool {
        
        if let url = URL(string: "instagram://") {
            let isInstalled = UIApplication.shared.canOpenURL(url)
            return isInstalled
        }
        return false
    }
    
    func checkTwitterInstalled() -> Bool {
        if let url = URL(string: "twitter://") {
            let isInstalled = UIApplication.shared.canOpenURL(url)
            return isInstalled
        }
        return false
    }
    
    func checkLineInstalled() -> Bool {
        if let url = URL(string: "line://") {
            let isInstalled = UIApplication.shared.canOpenURL(url)
            return isInstalled
        }
        return false
    }
    
    func embed(_ viewController: UIViewController, inView view: UIView){
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
}

public extension Float {
    /// Calculus progress when watch movie continue
    ///
    /// - Parameters:
    ///   - millisec: breakpoint millisec
    ///   - duration: duration minute
    /// - Returns: full value is 1
    static func calculateValueOfProgressTime(breakTime millisec: Int32, duration: Int) -> Float {
        guard duration != 0 else {
            return 0
        }
        
        let durationMillisec = Float(duration * 60_000)
        return Float(millisec)/durationMillisec
    }
}
