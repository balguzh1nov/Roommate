//
//  User.swift
//  Diploma
//
//  Created by Абай on 30.11.2022.
//

import UIKit

struct User: ProducesCardViewModel {
    
    var name: String?
    var surname: String? 
    var interests: String?
    var studying: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    

    var minSeekingAge: Int?
    var maxSeekingAge: Int?
        
    let fontName = "Fontspring-DEMO-chesnagrotesk-regular"

    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.surname = dictionary["surname"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.interests = dictionary["interests"] as? String ?? ""
        self.studying = dictionary["studying"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
        
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let studying = studying != nil ? studying! : "This is view card"
        let interestsString = interests != nil ? interests! : "This is view card"
        let descriptionString = "\(studying) \(interestsString)"
                attributedText.append(NSAttributedString(string: "\n\(descriptionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
                
        
        var imageUrls = [String]()
        if let url = imageUrl1, url != "" { imageUrls.append(url) }
        if let url = imageUrl2, url != "" { imageUrls.append(url) }
        if let url = imageUrl3, url != "" { imageUrls.append(url) }
        
        return CardViewModel(uid: self.uid ?? "", imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}

