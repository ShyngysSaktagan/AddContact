//
//  CreatContactVC.swift
//  AddContact
//
//  Created by Shyngys Saktagan on 7/3/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import CoreData

protocol CreatContactControllerDelegate {
    func didAdd(contact: Contact)
    func didEdit(contact: Contact)
}

class CreatContactVC: UIViewController, UINavigationControllerDelegate {
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        
        return imageView
    }()
    
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter contact name"
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    } ()
    
    var numberLabel : UILabel = {
        let label = UILabel()
        label.text = "Number"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    var numberTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter contact number"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
        
    } ()
    
    var delegate : CreatContactControllerDelegate?
    
    var contact : Contact? {
        didSet {
            nameTextField.text = contact?.name
            guard let number = contact?.number else {
                return
            }
            if let imageData = contact?.imageData {
                companyImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
            numberTextField.text = number
            
        }
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .red
        configureNavigationBarItems()
        setupUI()
    }
    
    
    func configureNavigationBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelView))
    }
    
    
    @objc func cancelView() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func creatCompany() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context)
        
        contact.setValue(nameTextField.text, forKey: "name")
        
        if numberTextField.text != "" {
            contact.setValue(numberTextField.text, forKey: "number")
        }else{
            print("Need to enter number")
            return
        }
    
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            contact.setValue(imageData, forKey: "imageData")
        }
            
        do  {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAdd(contact: contact as! Contact)
            }
        } catch let saveErr {
            print("\(saveErr)")
        }
    }
       
       
    func changeCompany(){
        let context = CoreDataManager.shared.persistentContainer.viewContext

        contact?.name           = nameTextField.text
        guard let number = numberTextField.text else {
            return
        }
        contact?.number         = number
        
        if let imageData = companyImageView.image {
            contact?.imageData  = imageData.jpegData(compressionQuality: 0.8)
        }
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEdit(contact: self.contact!)
            }
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }
    }
       
       
    @objc func handleSave() {
        if contact == nil {
            creatCompany()
        }else {
            changeCompany()
        }
        dismiss(animated: true, completion: nil)

    }
    
    
    func setupUI() {
        
        [companyImageView, nameLabel, nameTextField, numberLabel, numberTextField].forEach{ view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            companyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            companyImageView.widthAnchor.constraint(equalToConstant: 100),
            companyImageView.heightAnchor.constraint(equalToConstant: 100),
            companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
            nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor, constant: 8),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            numberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            numberLabel.widthAnchor.constraint(equalToConstant: 100),
            numberLabel.heightAnchor.constraint(equalToConstant: 50),
            numberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            numberTextField.topAnchor.constraint(equalTo: numberLabel.topAnchor),
            numberTextField.bottomAnchor.constraint(equalTo: numberLabel.bottomAnchor),
            numberTextField.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 8),
            numberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}


extension CreatContactVC: UIImagePickerControllerDelegate {
    @objc func handleSelectPhoto() {
        let imagePickerController                       = UIImagePickerController()
        imagePickerController.delegate                  = self
        imagePickerController.allowsEditing             = true
        imagePickerController.modalPresentationStyle    = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            companyImageView.image = originalImage
        }
        
        setupCircularImageStyle()
        dismiss(animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    
    private func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds      = true
        companyImageView.layer.borderColor  = UIColor.red.cgColor
        companyImageView.layer.borderWidth  = 2
    }
}
