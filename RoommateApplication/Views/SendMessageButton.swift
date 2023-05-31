//
//  SendMessageButton.swift
//  Diploma
//
//  Created by Абай on 30.11.2022.
//

import UIKit

class SendMessageButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.8901960784, alpha: 1) //#colorLiteral(red: 1, green: 0.01176470588, blue: 0.4470588235, alpha: 1)
        let rightColor = #colorLiteral(red: 0.07658459991, green: 0.1685920954, blue: 0.89852494, alpha: 1) //#colorLiteral(red: 1, green: 0.3294117647, blue: 0.3176470588, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.frame = rect
        
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }

}
