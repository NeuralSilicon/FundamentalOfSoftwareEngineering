
import UIKit

class DinerVC: UIViewController,UIScrollViewDelegate {
    
    var model = DinerModel()
    
    var scrollView:UIScrollView={
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.backgroundColor = .clear
        scrollView.clipsToBounds = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var image:UIImageView={
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    var back:UIButton={
        let back = UIButton()
        back.Button(text: "")
        back.setImage(UIImage(systemName: "chevron.left")?.applyingSymbolConfiguration(.init(pointSize: 25, weight: .regular))?.withTintColor(.black), for: .normal)
        back.backgroundColor = .systemBackground
        back.tintColor = .white
        back.layer.cornerRadius = 35/2
        back.layer.masksToBounds = true
        return back
    }()
        
    var infoView:UIView={
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = .cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var label:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .left, fontSize: 18, font: .AppleSDGothicNeo_Light)
        return label
    }()
    
    var addressLabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .Light, textAlignment: .left, fontSize: 18, font: .AppleSDGothicNeo_Light)
        return label
    }()
    
    var makeReservation:UIButton={
       let button = UIButton()
        button.Button(text: "Make Reservation", .white)
        button.backgroundColor = .black
        return button
    }()
    
    var foodsView:FoodsView={
        let view = FoodsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var foodInfoView:FoodInfoView={
        let view = FoodInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dinerReviewView:DinerReviewView={
        let view = DinerReviewView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var img:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addsubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setScrollViewHeight()
    }
    
    
    func loadFoodInfo(food:Food){
        self.foodInfoView.updateConstraint(attribute: .height, constant: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.foodInfoView.foodInfo = food
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .allowUserInteraction, animations: {
                self.foodInfoView.updateConstraint(attribute: .height, constant: 300)
            }, completion: { _ in
                self.setScrollViewHeight()
            })
        }
    }
    
    fileprivate func setScrollViewHeight(){
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
}

extension UIView {

    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            UIView.animate(withDuration: 0.3) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
}
