//
//  ProfileViewController.swift
//  CryptX
//
//  Created by Mehmet Barkın Mercan on 26.07.2024.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var profilePhotoImageView: UIImageView!
    @IBOutlet private weak var profileNameTextField: UITextField!
    @IBOutlet private var imageChangeButton: UIButton!
    
    let homepageVC = HomepageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2
        imageChangeButton.layer.cornerRadius = imageChangeButton.frame.size.width / 2        
    }
    
    @IBAction func imageChangeButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func profileNameChanged(_ sender: Any) {
        let name = profileNameTextField.text ?? ""
        let image = profilePhotoImageView.image ?? UIImage()

        NotificationCenter.default.post(name: NSNotification.Name(AppConstants.NotificationName.profileDataUpdated), object: nil, userInfo: ["name": name, "image": image])
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profilePhotoImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
