//sayra(:

import UIKit

class PrivacyVC: UIViewController {
    var TextView: UITextView={
        let TextView = UITextView()
        TextView.translatesAutoresizingMaskIntoConstraints = false //false - Auto Layout to dynamically calculate the size and position of your view
        TextView.isUserInteractionEnabled = true // true - events are delivered to the view
        TextView.isEditable = false // text view cant be edited
        TextView.backgroundColor = .clear
        TextView.layoutIfNeeded() // force the view to update its layout immediately
        TextView.textColor = .Dark
        TextView.setContentOffset(CGPoint.zero, animated: false) //sets offset distance between content and browser origin, animated- false - change takes place immediately
        return TextView
    }()
    
    var titleLabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .center, fontSize: 30, font: .AppleSDGothicNeo_Light)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        addsubview()
    }

    //privavy title
    private func addsubview(){
        
        titleLabel.text = "Privacy"
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: .topStandAloneConstant),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: .leftConstant),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: .rightConstant),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        self.view.addSubview(TextView)
        NSLayoutConstraint.activate([
            TextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .topStandAloneConstant),
            TextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            TextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            TextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .bottomConstant)
        ])
        //privacy statement:
        let str = "\n The application will collect certain information about it’s users to protect them against hacks and fraud. The information collected by this application are not sold to any third-parties. By using this application, you are agreeing to our privacy and agreement. \n\n THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. \n\nTo find out more about Google Privacy, "

        let attributedString = self.ReturnBoldNormalText(BoldText: "Privacy Policy and Terms of Use", NormalText: str)
        
        self.TextView.attributedText = attributedString
    }
    

    func ReturnBoldNormalText(BoldText:String,NormalText:String)->NSMutableAttributedString{
        let url = URL(string: "https://firebase.google.com/support/privacy")!
        
        let boldText  = BoldText + "\n"
        let attrs = [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Medium, size: 20),NSAttributedString.Key.foregroundColor:UIColor.Dark]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = NormalText
        let attr = [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Regular, size: 20),NSAttributedString.Key.foregroundColor:UIColor.Dark]
        let normalString = NSMutableAttributedString(string:normalText, attributes:attr)

        attributedString.append(normalString)
        //link to url
        let linkText = NSMutableAttributedString(string: "Privacy Policy and Terms of Use.", attributes: [NSAttributedString.Key.link: url,NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Medium, size: 20),NSAttributedString.Key.foregroundColor:UIColor.Dark])
        
        attributedString.append(linkText)
        
        return attributedString
    }
}
