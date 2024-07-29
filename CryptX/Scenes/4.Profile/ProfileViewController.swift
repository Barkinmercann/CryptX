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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCosmetics()
    }
    
    func setupCosmetics() {
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2
        imageChangeButton.layer.cornerRadius = imageChangeButton.frame.size.width / 2
        profilePhotoImageView.image = SettingsManager.shared.profilePhoto
        profileNameTextField.text = SettingsManager.shared.profileName
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        SettingsManager.shared.profileName = profileNameTextField.text ?? ""
        SettingsManager.shared.profilePhoto = profilePhotoImageView.image ?? UIImage()

        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        
        NotificationCenter.default.post(name: NSNotification.Name(AppConstants.NotificationName.profileDataUpdated), object: nil)

        self.view.endEditing(true)
    }
    
    @IBAction func imageChangeButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Edit Profile Photo", message: "", preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { _ in
            self.showImagePicker(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
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
