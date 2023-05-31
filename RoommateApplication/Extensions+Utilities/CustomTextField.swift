//
//  CustomTextField.swift
//  Diploma
//
//  Created by Абай on 30.11.2022.
//

import UIKit

class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case name
        case surname
        case email
        case password
        case age
        case studying
        case interests
    }
    
    private let authFieldType: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .name:
            self.placeholder = "Имя"
        case .surname:
            self.placeholder = "Фамилия"
        case .email:
            self.placeholder = "Почта"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Пароль"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        case .age:
            self.placeholder = "Возраст"
            self.keyboardType = .numberPad
        case .studying:
            self.placeholder = "В каком университете вы учитесь?"
        case .interests:
            self.placeholder = "Какие у вас интересы? (Хобби)"
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
