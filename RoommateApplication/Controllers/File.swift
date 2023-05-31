//
//  RegisterationController.swift
//  Diploma
//
//  Created by Абай on 30.11.2022.
//
//
//import UIKit
//import JGProgressHUD
//
//class RegistrationController: UIViewController {
//    
//    var delegate: LoginControllerDelegate?
//    let registrationViewModel = RegistrationViewModel()
//    let registeringHUD = JGProgressHUD(style: .dark)
//    
//   
//        let scrollView = UIScrollView()
//        let contentView = UIView()
//        
//        
//    //MARK:- UI Components
//    let selectPhotoButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Выберите фото", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
//        button.backgroundColor = .systemGray2
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 18
//        button.imageView?.contentMode = .scaleAspectFill
//        button.clipsToBounds = true
//        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
//        return button
//    }()
//    
//    let fullNameTextField: CustomTextField = {
//        let tf = CustomTextField(fieldType: .fullName)
//        tf.placeholder = "Имя пользователя"
//        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
//        return tf
//    }()
//    
//    let emailTextField: CustomTextField = {
//        let tf = CustomTextField(fieldType: .email)
//        tf.placeholder = "Введите почту"
//        tf.keyboardType = .emailAddress
//        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
//        return tf
//    }()
//    let passwordTextField: CustomTextField = {
//        let tf = CustomTextField(fieldType: .password)
//        tf.placeholder = "Введите пароль"
//        tf.isSecureTextEntry = true
//        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
//        return tf
//    }()
//    
//    let livesTextField: CustomTextField = {
//        let tf = CustomTextField(fieldType: .lives)
//        tf.placeholder = "Где вы проживаете?"
//        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
//        return tf
//    }()
//    
//    
//    let interestsTextField: CustomTextField = {
//        let tf = CustomTextField(fieldType: .interests)
//        tf.placeholder = "Введите ваши интересы"
//        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
//        return tf
//    }()
//    
//    
//    let registerButton: UIButton = {
//        let button = CustomButton(title: "Регистрация", hasBackground: true, fontSize: .med)
//        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
//        return button
//    }()
//    
//    let goToLoginButton: UIButton = {
//        let button = CustomButton(title: "Уже есть аккаунт?", fontSize: .med)
//        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
//        return button
//    }()
//    
//    @objc fileprivate func handleGoToLogin() {
//        navigationController?.popViewController(animated: true)
//    }
//
//    
//    //MARK:- View Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupLayout()
//        setupRegistrationViewModelObserver()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//    
//    
//    //MARK:- Private
//    fileprivate func setupRegistrationViewModelObserver() {
//    
//        registrationViewModel.bindableImage.bind { [unowned self] (image) in
//            self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
//        }
//        
//        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
//            guard let isRegistering = isRegistering else { return }
//            if isRegistering {
//                self.registeringHUD.textLabel.text = "Вход"
//                self.registeringHUD.show(in: self.view)
//            } else {
//                self.registeringHUD.dismiss()
//            }
//        }
//    }
//    
//    fileprivate func setupLayout() {
//        navigationController?.isNavigationBarHidden = true
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        
//            view.addSubview(goToLoginButton)
//            view.addSubview(scrollView)
//            scrollView.addSubview(contentView)
//
//            self.view.backgroundColor = .systemBackground
//            scrollView.addSubview(selectPhotoButton)
//            scrollView.addSubview(fullNameTextField)
//            scrollView.addSubview(emailTextField)
//            scrollView.addSubview(passwordTextField)
//            scrollView.addSubview(livesTextField)
//            scrollView.addSubview(interestsTextField)
//            scrollView.addSubview(registerButton)
//            scrollView.addSubview(goToLoginButton)
//
//            selectPhotoButton.translatesAutoresizingMaskIntoConstraints = false
//            fullNameTextField.translatesAutoresizingMaskIntoConstraints = false
//            emailTextField.translatesAutoresizingMaskIntoConstraints = false
//            passwordTextField.translatesAutoresizingMaskIntoConstraints = false
//            livesTextField.translatesAutoresizingMaskIntoConstraints = false
//            interestsTextField.translatesAutoresizingMaskIntoConstraints = false
//            registerButton.translatesAutoresizingMaskIntoConstraints = false
//            goToLoginButton.translatesAutoresizingMaskIntoConstraints = false
//
//
//            NSLayoutConstraint.activate([
//                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//                selectPhotoButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
//                selectPhotoButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//                selectPhotoButton.widthAnchor.constraint(equalToConstant: 250),
//                selectPhotoButton.heightAnchor.constraint(equalToConstant: 250),
//
//                fullNameTextField.topAnchor.constraint(equalTo: selectPhotoButton.bottomAnchor, constant: 28),
//                fullNameTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//                fullNameTextField.heightAnchor.constraint(equalToConstant: 55),
//                fullNameTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
//
//                emailTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 18),
//                emailTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//                emailTextField.heightAnchor.constraint(equalToConstant: 55),
//                emailTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
//
//                passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 22),
//                passwordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//                passwordTextField.heightAnchor.constraint(equalToConstant: 55),
//                passwordTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
//
//                livesTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 22),
//                livesTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//                livesTextField.heightAnchor.constraint(equalToConstant: 55),
//                livesTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
//
//                interestsTextField.topAnchor.constraint(equalTo: livesTextField.bottomAnchor, constant: 22),
//                interestsTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//                interestsTextField.heightAnchor.constraint(equalToConstant: 55),
//                interestsTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
//
//                registerButton.topAnchor.constraint(equalTo: interestsTextField.bottomAnchor, constant: 22),
//                registerButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//                registerButton.heightAnchor.constraint(equalToConstant: 55),
//                registerButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
//                
//                
//            goToLoginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 22),
//            goToLoginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            goToLoginButton.heightAnchor.constraint(equalToConstant: 55),
//            goToLoginButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
//                
//        ])
//        
//        scrollView.contentSize = CGSize(width: view.frame.width, height: registerButton.frame.origin.y + registerButton.frame.size.height + 16)
//
//    }
//    
//    
//    @objc fileprivate func handleTextChange(textField: UITextField) {
//        if textField == fullNameTextField {
//            registrationViewModel.fullName = textField.text
//        } else if textField == emailTextField {
//            registrationViewModel.email = textField.text
//        } else if textField == passwordTextField {
//            registrationViewModel.password = textField.text
//        } else if textField == livesTextField {
//            registrationViewModel.living = textField.text
//        } else if textField == interestsTextField {
//            registrationViewModel.interests = textField.text
//        }
//    }
//
//    
//    @objc fileprivate func handleRegister() {
//        registrationViewModel.performRegistration { [unowned self] (error) in
//            if let error = error {
//                self.showHUDWithError(error: error)
//                return
//            }
//            print("Успешно зарегистрирован")
//            self.dismiss(animated: true) {
//                self.delegate?.didFinishLoggingIn()
//            }
//        }
//    }
//    
//    fileprivate func showHUDWithError(error: Error) {
//        registeringHUD.dismiss()
//        let hud = JGProgressHUD(style: .dark)
//        hud.textLabel.text = "Failed registeration"
//        hud.detailTextLabel.text = error.localizedDescription
//        hud.show(in: self.view)
//        hud.dismiss(afterDelay: 4)
//    }
//    
//    @objc fileprivate func handleSelectPhoto() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.modalPresentationStyle = .fullScreen
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true)
//    }
//    
//    fileprivate func setupNotificationObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc fileprivate func handleKeyboardShow(notification: Notification) {
//
//        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        let keyboardFrame = value.cgRectValue
//
//        let bottomSpace = view.frame.height - view.frame.origin.y - view.frame.height
//
//        let difference = keyboardFrame.height - bottomSpace
//        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
//    }
//    
//    @objc fileprivate func handleKeyboardHide() {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.view.transform = .identity
//        })
//    }
//        fileprivate func setupTapGesture() {
//            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
//        }
//    
//        @objc fileprivate func handleTapDismiss() {
//            self.view.endEditing(true)
//        }
//}
//
//extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[.originalImage] as? UIImage
//        registrationViewModel.bindableImage.value = image
//        registrationViewModel.checkFormValidity()
//        dismiss(animated: true, completion: nil)
//    }
//}
