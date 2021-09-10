
import PassKit

extension ReservationInfo: PKAddPassesViewControllerDelegate{

    @objc func loadWalletView() {
        if !PKPassLibrary.isPassLibraryAvailable() {
            let alert = UIAlertController(title: "Error", message: "PassKit not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    break
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        let resourcePath : String? = Bundle.main.resourcePath

        do {
            let passFiles : NSArray = try FileManager.default.contentsOfDirectory(atPath: resourcePath!) as NSArray
            for  passFile in passFiles {

                let passFileString = passFile as! String
                if passFileString.hasSuffix(".pkpass") {
                    openPassWithName(passName: passFileString)
                }
            }

        }catch {
            print(error.localizedDescription)
        }
    }

    func openPassWithName(passName : String) {
        print(passName)

        let passFile = Bundle.main.resourcePath?.appending("/\(passName)")
        let passData = NSData(contentsOfFile: passFile!)

        do {
            let newpass = try PKPass.init(data: passData! as Data)
            let addController =  PKAddPassesViewController(pass: newpass)
            addController?.delegate = self
            self.present(addController!, animated: true)
        } catch {
            let alert = UIAlertController(title: "Error", message: "PassKit not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    break
                }}))
            self.present(alert, animated: true, completion: nil)

            print(error)
        }
    }
    
    
}
