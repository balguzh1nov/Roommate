//
//  HomeBottomControlsStackView.swift
//  Diploma
//
//  Created by Абай on 30.11.2022.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        [dislikeButton, likeButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
}
