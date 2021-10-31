
import UIKit

final class BoldNormalLabel{
    static func boldNormalText(_ bold: String, _ bSize: CGFloat, _ normal: String,_ nSize:CGFloat) -> NSAttributedString?{
        
        let attrs = [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Bold, size: bSize)]
        let attributedString = NSMutableAttributedString(string:bold, attributes:attrs)

        let attr = [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Light, size: nSize)]
        let normalString = NSMutableAttributedString(string:normal, attributes:attr)
        attributedString.append(normalString)
               
       return attributedString
    }
    
    
}
