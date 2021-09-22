
import UIKit
import CoreData
import Firebase

class Initialization: UIViewController {
    
    private var titleLabel:UILabel!
    private var label:UILabel!
    private var loading:Loading!
    private var queue = DispatchGroup()
    private var timer:Timer!
    private var button:UIButton!
    private var skip:UIButton!
    
    private let storage = Storage.storage()
    private var restaurants:[[String : String]]=[[:]]
    private var foods:[[String:String]]=[[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        configLoading()
        configTitle()
        loading.animateCircle()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // read the text file
        
        queue.enter()
        self.readJson()
       
        queue.notify(queue: .main) {
            self.loading.removeAnimation()
            self.label.text = ""
            self.titleLabel.text = "Application is now ready!"
            self.titleLabel.pushTransition(1.0, direction: .fromTop)
            self.skip.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
            UserDefaults.standard.setValue(true, forKey: "First")
        }

    }
    
    
    private func configTitle(){
        titleLabel = UILabel()
        titleLabel.text = "Preparing the Application..."
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        view.layoutIfNeeded()
        
        label = UILabel()
        label.text = "This would just take a few seconds."
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: loading.topAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        view.layoutIfNeeded()
                
        
        skip = UIButton()
        skip.backgroundColor = .black
        skip.setAttributedTitle(NSAttributedString(string: "Done", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15, weight: .regular)]), for: .normal)
        skip.tintColor = .white
        skip.layer.cornerRadius = 15
        skip.layer.masksToBounds = true
        skip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skip)
        NSLayoutConstraint.activate([
            skip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            skip.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 150),
            skip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skip.heightAnchor.constraint(equalToConstant: 60),
        ])
        skip.addTarget(self, action: #selector(skipPage), for: .touchUpInside)
        view.layoutIfNeeded()
        
    }

    @objc func skipPage(){
        self.skip.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: 0.5) {
            self.skip.transform = .identity
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }
        let vc = LoginVC()
        vc.modalPresentationStyle = .overFullScreen
        let navig = UINavigationController(rootViewController: vc)
        navig.modalPresentationStyle = .overFullScreen
        navig.navigationBar.isHidden = true
        self.present(navig, animated: true, completion: nil)
    }
    
    
    private func readJson(){
        let group = DispatchGroup()
        group.enter()
        do {
            if let file = Bundle.main.url(forResource: "restaurants", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.restaurants = json as? [[String : String]] ?? [[:]]
            }
        } catch {
             print("Error info: \(error)")
        }
        
        do {
            if let file = Bundle.main.url(forResource: "Foods", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.foods = json as? [[String : String]] ?? [[:]]
            }
        } catch {
             print("Error info: \(error)")
        }
        
        for (i, j) in self.restaurants.enumerated(){
            let storageRef = self.storage.reference().child("\(j["name"]!).jpg")
            storageRef.downloadURL { url, error in
              if let error = error {
                 print(error as Any)
              } else {
                guard let url = url else {
                    return
                }
                self.restaurants[i]["url", default: ""] = url.absoluteString
              }
            }
            if i == self.restaurants.count - 1{
                group.leave()
            }
        }
   
        group.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                for i in self.restaurants{
                    self.saveToCoreData(dict: i)
                }
                
                for i in self.foods{
                    self.saveFoods(dict: i)
                }
                
                self.queue.leave()
            }
        }
    }
    

    private func saveToCoreData(dict:[String:String]){
      
        let diner = Diner(context: CoreDataStack.shared.managedObjectContext)
        diner.dinerUUID = UUID.init()
        diner.name = dict["name"]
        diner.address = dict["address"]
        diner.url = dict["url"]
        diner.table = dict["table"]
        diner.reviews = dict["reviews"]
                
        CoreDataStack.shared.saveContext()
    }
    
    private func saveFoods(dict:[String:String]){
      
        let food = Food(context: CoreDataStack.shared.managedObjectContext)

        food.name = dict["name"]
        food.price = dict["price"]
        food.img = dict["img"]
        food.descriptions = dict["description"]
        
        CoreDataStack.shared.saveContext()
    }
    
    private func configLoading(){
        self.loading = Loading(frame: CGRect(origin: CGPoint(x: self.view.center.x - 20
                                                             , y: self.view.center.y - 20)
                                             , size: CGSize(width: 40, height: 40)))
        self.view.addSubview(self.loading)
        self.loading.updateColor()
        
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40)
        ])
        self.view.layoutIfNeeded()
    }
}


