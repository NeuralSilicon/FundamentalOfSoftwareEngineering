
import UIKit
import PassKit

class ReservationInfo: UIViewController {
    
    var scrollView:UIScrollView={
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.backgroundColor = .clear
        scrollView.clipsToBounds = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var cardView:UIView={
       let view = UIView()
        view.layer.cornerRadius = .cornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellid:String = "ReservationInfoCell"
    var collectionView:UICollectionView={
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collection.backgroundColor = .black
        collection.layer.cornerRadius = .cornerRadius
        collection.layer.masksToBounds = true
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    

    var label:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .left, fontSize: 20, font: .AppleSDGothicNeo_Regular)
        return label
    }()
    
    var image:UIImageView={
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var close:UIButton={
        let button = UIButton()
        button.Button(text: "")
        button.setImage(UIImage(systemName: "xmark")?.applyingSymbolConfiguration(.init(pointSize: 20, weight: .regular)), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        return button
    }()
    
    var more:UIButton={
        let button = UIButton()
        button.Button(text: "")
        button.setImage(UIImage(systemName: "ellipsis")?.applyingSymbolConfiguration(.init(pointSize: 20, weight: .light)), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        return button
    }()
    
    var passButton:PKAddPassButton={
        let button =  PKAddPassButton(addPassButtonStyle: PKAddPassButtonStyle.blackOutline)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var option:ShowOption!
    
    var img:UIImage!
    var address:String!
    var reservation:Reservation!
    weak var parentPage:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addsubviews()
    }
    
}
extension ReservationInfo:OptionDelegate{
    func index(for index: Int) {
        switch index {
        case 0:
            self.shareScreenShot()
            break
        case 1:
            self.askUserForCancellation()
            break
        default:
            break
        }
    }
    
    func askUserForCancellation(){
        let alertController = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { _ in
            
            ReservationHandler.shared.DeleteReservation(with: self.reservation.reservationUUID)
            ReservationHandler.shared.group.notify(queue: .main) {

                TimeStack.shared.FetchWithID(entity: .time, id: .timeUUID, uuid: UUID.init(uuidString: self.reservation.timeUUID) ??  UUID.init()) { times in
                    if let time = times.first{
                        var table = time.table?.stringToDict()
                        let usertable = self.reservation.table.stringToDict()
                        for (key, value) in usertable{
                            table?[key, default:0] += value
                        }
                        time.table = table?.dictToString()
                        if let range = time.reservationsUUID?.range(of: self.reservation.reservationUUID){
                            time.reservationsUUID?.removeSubrange(range)
                        }
                        CoreDataStack.shared.saveContext()
                        
                        self.dismiss(animated: true) {
                            if let parent = self.parentPage as? ReservedVC{
                                parent.fetchDiners()
                            }
                        }
                    }
                }
            }
        }
        let no = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(yes); alertController.addAction(no)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func shareScreenShot(){
        var imagesToShare = [AnyObject]()
        imagesToShare.append(self.collectionView.screenshot())
        self.FlashView()
        let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }

    func FlashView(){
        if let wnd = self.view{
            let v = UIView(frame: wnd.bounds)
            v.backgroundColor = .white
            v.alpha = 1
            wnd.addSubview(v)
            UIView.animate(withDuration: 1, animations: {
                v.alpha = 0.0
            }, completion: {(finished:Bool) in
                v.removeFromSuperview()
            })
        }
    }
}


extension ReservationInfo:UIScrollViewDelegate{
    
    func addsubviews(){
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
        scrollView.delegate = self
        scrollView.layer.cornerRadius = .cornerRadius
        
        scrollView.addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: scrollView.topAnchor),
            image.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            image.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 150)
        ])
        image.image = img
        
        scrollView.addSubview(close)
        NSLayoutConstraint.activate([
            close.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .topConstant),
            close.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant*2),
            close.heightAnchor.constraint(equalToConstant: 40),
            close.widthAnchor.constraint(equalToConstant: 40)
        ])
        close.addTarget(self, action: #selector(dimiss), for: .touchUpInside)
        
        scrollView.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: .topStandAloneConstant),
            cardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant*2),
            cardView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant + .rightConstant),
            cardView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        cardView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cardView.topAnchor, constant: .topConstant*2),
            label.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .leftConstant),
            label.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: .rightConstant),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        label.text = "Your Reservation:"
        
        cardView.addSubview(more)
        NSLayoutConstraint.activate([
            more.topAnchor.constraint(equalTo: cardView.topAnchor, constant: .topConstant*2),
            more.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: .leftConstant),
            more.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: .rightConstant),
            more.heightAnchor.constraint(equalToConstant: 20),
            more.widthAnchor.constraint(equalToConstant: 30)
        ])
        more.transform = CGAffineTransform(rotationAngle: .pi/2)
        more.addTarget(self, action: #selector(showOption), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReservationInfoCell.self, forCellWithReuseIdentifier: cellid)
        cardView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .topConstant*2),
            collectionView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: .bottomConstant),
            collectionView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .leftConstant),
            collectionView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: .rightConstant),
            collectionView.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.44)
        ])
        
        scrollView.addSubview(passButton)
        NSLayoutConstraint.activate([
            passButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: .topConstant),
            passButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            passButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant*2),
            passButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant + .rightConstant),
            passButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        passButton.addTarget(self, action: #selector(loadWalletView), for: .touchUpInside)
        
    }
        
    @objc private func showOption(){
        //delete the reservation
        
        option = ShowOption(frame: UIScreen.main.bounds)
        option.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(option)
        NSLayoutConstraint.activate([
            option.topAnchor.constraint(equalTo: view.topAnchor),
            option.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            option.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            option.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        option.options = ["Share","Cancel your reservation"]
        option.sublabel.text = "You may share this card to the Guest(s)."
        option.showSelection = false
        option.delegate = self
        option.configOption()
        option.viewAppeared()
    }
    
    @objc private func dimiss(){
        self.dismiss(animated: true, completion: nil)
    }

}

extension ReservationInfo:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as? ReservationInfoCell{
            
            cell.image.image = UIImage(systemName: ["person.fill","phone.fill","location.north.fill","clock.fill","person.3.fill","creditcard.fill"][indexPath.row])?.applyingSymbolConfiguration(.init(pointSize: 25 , weight: .light))
            
            cell.titleLabel.text = ["Who?","What?","Where?","When?","With?","Charge?"][indexPath.row]
            cell.valueLabel.text =  ["\(reservation.fullname)"
                                     , "\(reservation.phoneNumber)"
                                     , "\(address!)"
                                     ,"\(reservation.time)\n\(reservation.date)"
                                     ,"\(reservation.numberOfGuest)"
                                     ,"\(reservation.noShowCharge ? "Yes" : "No")"][indexPath.row]
            
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}


class ReservationInfoCell: UICollectionViewCell {
    
    var image:UIImageView={
        let img = UIImageView()
        img.backgroundColor = .systemGray6
        img.layer.cornerRadius = 38
        img.layer.masksToBounds = true
        img.contentMode = .center
        img.tintColor = .white
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    var titleLabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .Light, textAlignment: .center, fontSize: 16, font: .AppleSDGothicNeo_Light)
        return label
    }()
    
    var valueLabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .center, fontSize: 16, font: .AppleSDGothicNeo_Light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addsubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addsubviews(){
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 80),
            image.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: .topConstant),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .leftConstant),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .rightConstant),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
}
