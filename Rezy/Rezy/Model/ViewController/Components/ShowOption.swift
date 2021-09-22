
import UIKit

protocol OptionDelegate:AnyObject {
    func index(for index:Int)
}

class ShowOption: UIView {
    
    weak var delegate:OptionDelegate?
    var containerView:UIView={
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.layer.cornerRadius = .cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    var sublabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .Light, textAlignment: .center, fontSize: 15, font: .AppleSDGothicNeo_Light)
        return label
    }()
    var options:[String] = []
    var labels:[UILabel]=[]
    var selectedIndex:Int = 0
    var imgs:[UIImageView]=[]
    var hstack:[UIStackView]=[]
    var showSelection:Bool = false
    
    ///Pan Gesture
    var gesture = UIPanGestureRecognizer()
    ///Initial position of tableView
    var trayOriginalCenter: CGPoint! ///original tableview position
    var trayDownOffset: CGFloat! ///how much our tableview can be moved up
    var trayUp: CGPoint! ///moving tableview up
    var trayDown: CGPoint! ///moving tableview down
    
    
    deinit {
        options = []; labels = []
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func viewAppeared(){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, options: .beginFromCurrentState) {
            self.backgroundColor = UIColor.Dark.withAlphaComponent(0.2)
            self.containerView.transform = .identity
        }
        
        self.trayDownOffset = self.containerView.bounds.height
        self.trayUp = self.containerView.center
        self.trayDown = CGPoint(x: self.containerView.center.x ,y: self.containerView.center.y + self.trayDownOffset)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if !containerView.frame.contains(location){
                self.dimissPage()
            }
        }
    }

    //MARK: -Dragged
    @objc func wasDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
        let velocity = gestureRecognizer.velocity(in: self)

        if gestureRecognizer.state == .began {
            trayOriginalCenter = self.containerView.center
            
        } else if gestureRecognizer.state == .changed {
            if translation.y > 0{
                self.containerView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            }
                    
        } else if gestureRecognizer.state == .ended {
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                    self.containerView.center = self.trayDown
                    self.backgroundColor = .clear
                }) { (_) in
                    self.deinitPage()
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                    self.containerView.center = self.trayUp
                }, completion: nil)
            }
        }
    }
}


extension ShowOption{
    
    func deinitPage(){
        UIView.animate(withDuration: 0.1, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        }, completion: { _ in
            
            self.options = []; self.labels = []; self.imgs = []
            
            for subview in self.subviews{
                subview.removeFromSuperview()
            }
            
            if let view = self.superview{
                view.sendSubviewToBack(self)
            }
        })
    }
}
