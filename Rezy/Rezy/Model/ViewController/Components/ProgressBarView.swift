
import UIKit

class ProgressBarView: UIView{
    
    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    var gradientLayer2 = CAGradientLayer()
    
    
    public func animateCircle(){
        gradientLayer2.mask = progressLayer
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.35
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.gradientLayer2.add(rotation, forKey: "rotationAnimation")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func simpleShape()
    {
        createCirclePath()
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 10.0
        shapeLayer.strokeEnd = 1.0
        shapeLayer.strokeColor = UIColor.systemGray6.cgColor
        layer.addSublayer(shapeLayer)
        
        gradientLayer2.frame = bounds
        gradientLayer2.colors = [UIColor.systemRed.cgColor, UIColor.systemRed.cgColor]
        gradientLayer2.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer2.endPoint = CGPoint(x: 1, y: 0)
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 9
        progressLayer.fillColor =  UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.3
        
        layer.addSublayer(gradientLayer2)
    }
    
    private func createCirclePath()
    {
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        bgPath.addArc(withCenter: center, radius: x/CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat(6.28), clockwise: true)
        bgPath.close()
    }
    
    public func centerPoint()-> CGPoint{
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x - 50 , y: y - 25)
        return center
    }
    
}
