//
//  ViewController.swift
//  AddContact
//
//  Created by Shyngys Saktagan on 7/2/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController {
    
    var contacts = [Contact]()
    
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        
        configureTableView()
        addPlusButton()
        view.backgroundColor = .white
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.register(ContantsCellTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        setTableViewDelegates()
        tableView.rowHeight = 80
        
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
        let creatContact = CreatContactVC()
        navigationController?.pushViewController(creatContact, animated: true)
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
