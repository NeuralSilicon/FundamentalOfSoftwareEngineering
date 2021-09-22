
import UIKit
import Firebase

class SearchDiners: UIViewController {
    
    let cellid:String = "SearchCell"
    
    var tableView:UITableView={
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.layer.cornerRadius = .cornerRadius
        table.layer.masksToBounds = true
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var searchField:TextField={
        let text = TextField()
        text.placeholder = "Search by address"
        text.textColor = .white
        text.keyboardType = .default
        text.returnKeyType = .done
        text.textAlignment = .left
        return text
    }()
    
    var button:UIButton={
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle.fill")?.applyingSymbolConfiguration(.init(pointSize: 25, weight: .medium))?.withTintColor(.white), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        return button
    }()
    
    let storage = Storage.storage()
    let imageCache = NSCache<NSString, AnyObject>()
    var diners = [Diner]()
    var filter = [Diner]()
    var searchisActive:Bool = false
    var showSkeleton:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addsubviews()
    }
}

extension SearchDiners:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        let currentCharacterCount = text.count
        
        let newLength = currentCharacterCount + string.count - range.length
        if newLength != 0{
            let newText = (text + string).lowercased().replacingOccurrences(of: " ", with: "")
            searchisActive = true
            let predicate = NSPredicate(format: "SELF CONTAINS %@", newText)
            self.filter = self.diners.filter({ diner in
                predicate.evaluate(with: diner.address?.components(separatedBy:",")[0].lowercased().replacingOccurrences(of: " ", with: ""))
            })
            self.tableView.reloadData()
        }else{
            searchisActive = false
            self.tableView.reloadData()
        }
        return true
    }
}

