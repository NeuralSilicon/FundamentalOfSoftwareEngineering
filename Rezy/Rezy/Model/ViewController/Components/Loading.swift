import UIKit

class Loading: UIView{
    
    fileprivate var bgPath: UIBezierPath!
    fileprivate var progressLayer: CAShapeLayer!

    public func updateColor(){
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            self.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
            
            self.progressLayer.fillColor = UIColor.black.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
        CreateShape()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func CreateShape()
    {
        self.isHidden = true
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 5, height: 10)
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        
        createCirclePath()
        
        let imageLayer = CALayer()
        if #available(iOS 13.0, *) {
            imageLayer.contents = UIImage(named:"Circle.png")?.applyingSymbolConfiguration(.init(pointSize: 50, weight: .bold))?.cgImage
        } else {
            imageLayer.contents = UIImage(named:"Circle.png")?.cgImage
        }
        imageLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 30))
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.frame = CGRect(origin: CGPoint(x: 5, y: 5), size: CGSize(width: 30, height: 30))
        progressLayer.lineWidth = 10
        progressLayer.mask = imageLayer

        
        self.layer.addSublayer(progressLayer)
    }
    
    private func createCirclePath()
    {
        let center = CGPoint(x: 0, y: 0)
        bgPath.addArc(withCenter: center, radius: 25, startAngle: CGFloat(0), endAngle: CGFloat(6.28), clockwise: true)
        bgPath.close()
    }
    
    public func animateCircle(){
        self.isHidden = false
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.4
        rotation.isCumulative = true
        rotation.repeatCount = .infinity
        self.progressLayer.add(rotation, forKey: "rotationAnimation")
    }
    
    public func removeAnimation(){
        self.progressLayer.removeAllAnimations()
        self.isHidden = true
    }
    
    
    public func animateCircle(with Count:Float){
        self.isHidden = false
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.4
        rotation.isCumulative = true
        rotation.repeatCount = Count
        progressLayer.add(rotation, forKey: "rotationAnimation")
    }
}

