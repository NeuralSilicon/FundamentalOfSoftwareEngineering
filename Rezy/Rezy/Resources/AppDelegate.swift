
import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1)
        FirebaseApp.configure()
        self.launchOptions()
        return true
    }
    
    private func launchOptions(){
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        
        guard UserDefaults.standard.value(forKey: "First") != nil else {
            let vc = Initialization()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            return
        }
        
        guard UserDefaults.standard.value(forKey: "loggedin") != nil else {
            let vc = LoginVC()
            let navig = UINavigationController(rootViewController: vc)
            navig.navigationBar.isHidden = true
            window?.rootViewController = navig
            window?.makeKeyAndVisible()
            return
        }
        
        let vc = Tabbar()
        let navig = UINavigationController(rootViewController: vc)
        navig.navigationBar.isHidden = true
        window?.rootViewController = navig
        window?.makeKeyAndVisible()

    }
}
