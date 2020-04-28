//
//  CircleLoadingView.swift
//  CircleLoadingView
//
//  Created by chenjie on 2020/4/28.
//  Copyright © 2020 Jason. All rights reserved.
//

import UIKit

class CircleLoadingView: UIView {
    
    lazy var fromColor:UIColor = #colorLiteral(red: 0.4470588235, green: 0.7215686275, blue: 0.2862745098, alpha: 1)
    
    lazy var toColor:UIColor = .black
    
    lazy var lineWidth:CGFloat = 6
    
    lazy var radius = min(self.width / 2, self.height / 2)
    
    lazy var path = UIBezierPath(arcCenter: .zero, radius: self.radius - self.lineWidth / 2, startAngle: -CGFloat.pi / 2 - CGFloat.pi / 36, endAngle: -CGFloat.pi / 2 + CGFloat.pi / 36, clockwise: false).cgPath
    
    lazy var bottomLayer:CALayer = {
        
        let bottomLayer = CALayer()
        
        bottomLayer.frame = self.layer.bounds
        
        self.layer.addSublayer(bottomLayer)
        
        bottomLayer.mask = circleLayer
        
        return bottomLayer
    }()
    
    /// 圆弧
    lazy var circleLayer:CAShapeLayer = {
        
        let layer = CAShapeLayer()
        
        layer.path = path
        
        layer.lineWidth = self.lineWidth
        
        layer.lineCap = .round
        
        layer.position = CGPoint(x: width/2, y: height/2)
        
        layer.fillColor = UIColor.clear.cgColor
        
        layer.strokeColor = UIColor.red.cgColor
        
        return layer
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
}


// MARK: - UI
extension CircleLoadingView {
    
    func setupUI() {
        
        for i in 0...3 {
            drawGradientLayer(index: i)
        }
        
        animation()
    }
    
    
    func drawGradientLayer(index:Int) {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
        
        switch index {
        case 0:
            gradientLayer.position = CGPoint(x: (width - radius) / 2, y: (height - radius) / 2)
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case 1:
            gradientLayer.position = CGPoint(x: (width - radius) / 2, y: (height + radius) / 2)
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case 2:
            gradientLayer.position = CGPoint(x: (width + radius) / 2, y: (height + radius) / 2)
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case 3:
            gradientLayer.position = CGPoint(x: (width + radius) / 2, y: (height - radius) / 2)
            gradientLayer.startPoint = CGPoint(x: 1, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        default:
            break
        }
        
        gradientLayer.colors = [color(index: index).cgColor,color(index: index + 1).cgColor]
        
        bottomLayer.addSublayer(gradientLayer)
        
    }
    
}



// MARK: - Method
extension CircleLoadingView {
    
    func color(index:Int) -> UIColor {
        
        var fromRed:CGFloat = 0,fromGreen:CGFloat = 0,fromBlue:CGFloat = 0,fromAlpha:CGFloat = 0,toRed:CGFloat = 0,toGreen:CGFloat = 0,toBlue:CGFloat = 0,toAlpha:CGFloat = 0
        
        
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        return UIColor(red: gradientColor(fromRed, toRed, index), green: gradientColor(fromGreen, toGreen, index), blue: gradientColor(fromBlue, toBlue, index), alpha: gradientColor(fromAlpha, toAlpha, index))
    }
    
    
    func gradientColor(_ fromColor:CGFloat,_ toColor:CGFloat,_ index:Int) -> CGFloat {
        let color = (toColor - fromColor) / 4 * CGFloat(index) + fromColor
        return color
    }
    
    
    func animation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        // 默认是顺时针效果，若将formValue和toValue的值互换，则为逆时针效果
        animation.fromValue = 0
        
        animation.toValue = Double.pi*2
        
        animation.duration = 1.5
        
        animation.autoreverses = false
        
        animation.isRemovedOnCompletion = false
        
        animation.repeatCount = HUGE
        // 定义动画的节奏
        // animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        bottomLayer.add(animation, forKey: "rotate")
    }
    
}
