
//sayra(:
import UIKit
//validation for user iput
class Validation {
    
    enum Fields:String { //info that user will enter for their account
        case username = "Email Address";
        case password = "Password";
        case fullname = "Fullname";
        case addressLineOne  = "AddressLineOne";
        case addressLineTwo = "AddressLineTwo"
        case city = "City";
        case state = "State";
        case zipcode = "Zipcode";
    }

    
    func checkvalidation(client:Client?,address:Address?,parent:UIViewController,completed:@escaping(Bool)-> Void){ 
        let cases:[Fields] = [.fullname,.addressLineOne,.addressLineTwo,.city,.state,.zipcode]
        for (i, field) in cases.enumerated(){
            if !validateformtextFields(fields: field, client:client, address:address){
                let activity = UIAlertController(title: nil, message: "\(field.rawValue) is either empty or not valid!", preferredStyle: .alert)
                activity.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                parent.present(activity, animated: true, completion: nil)
                completed(false)
                break
            }
            if i == cases.count - 1{
                completed(true)
            }
        }
    }
    
    //validate information entered by user
    func validateformtextFields(fields:Fields, client:Client?, address:Address?)->Bool{ 
        
        switch fields { //switch cases for each textfield
        case .username:
            let predicate = NSPredicate(format: "SELF MATCHES %@"
                                        , "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}") //checks if username contains special characters and is 2-20 chars long
            return (client?.username == "" ? false : (predicate.evaluate(with: client?.username)))
        case .password:
            let predicate = NSPredicate(format: "SELF MATCHES %@"
                                        , "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[!@#$&*%]).{6,12}$") //checks if password contains special characters and is 6-12 chars long
            return (client?.password == "" ? false : (predicate.evaluate(with: client?.password)))
        case .fullname:
            return client?.fullname == "" ? false : true
        case .addressLineOne:
            return address?.addressLineOne == "" ? false : address?.addressLineOne.count ?? 0 <= 100
        case .addressLineTwo:
            return address?.addressLineTwo.count ?? 0 <= 100
        case .city:
            return address?.city == "" ? false : true
        case .state:
            return address?.state == "" ? false : address?.state.count == 2
        case .zipcode:
            return address?.zipcode == "" ? false : (address?.zipcode.count ?? 0 >= 5 && address?.zipcode.count ?? 0 < 9)
        }
    }
}

