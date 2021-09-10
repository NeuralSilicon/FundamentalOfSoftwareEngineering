
import UIKit

class ProgressView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createCircularPath() {

        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 50, startAngle: startPoint, endAngle: endPoint, clockwise: true)

        circleLayer.path = circularPath.cgPath

        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 10.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.black.cgColor

        layer.addSublayer(circleLayer)

        progressLayer.path = circularPath.cgPath

        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 9.5
        progressLayer.strokeEnd = 0.0
        progressLayer.strokeColor = UIColor.systemBlue.cgColor

        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(value: Int) {
        let circularPA = CABasicAnimation(keyPath: "strokeEnd")
        circularPA.duration = 0.5
        circularPA.toValue = Double(value) * 0.001
        circularPA.fillMode = .forwards
        circularPA.isRemovedOnCompletion = false
        progressLayer.add(circularPA, forKey: "progressAnim")
    }
}
