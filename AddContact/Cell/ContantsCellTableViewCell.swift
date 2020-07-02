//
//  ContantsCellTableViewCell.swift
//  AddContact
//
//  Created by Shyngys Saktagan on 7/2/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit

class ContantsCellTableViewCell: UITableViewCell {
    
    var contact : Contact?  {
        didSet {
            contactName.text = contact?.name
            contactNumber.text = contact?.number
        }
    }
    
    var contactName = UILabel()
    var contactNumber = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {
        contactNumber.text           = "Contact number"
        contactNumber.font           = UIFont.boldSystemFont(ofSize: 16)
        contactNumber.textColor      = .label
        contactNumber.translatesAutoresizingMaskIntoConstraints = false
        
        contactName.text           = "Contact NAME"
        contactName.font           = UIFont.boldSystemFont(ofSize: 16)
        contactName.textColor      = .label
        contactName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setupUI() {
        [contactName, contactNumber].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            contactName.centerYAnchor.constraint(equalTo: centerYAnchor),
            contactName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            contactNumber.centerYAnchor.constraint(equalTo: centerYAnchor),
            contactNumber.leadingAnchor.constraint(equalTo: contactName.trailingAnchor, constant: 10),
            contactNumber.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
