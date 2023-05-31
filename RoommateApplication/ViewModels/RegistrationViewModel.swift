//
//  RegistrationViewModel.swift
//  Diploma
//
//  Created by Абай on 30.11.2022.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()

    var name: String? { didSet { checkFormValidity() } }
    var surname: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    var interests: String? { didSet { checkFormValidity() } }
    var studying: String? { didSet { checkFormValidity() } }
    var age: Int? { didSet { checkFormValidity() } }
    var gender: String? { didSet { checkFormValidity() } }
    
    func checkFormValidity() {
        let isFormValid = name?.isEmpty == false && surname?.isEmpty == false && email?.isEmpty == false && isEmailValid(email) && password?.isEmpty == false && isPasswordValid(password) && interests?.isEmpty == false && studying?.isEmpty == false && age != nil && gender != nil
        bindableIsFormValid.value = isFormValid
    }
    
    fileprivate func isEmailValid(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    fileprivate func isPasswordValid(_ password: String?) -> Bool {
        guard let password = password else { return false }
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Введите корректную почту или пароль"])
            completion(error)
            return
        }
        
        guard isEmailValid(email) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Введите корректную почту"])
            completion(error)
            return
        }
        
        guard isPasswordValid(password) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Пароль должен состоять мин длинной из 8 символов и одной цифры"])
            completion(error)
            return
        }
                
        bindableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            print("Успешно зарегистрирован пользователь:", result?.user.uid ?? "")
            
            self.saveImageToFirebase(completion: completion)
        }
    }

    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        ref.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
//                    print("Error uploading profile image:", error)
                completion(error)
                return
            }
            
            print("Finished uploading image to storage")
            ref.downloadURL { (url, error) in
                if let error = error {
//                        print("Error getting image download url:", error)
                    completion(error)
                    return
                }
                
                self.bindableIsRegistering.value = false
                print("Download url of image is:", url?.absoluteString ?? "")
                
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            }
        }
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String : Any] =
        ["name": name ?? "",
         "surname": surname ?? "",
         "gender": gender ?? "",
         "age": age ?? "",
         "interests": interests ?? "",
         "studying": studying ?? "",
            "uid": uid,
            "imageUrl1": imageUrl,
            "minSeekingAge": SettingsController.defaultMinSeekingAge,
            "maxSeekingAge": SettingsController.defaultMaxSeekingAge
        ]
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
