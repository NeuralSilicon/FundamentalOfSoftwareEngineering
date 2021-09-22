
import UIKit

extension Home{
    
    func addsubviews(){

        view.addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(topview)
        NSLayoutConstraint.activate([
            topview.topAnchor.constraint(equalTo: view.topAnchor),
            topview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant*4),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        view.addSubview(search)
        NSLayoutConstraint.activate([
            search.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            search.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            search.widthAnchor.constraint(greaterThanOrEqualToConstant: 240),
            search.heightAnchor.constraint(equalToConstant: 40),
        ])
        search.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSearch)))
        
        search.addSubview(searchLabel)
        NSLayoutConstraint.activate([
            searchLabel.topAnchor.constraint(equalTo: search.topAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: search.leadingAnchor),
            searchLabel.trailingAnchor.constraint(equalTo: search.trailingAnchor),
            searchLabel.bottomAnchor.constraint(equalTo: search.bottomAnchor)
        ])
    }
    
    
    @objc private func openSearch(){
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        search.transform = CGAffineTransform(scaleX: 1.2, y:  1.2)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .allowUserInteraction) {
            self.search.transform = .identity
        } completion: { _ in
            if let parent = self.parentVC{
                let vc = SearchDiners()
                let navig = UINavigationController(rootViewController: vc)
                navig.navigationBar.isHidden = true
                navig.modalPresentationStyle = .overFullScreen
                parent.present(navig, animated: true, completion: nil)
            }
        }
    }
}
