//
//  RegistrationController.swift
//  Diploma
//
//  Created by Абай on 30.11.2022.
//


import UIKit
import JGProgressHUD

class RegistrationController: UIViewController, UITextFieldDelegate {
    
    var delegate: LoginControllerDelegate?
    let registrationViewModel = RegistrationViewModel()
    let registeringHUD = JGProgressHUD(style: .dark)
    
    let UniversityData = ["Astana IT University", "Nazarbaev University", "ENU", "AgroUniversity", "AIU"]

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK:- UI Components
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Фото", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        button.backgroundColor = .systemGray2
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 75
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: CustomTextField = {
        let tf = CustomTextField(fieldType: .name)
        tf.placeholder = "Имя"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let surnameTextField: CustomTextField = {
        let tf = CustomTextField(fieldType: .surname)
        tf.placeholder = "Фамилия"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
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
    
    let genderSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Мужской", "Женский"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleGenderSelect(_:)), for: .valueChanged)
        return segmentedControl
    }()

    let ageTextField: CustomTextField = {
        let tf = CustomTextField(fieldType: .age)
        tf.placeholder = "Возраст"
        tf.keyboardType = .numberPad // Set keyboard type to numberPad
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let pickerView = UIPickerView()
    
    let studiesDropdown: UITextField = {
        let dropdown = UITextField()
        dropdown.placeholder = "Ваш университет?"
        dropdown.textAlignment = .center
        dropdown.borderStyle = .none
        dropdown.layer.cornerRadius = 8
        dropdown.layer.borderWidth = 1
        dropdown.layer.borderColor = UIColor.gray.cgColor
        dropdown.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return dropdown
    }()

    
    let interestsTextField: UITextField = {
        let tf = CustomTextField(fieldType: .interests)
        tf.placeholder = "Введите ваши интересы"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
        
    let registerButton: UIButton = {
        let button = CustomButton(title: "Регистрация", hasBackground: true, fontSize: .med)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let goToLoginButton: UIButton = {
        let button = CustomButton(title: "Уже есть аккаунт?", fontSize: .med)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleGoToLogin() {
        navigationController?.popViewController(animated: true)
    }

    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupRegistrationViewModelObserver()
        pickerView.delegate = self
        pickerView.dataSource = self
        studiesDropdown.inputView = pickerView


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    //MARK:- Private
    fileprivate func setupRegistrationViewModelObserver() {
    
        registrationViewModel.bindableImage.bind { [unowned self] (image) in
            self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            guard let isRegistering = isRegistering else { return }
            if isRegistering {
                self.registeringHUD.textLabel.text = "Вход"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(scrollView)
        
        self.view.backgroundColor = .systemBackground
        scrollView.addSubview(selectPhotoButton)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(surnameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(studiesDropdown)
        scrollView.addSubview(interestsTextField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(goToLoginButton)
        scrollView.addSubview(genderSegmentedControl)
        scrollView.addSubview(ageTextField)
        scrollView.addSubview(studiesDropdown)

        
        selectPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        surnameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        studiesDropdown.translatesAutoresizingMaskIntoConstraints = false
        interestsTextField.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        goToLoginButton.translatesAutoresizingMaskIntoConstraints = false
        genderSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            selectPhotoButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            selectPhotoButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            selectPhotoButton.widthAnchor.constraint(equalToConstant: 150),
            selectPhotoButton.heightAnchor.constraint(equalToConstant: 150),
            
            surnameTextField.topAnchor.constraint(equalTo: selectPhotoButton.bottomAnchor, constant: 28),
            surnameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            surnameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            surnameTextField.heightAnchor.constraint(equalToConstant: 55),
            surnameTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            
            nameTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 28),
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 55),
            nameTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
                        
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 18),
            emailTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 55),
            emailTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 22),
            passwordTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 55),
            passwordTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            
            genderSegmentedControl.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 22),
            genderSegmentedControl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            genderSegmentedControl.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            genderSegmentedControl.heightAnchor.constraint(equalToConstant: 55),
            genderSegmentedControl.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            
            ageTextField.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: 22),
            ageTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            ageTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            ageTextField.heightAnchor.constraint(equalToConstant: 55),
            ageTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            
            studiesDropdown.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 22),
            studiesDropdown.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            studiesDropdown.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            studiesDropdown.heightAnchor.constraint(equalToConstant: 55),
            studiesDropdown.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            
            interestsTextField.topAnchor.constraint(equalTo: studiesDropdown.bottomAnchor, constant: 22),
            interestsTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            interestsTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            interestsTextField.heightAnchor.constraint(equalToConstant: 55),
            interestsTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            
            registerButton.topAnchor.constraint(equalTo: interestsTextField.bottomAnchor, constant: 22),
            registerButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            registerButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            registerButton.heightAnchor.constraint(equalToConstant: 55),
            registerButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            
            goToLoginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 22),
            goToLoginButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            goToLoginButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            goToLoginButton.heightAnchor.constraint(equalToConstant: 55),
            goToLoginButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            goToLoginButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
        ])
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: goToLoginButton.frame.origin.y + goToLoginButton.frame.size.height + 16)
    }
    
    @objc fileprivate func handleTextChange(_ textField: UITextField) {
        if textField == nameTextField {
            registrationViewModel.name = textField.text
        } else if textField == surnameTextField {
            registrationViewModel.surname = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else if textField == passwordTextField {
            registrationViewModel.password = textField.text
        } else if textField == ageTextField {
            if let ageText = textField.text, let age = Int(ageText) {
                registrationViewModel.age = age
            } else {
                registrationViewModel.age = nil
            }
        } else if textField == studiesDropdown {
            registrationViewModel.studying = textField.text
        } else if textField == interestsTextField {
            registrationViewModel.interests = textField.text
        }
        
        registrationViewModel.checkFormValidity()
    }

    
    @objc fileprivate func handleRegister() {
        registrationViewModel.performRegistration { [unowned self] (error) in
            if let error = error {
                self.showHUDWithError(error: error)
                return
            }
            print("Успешно зарегистрирован")
            self.dismiss(animated: true) {
                self.delegate?.didFinishLoggingIn()
            }
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registeration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    @objc fileprivate func handleGenderSelect(_ segmentedControl: UISegmentedControl) {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        if selectedIndex == 0 {
            registrationViewModel.gender = "Мужской"
        } else {
            registrationViewModel.gender = "Женский"
        }
        
        registrationViewModel.checkFormValidity()
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc fileprivate func handleKeyboardShow(notification: Notification) {

        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue

        let bottomSpace = view.frame.height - view.frame.origin.y - view.frame.height

        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
        fileprivate func setupTapGesture() {
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        }
    
        @objc fileprivate func handleTapDismiss() {
            self.view.endEditing(true)
        }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        registrationViewModel.checkFormValidity()
        dismiss(animated: true, completion: nil)
    }
}

extension RegistrationController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Number of columns in the dropdown menu
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UniversityData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UniversityData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedUniversity = UniversityData[row]
        registrationViewModel.studying = selectedUniversity
        studiesDropdown.text = selectedUniversity
    }
}



