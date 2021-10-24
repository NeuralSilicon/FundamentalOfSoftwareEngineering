//sayra(:
import UIKit

extension UIViewController {
    func alert(_ title:String="",_ messsage:String=""){
     
        // title:title - presents title of message
        //message:message - present message below title
       // preferredStyle: .alert - shows the textboc in the middle of screen
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: .alert) 

        alert.addAction(UIAlertAction(title: "OK", style: .cancel)) //adds action to button {ok}

        self.present(alert, animated: true, completion: nil) 	//shows alert 
    }
}
