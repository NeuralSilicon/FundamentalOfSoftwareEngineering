//
//import UIKit
//
//class TimeView: UIView {
//    
//    var nums = [String]()
//    var selected=IndexPath()
//    let cellid = "CollectionID"
//    var collectionView:UICollectionView={
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: 60, height: 60)
//        let collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
//        collection.backgroundColor = .clear
//        collection.layer.cornerRadius = .cornerRadius
//        collection.layer.masksToBounds = true
//        collection.translatesAutoresizingMaskIntoConstraints = false
//        return collection
//    }()
//    
//    weak var parentPage:UIViewController!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addsubviews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func addsubviews(){
//        self.layer.cornerRadius = .cornerRadius
//        self.layer.masksToBounds = true
//        self.translatesAutoresizingMaskIntoConstraints = false
//        self.backgroundColor = .systemBackground
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(TimeViewCell.self, forCellWithReuseIdentifier: cellid)
//        self.addSubview(collectionView)
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//        ])
//        for i in 0...23{
//            nums.append("\(i)-\(i+1)")
//        }
//    }
//}
//
//extension TimeView:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 24
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as? TimeViewCell{
//            cell.label.text = nums[indexPath.row]
//            if indexPath == selected{
//                cell.label.textColor = .red
//            }else{
//                cell.label.textColor = .Dark
//            }
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.frame.width/6, height: self.frame.width/6)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
//        UIView.animate(withDuration: 0.5) {
//            cell?.transform = .identity
//        }
//        if let parent = self.parentPage as? ReserveVC{
//            parent.model.reservation.time = nums[indexPath.row]
//            parent.showAvailableTable()
//            selected = indexPath
//            
//            deselectAll()
//            if let cell = collectionView.cellForItem(at: indexPath) as? TimeViewCell{
//                cell.label.textColor = .red
//            }
//        }
//    }
//    
//    func deselectAll(){
//        for indexPath in collectionView.indexPathsForVisibleItems{
//            if let cell = collectionView.cellForItem(at: indexPath) as? TimeViewCell{
//                cell.label.textColor = .Dark
//            }
//        }
//    }
//}
//
//
//class TimeViewCell: UICollectionViewCell {
//    
//    var label:UILabel={
//        let label = UILabel()
//        label.Label(textColor: .Dark, textAlignment: .center, fontSize: 20, font: .AppleSDGothicNeo_Regular)
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.addsubviews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func addsubviews(){
//        self.backgroundColor = .clear
//        self.contentView.backgroundColor = .clear
//        
//        self.addSubview(label)
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: self.topAnchor),
//            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//        ])
//    }
//    
//}
