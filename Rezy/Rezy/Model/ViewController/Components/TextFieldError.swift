import UIKit

/*
 copyright :
 https://stackoverflow.com/users/15963166/ankit-bansal
 https://stackoverflow.com/questions/30574484/displaying-validation-error-on-ios-uitextfield-similar-to-androids-textview-set
 */


extension UITextField {


    /**
    this function adds a right view on the text field
    */


    func addRightView(rightView: String, tintColor: UIColor? = nil, errorMessage: String? = nil) {
        if rightView != "" {
            let rightview = UIButton(type: .custom)
            
            if tintColor != nil {
                let templateImage = UIImage(named: rightView)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                rightview.setImage(templateImage, for: .normal)
                rightview.tintColor = tintColor
            }
            else{
                rightview.setImage(UIImage(named: rightView), for: .normal)
            }
            
            if let message = errorMessage {
                rightview.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 5, right: 0)
                showErrorView(errorMessage: message)
            } else {
                rightview.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            }
            
            self.rightViewMode = .always
            self.rightView = rightview
        }
        else{
            self.rightView = .none
            for vw in self.subviews where vw.tag == 1000 {
                vw.removeFromSuperview()
            }
        }
    }

    /**
     this function add custom alert as a right view on the text field
     */

    private func showErrorView(errorMessage: String) {
        
        let containerVw = UIView(frame: CGRect(x: self.frame.origin.x, y: 30, width: self.frame.size.width - 25, height: 45))
        containerVw.backgroundColor = .clear
        containerVw.tag = 1000
        
        let triangleVw = UIButton(frame: CGRect(x: 25, y: 0, width: 15, height: 15))
        triangleVw.isUserInteractionEnabled = false
        triangleVw.setImage(UIImage(systemName: "arrowtriangle.up.fill")?.applyingSymbolConfiguration(.init(pointSize: 15, weight: .bold)), for: .normal)
        triangleVw.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        triangleVw.tintColor = .red
        
        let messageVw = UIView(frame: CGRect(x: containerVw.frame.origin.x, y: triangleVw.frame.maxY - 2, width: containerVw.frame.width, height: 35))
        messageVw.backgroundColor = UIColor.red
        
        let errorLbl = UILabel(frame: CGRect(x: 0, y: 2, width: messageVw.frame.size.width, height: messageVw.frame.size.height - 2))
        errorLbl.backgroundColor = .systemGray6
        errorLbl.numberOfLines = 2
        messageVw.addSubview(errorLbl)
        errorLbl.text = errorMessage
        errorLbl.textColor = .white
        errorLbl.textAlignment = .center
        errorLbl.font = UIFont.custom(type: .AppleSDGothicNeo_Bold, size: 14)
        
        containerVw.addSubview(triangleVw)
        containerVw.sendSubviewToBack(triangleVw)
        containerVw.addSubview(messageVw)
        containerVw.layoutIfNeeded()
        
        self.addSubview(containerVw)
        self.bringSubviewToFront(containerVw)
    }
}
