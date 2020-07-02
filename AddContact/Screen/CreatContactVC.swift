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

class CreatContactVC: UIViewController {
    
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
            numberTextField.text = contact?.number
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        configureNavigationBarItems()
        setupUI()
    }
    
    
    func configureNavigationBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    
    func creatCompany() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context)
        
        contact.setValue(nameTextField.text, forKey: "name")
        contact.setValue(numberTextField.text, forKey: "number")
            
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
        contact?.number         = numberTextField.text

        
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
    }
    
    
    func setupUI() {
        [nameLabel, nameTextField, numberLabel, numberTextField].forEach{ view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
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
