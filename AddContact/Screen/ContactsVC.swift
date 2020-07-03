//
//  ViewController.swift
//  AddContact
//
//  Created by Shyngys Saktagan on 7/2/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController, CreatContactControllerDelegate {
    
    var contacts = [Contact]()
    
    var tableView = UITableView()
    
    func didAdd(contact: Contact) {
        contacts.append(contact)
        let newIndexPath = IndexPath(row: contacts.count-1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
    func didEdit(contact: Contact) {
        let row             = contacts.firstIndex(of: contact)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contacts = CoreDataManager.shared.fetchCompanies()
        configureView()
        configureTableView()
        addPlusButton()
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") {  (action, view, completion) in
            let context = CoreDataManager.shared.persistentContainer.viewContext
            let company = self.contacts[indexPath.row]
            
            self.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            context.delete(company)
            
            do {
                try context.save()
                completion(true)
            } catch let error {
                print("Error \(error)")
            }
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            let creatCompanyController                  = CreatContactVC()
            let navigationController                    = UINavigationController(rootViewController: creatCompanyController)
            creatCompanyController.delegate             = self
            creatCompanyController.contact              = self.contacts[indexPath.row]
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true)
        }
        
        edit.backgroundColor    = .systemGray3
        edit.image              = UIImage(systemName: "slider.horizontal.3")
        
        delete.backgroundColor  = .red
        delete.image            = UIImage(systemName: "trash")
        
        let swipeActions        = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipeActions
    }
    
    
    func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .red
        title = "Contacts"
        view.backgroundColor = .white
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.register(ContantsCellTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        setTableViewDelegates()
        tableView.rowHeight = 50
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    
    func setTableViewDelegates() {
        tableView.dataSource = self
        tableView.delegate   = self
    }
    
    
    func addPlusButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
    }
    
    
    @objc func addContact() {
        let creatContact = UINavigationController(rootViewController: CreatContactVC())
        present(creatContact, animated: true)
    }
    
}


extension ContactsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
     
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContantsCellTableViewCell
        let contact = contacts[indexPath.row]
        cell.contact = contact
        return cell
    }
}
