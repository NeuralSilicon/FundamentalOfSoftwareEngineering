
import UIKit

protocol ReserveVCDelegate:AnyObject {
    func finishedRegisteration()
}

class ReserveVC: UIViewController, UIScrollViewDelegate, ReserveVCDelegate, StateDelegate {
    func selectedStated(with abbreviation: String) {
        billingView.registerationForm.state.text = " " + abbreviation
    }
    
    func finishedRegisteration() {
        DispatchQueue.global(qos: .background).async {
            DatabaseStack.shared.DownloadUserInfo()
        }
        self.alert("Afte your reservation Please sign out and sign back in")
        self.model.isGuest = false
        self.model.uuid = UserDefaults.standard.value(forKey: "uuid") as! String
        self.promptReservationForm()
    }
        
    var scrollView:UIScrollView={
        let scroll = UIScrollView(frame: UIScreen.main.bounds)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isScrollEnabled = true
        scroll.clipsToBounds = true
        scroll.backgroundColor = .systemBackground
        return scroll
    }()
    
    var titleLabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .left, fontSize: 25, font: .AppleSDGothicNeo_SemiBold)
        label.text = "Make Reservation"
        return label
    }()
    
    var back:UIButton={
        let back = UIButton()
        back.Button(text: "")
        back.setImage(UIImage(systemName: "xmark")?.applyingSymbolConfiguration(.init(pointSize: 25, weight: .regular)), for: .normal)
        back.backgroundColor = .clear
        back.tintColor = .white
        return back
    }()
 
    var dateLabel:LabelView={
        let view = LabelView(frame: .zero)
        view.label.text = "When:"
        view.isUserInteractionEnabled = true
        return view
    }()
    var dateView:DateView={
        let view = DateView()
        return view
    }()
    
    var underNameLabel:LabelView={
        let view = LabelView(frame: .zero)
        view.label.text = "Who:"
        view.isUserInteractionEnabled = true
        return view
    }()
        
    var reservationForm:ReserveForm={
        let view = ReserveForm(frame: .zero)
        return view
    }()
    
    var payment:LabelView={
        let view = LabelView(frame: .zero)
        view.label.text = "Credit Card:"
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var billingView:BillingView={
        let billing = BillingView(frame: .zero)
       return billing
    }()
    
    var reserveIt:UIButton={
        let button = UIButton()
        button.Button(text: "Reserve")
        return button
    }()
        
    var wrapUp:WrapUp={
        let wrap = WrapUp(frame: .zero)
        return wrap
    }()
    
    
    var isDateViewOpen:Bool = false
    var isCreditCardNeeded:Bool = false
    var isBillingSameAsAddress:Bool = true
    var model:DinerModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addSubviews()
        fetchDinerInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.setScrollViewHeight()
    }
    
}

extension UIScrollView{
    func setScrollViewHeight(){
        let contentRect: CGRect = self.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
}
