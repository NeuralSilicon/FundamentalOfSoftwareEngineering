
import UIKit
import Firebase

class Home: UIViewController {
    
    var topview:UIView={
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    var image:UIImageView={
        let img = UIImageView()
        img.image = UIImage(named: "Burger")?.Resize(targetSize: UIScreen.main.bounds.size)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
        
    var label:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .center, fontSize: 40, font: .AppleSDGothicNeo_Regular)
        label.text = "Rezy"
        return label
    }()
    
    var search:UIView={
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = .cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
       return view
    }()
    
    var searchLabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .black, textAlignment: .center, fontSize: 18, font: .AppleSDGothicNeo_SemiBold)
        label.text = "   Feel the Power"
        let img = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.black).applyingSymbolConfiguration(.init(pointSize: 20, weight: .regular)))
        img.tintColor = .black
        img.frame = CGRect(x: 10, y: 10, width: 23, height: 20)
        label.addSubview(img)
        return label
    }()

    weak var parentVC:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addsubviews()
        loadUserInfoAsync()
    }
    
    func loadUserInfoAsync(){
        DispatchQueue.global(qos: .background).async {
            DatabaseStack.shared.DownloadUserInfo()
        }
    }
        
}


