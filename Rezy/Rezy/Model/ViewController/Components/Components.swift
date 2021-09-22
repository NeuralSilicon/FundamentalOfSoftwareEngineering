
import UIKit

extension NSNotification.Name{
    static let SignOut = NSNotification.Name("SignOut")
}

extension Double{
    var toString:String{
        return String(describing: self)
    }
}

extension String {
    func toDouble() -> Double{
        return NumberFormatter().number(from: self)?.doubleValue ?? 0
    }
    static let firebase = "abc"
    static let firebaseStorage = "abc"
    
    func stringToDict()->[String:Int]{
        var table = [String:Int]()
        for i in self{
            let k = self.filter({$0 == i})
            table[String(i)] = k.count
        }
        return table
    }

}

extension Dictionary{
    func dictToString() -> String{
        var str = ""
        let dict = self as! [String:Int]
        for (key, value) in dict{
            for _ in 0..<value{
                str.append(String(key))
            }
        }
        
        return str
    }
    
    func dictToTable() -> String{
        let dict = self as! [String:Int]
        var str = ""
        for (key, value) in dict.sorted(by: {$0.key < $1.key}){
            str.append("Table Number \(key) : Reserved \(value)\n")
        }
        return str
    }
}

extension UILabel{
    func Label(textColor:UIColor, textAlignment: NSTextAlignment, fontSize:CGFloat, font:UIFont.Custom){
        self.text = ""
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.font = UIFont.custom(type: font,
                                  size: UIDevice.current.userInterfaceIdiom == .pad ?
                                  fontSize + 2:
                                  fontSize
                                  )
    }
    
}

extension UIView{
    
    //Push transition is for showing uilabel
    func pushTransition(_ duration:CFTimeInterval, direction:CATransitionSubtype) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = direction
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    func Shadow(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 0.3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func screenshot() -> UIImage {
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size: bounds.size).image { _ in
                drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
            drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            UIGraphicsEndImageContext()
            return image
        }
    }
}

extension UIButton{
    
    func Button(text:String, _ color:UIColor = UIColor.black){
        self.setAttributedTitle(NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Bold, size: 16), NSAttributedString.Key.foregroundColor: color]), for: .normal)
        self.backgroundColor = .Indicator
        self.layer.cornerRadius = .cornerRadius
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}



extension UIImage {
    func Resize(targetSize: CGSize) -> UIImage {
         return UIGraphicsImageRenderer(size:targetSize).image { _ in
             self.draw(in: CGRect(origin: .zero, size: targetSize))
         }
     }
}



func attribute(for text:String, size:Int, font:UIFont.Custom, color:UIColor) -> NSAttributedString{
    return NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.custom(type: font, size: CGFloat(size)), NSAttributedString.Key.foregroundColor: color])
}
