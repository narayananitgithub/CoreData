//
//  RegistrationViewController.swift
//  Coredata
//
//  Created by Narayanasamy on 13/08/23.
//

import UIKit
import PhotosUI

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var firstnameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var lastnameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var registerButton: UIButton! {
        didSet{
            self.registerButton.layer.cornerRadius = 10
            self.registerButton.layer.masksToBounds = true
        }
    }
    
    private let manager = DatabaseManger()
    private var imageSelecectedByUser: Bool = false
    
    var user: UserEntity?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

    extension RegistrationViewController {
        
        func configuration() {
            uiconfiguration()
            addGesture()
            userDetailconfiguration()
        }
        
        func uiconfiguration() {
            
            profileImageview.layer.cornerRadius = profileImageview.frame.size.height / 2
        }
        
        func addGesture() {
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.openGallery))
            profileImageview.addGestureRecognizer(imageTap)
            
        }
        
        
        func userDetailconfiguration() {
            
            if let user {
                registerButton.setTitle("Update", for: .normal)
                navigationItem.title = "Update user"
                firstnameTxt.text = user.firstName
                lastnameTxt.text = user.lastName
                emailTxt.text = user.email
                passwordTxt.text = user.password
                
                
                let imageURL = URL.documentsDirectory.appending(component: user.imageName ?? "").appendingPathExtension("png")
                profileImageview.image = UIImage(contentsOfFile: imageURL.path)
                
                
                imageSelecectedByUser = true
            } else {
                navigationItem.title = "Add User"
                registerButton.setTitle("Register", for: .normal)
            }
        }
      
    
        @IBAction func onClickRegisterBtn(_ sender: UIButton) {
            
            guard let firstName = firstnameTxt.text ,!firstName.isEmpty else {
                
                openalert(message: "Please enter your first name")
                return
            }
            guard let lastName = lastnameTxt.text, !lastName.isEmpty else {
                openalert(message: "Please enter your last name ")
                return
            }
            guard let email = emailTxt.text, !email.isEmpty else {
                openalert(message: "Please enter your email")
                return
            }
            
            guard let password = passwordTxt.text, !email.isEmpty else {
                openalert(message: "Please enter your Password")
                return
            }
            if imageSelecectedByUser {
                openalert(message: "Please select your profileimage.")
                return
            }
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let userEntity = UserEntity(context: context)
            
            userEntity.firstName = firstName
            userEntity.lastName = lastName
            userEntity.email = email
            userEntity.password = password
            
            
            do {
                try context.save() //MIMP
                    
            }catch {
                print("User saving error:",error)
            }
        
            let newUser: UserModel
                if let user {
                    
                    //newuser - Naren
                    //user (user entity)-store user
                    // narayanan - Naren
                    
                    let newUser = UserModel(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password,
                        imageName: user.imageName ?? ""
                    )

                    manager.updateUser(user: newUser, userEntity: user)
                    saveImageTodocumentDirectry(imageName: newUser.imageName)
                }else {
                    // add

                    let imageName = UUID().uuidString
                    let newUser = UserModel(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password,
                        imageName: imageName
                    )

                    saveImageTodocumentDirectry(imageName: imageName)
                    manager.addUser(newUser)
                }

                navigationController?.popViewController(animated: true)


               // print("All validations are done!!! good to go...")


               // showAlert()
    }
        
        func saveImageTodocumentDirectry(imageName: String) {
            
            let fileURL = URL.documentsDirectory.appending(components: imageName).appendingPathExtension("png")
            if let data = profileImageview.image?.pngData() {
                do {
                    try data.write(to: fileURL)
                } catch {
                    print("Saving image to Document Directory error:", error)
                }
                
                
            }
        }

        func showAlert() {
            
            let alertController = UIAlertController(title: nil, message: "User added", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default)
            alertController.addAction(okay)
            present(alertController, animated: true)
            
        }
        
        @objc func openGallery() {
            
            var config = PHPickerConfiguration()
            config.selectionLimit = 1 // 0- Unlimited
            
            let pickerVc = PHPickerViewController(configuration: config)
            pickerVc.delegate = self
            present(pickerVc, animated: true)
            
        }
        
        func openalert(message: String) {
            
            let alertcontroller = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            
            let okay = UIAlertAction(title: "Okay", style: .default)
            alertcontroller.addAction(okay)
            present(alertcontroller, animated: true)
        }
    }
extension RegistrationViewController:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            //Backround thread
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { image,error in
                guard let image = image as? UIImage else { return }
                
                DispatchQueue.main.async {
                    //Main UI related work
                    
                    self.profileImageview.image = image
                    self.imageSelecectedByUser = true
                }
            }
            
        }
        
    }
}
