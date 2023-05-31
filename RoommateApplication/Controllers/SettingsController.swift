//
//  SettingsController.swift
//  Diploma
//
//  Created by Абай on 30.11.2022.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var delegate: SettingsControllerDelegate?
    
    //MARK:- Instance Properies
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    @objc func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Загрузка изображения..."
        hud.show(in: view)
        
        ref.putData(uploadData, metadata: nil) { (_, error) in
            
            if let error = error {
                hud.dismiss()
                print("Ошибка при загрузке изображения:", error)
                return
            }
            
//            print("Finished uploading image")
            ref.downloadURL { (url, error) in
                hud.dismiss()
                
                if let error = error {
                    print("Не удалось получить URL-адрес загрузки:", error)
                    return
                }
                
//                print("Finished getting download url:", url?.absoluteString ?? "")
                
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
                
            }
        }
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Выберите фото", for: .normal)
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    deinit {
//        print("Object is deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Настройки"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }

    // MARK:- Header
    lazy var header: UIView = {
        let header = UIView()
        
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        return header
    }()
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        headerLabel.font = .systemFont(ofSize: 16, weight: .bold)
        switch section {
        case 1:
            headerLabel.text = "Ваше имя"
        case 2:
            headerLabel.text = "Ваша фамилия"
        case 3:
            headerLabel.text = "Ваш возраст"
        case 4:
            headerLabel.text = "Ваш ВУЗ"
        case 5:
            headerLabel.text = "Обо мне"
        default:
            headerLabel.text = "Возрастной диапазон поиска"
        }
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    // MARK:- Table view delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    static let defaultMinSeekingAge = 18
    static let defaultMaxSeekingAge = 28
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Age Range Cell
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            
            let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
            let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
            
            ageRangeCell.minLabel.text = "Мин \(minAge)"
            ageRangeCell.minSlider.value = Float(minAge)
            ageRangeCell.maxLabel.text = "Макс \(maxAge)"
            ageRangeCell.maxSlider.value = Float(maxAge)
            return ageRangeCell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Ваше имя"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Ваша фамилия"
            cell.textField.text = user?.surname
            cell.textField.addTarget(self, action: #selector(handleSurnameChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Ваш возраст"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        case 4:
            cell.textField.placeholder = "Ваш ВУЗ"
            cell.textField.text = user?.studying
            cell.textField.addTarget(self, action: #selector(handleStudyingChange), for: .editingChanged)
        case 5:
            cell.textField.placeholder = "Ваши интересы"
            cell.textField.text = user?.interests
            cell.textField.addTarget(self, action: #selector(handleInterestChange), for: .editingChanged)
        default:
            cell.textField.placeholder = "Введите данные"
        }
        return cell
    }
    
    @objc func handleNameChange(textField: UITextField) {
        user?.name = textField.text
    }
    
    @objc func handleSurnameChange(textField: UITextField) {
        user?.surname = textField.text
    }
    
    @objc func handleStudyingChange(textField: UITextField) {
        user?.studying = textField.text
    }
    
    @objc func handleInterestChange(textField: UITextField) {
        user?.interests = textField.text
    }
    
    @objc func handleAgeChange(textField: UITextField) {
        user?.age = Int(textField.text ?? "")
    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        if slider.value >= ageRangeCell.maxSlider.value {
            ageRangeCell.maxSlider.value = slider.value
        }
        ageRangeCell.minLabel.text = "Мин \(Int(slider.value))"
        ageRangeCell.maxLabel.text = "Макс \(Int(ageRangeCell.maxSlider.value))"
        
        self.user?.minSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        if slider.value <= ageRangeCell.minSlider.value {
            ageRangeCell.minSlider.value = slider.value
        }
        ageRangeCell.maxLabel.text = "Макс \(Int(slider.value))"
        ageRangeCell.minLabel.text = "Мин \(Int(ageRangeCell.minSlider.value))"
        
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    // MARK:- Firebase functions
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        Firestore.firestore().fetchCurrentUser { (user, error) in
            if let error = error {
                print("Ошибка при получении текущей информации о пользователе:", error)
                return
            }
            
            self.user = user
            self.loadUserPhotos()
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "uid": uid,
            "name": user?.name ?? "",
            "surname": user?.surname ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "age": user?.age ?? -1,
            "interests": user?.interests ?? "",
            "studying": user?.studying ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Сохранение настроек"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            hud.dismiss()
            
            if let error = error {
                print("Не удалось сохранить пользовательские настройки:", error)
                hud.textLabel.text = "Не удалось сохранить данные"
                hud.detailTextLabel.text = error.localizedDescription
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 5, animated: true)
                return
            }
            
//            print("Finished saving user info")
            self.dismiss(animated: true) {
                self.delegate?.didSaveSettings()
            }
        }
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
}

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}
