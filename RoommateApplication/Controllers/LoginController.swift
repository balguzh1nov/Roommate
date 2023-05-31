//
//  LoginController.swift
//  Diploma
//
//  Created by Абай on 30.11.2022.
//

import UIKit
import JGProgressHUD

protocol LoginControllerDelegate {
    func didFinishLoggingIn()
}

class LoginController: UIViewController {
    
    var delegate: LoginControllerDelegate?
    
    private let forgotPasswordButton = CustomButton(title: "Забыли пароль?", fontSize: .small)
    private let headerView = AuthHeaderView(title: "Roommate", subTitle: "Войдите в свой аккаунт")
     
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(fieldType: .email)
        tf.placeholder = "Введите почту"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(fieldType: .password)
        tf.placeholder = "Введите пароль"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = CustomButton(title: "Войти", hasBackground: true, fontSize: .med)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    

    fileprivate let backToRegisterButton: UIButton = {
        let button = CustomButton(title: "Не зарегистрированы?", fontSize: .med)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleBack() {
        let registrationController = RegistrationController()
        registrationController.delegate = delegate
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        loginViewModel.performLogin { (err) in
            self.loginHUD.dismiss()
            if let err = err {
                print("Ошибка при входе:", err)
                return
            }
            
//            print("Logged in successfully")
            self.dismiss(animated: true) {
                self.delegate?.didFinishLoggingIn()
            }
        }
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindables()
        
    }
    
    
    
    fileprivate let loginViewModel = LoginViewModel()
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    
    fileprivate func setupBindables() {
        loginViewModel.isLoggingIn.bind { [unowned self] (isLoggingIn) in
            if isLoggingIn == true {
                self.loginHUD.textLabel.text = "Вход..."
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
    
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(headerView)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(backToRegisterButton)
        self.view.addSubview(forgotPasswordButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        backToRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                    self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                    self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    self.headerView.heightAnchor.constraint(equalToConstant: 222),
                    
                    self.emailTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
                    self.emailTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                    self.emailTextField.heightAnchor.constraint(equalToConstant: 55),
                    self.emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                    
                    self.passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 22),
                    self.passwordTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                    self.passwordTextField.heightAnchor.constraint(equalToConstant: 55),
                    self.passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                    
                    self.loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 22),
                    self.loginButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                    self.loginButton.heightAnchor.constraint(equalToConstant: 55),
                    self.loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                    
                    self.backToRegisterButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 11),
                    self.backToRegisterButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                    self.backToRegisterButton.heightAnchor.constraint(equalToConstant: 44),
                    self.backToRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                    
                    self.forgotPasswordButton.topAnchor.constraint(equalTo: backToRegisterButton.bottomAnchor, constant: 6),
                    self.forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                    self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
                    self.forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                ])
    }
    
}

