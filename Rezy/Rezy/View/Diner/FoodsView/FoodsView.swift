
import UIKit

class FoodsView: UIView {
    
    var foods:[Food] = []
    
    var selected=IndexPath()
    let cellid = "CollectionID"
    var collectionView:UICollectionView={
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.layer.cornerRadius = .cornerRadius
        collection.layer.masksToBounds = true
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    weak var parentPage:UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addsubviews(){
        self.layer.cornerRadius = .cornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = .systemGray6
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FoodsViewCell.self, forCellWithReuseIdentifier: cellid)
        self.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: .topConstant),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .bottomConstant),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .rightConstant)
        ])
        fetchFoods()
    }
    
    fileprivate func fetchFoods(){
        DispatchQueue.global(qos: .background).async{
            FoodStack.shared.Fetch(entity: .food) { foods in
                self.foods = foods
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
                }
            }
        }
    }
}

extension FoodsView:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as? FoodsViewCell{
            guard let img = UIImage(named: foods[indexPath.row].img ?? "") else {
                return cell
            }
            
            cell.image.image = img.Resize(targetSize: CGSize(width: img.size.width*0.13, height: img.size.height*0.13))
            
            if indexPath == selected{
                cell.backgroundColor = .systemBackground
            }else{
                cell.backgroundColor = .clear
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.3) {
            cell?.transform = .identity
        }
        if let parent = self.parentPage as? DinerVC{
            parent.loadFoodInfo(food: foods[indexPath.row])
        }
    }

}


class FoodsViewCell: UICollectionViewCell {
    
    var image:UIImageView={
        let img = UIImageView()
        img.backgroundColor = .clear
        img.layer.cornerRadius = .cornerRadius
        img.layer.masksToBounds = true
        img.contentMode = .center
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
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
            image.topAnchor.constraint(equalTo: self.topAnchor),
            image.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}
