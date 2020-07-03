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
            
            if let imageData = contact?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
                       
            
            contactNumber.text = contact?.number
        }
    }
    
    let companyImageView : UIImageView = {
        let image = UIImageView(image: UIImage(named: "select_photo_empty"))
        image.contentMode        = .scaleAspectFill
        image.clipsToBounds      = true
        image.layer.cornerRadius = 20
        image.layer.borderColor  = UIColor.black.cgColor
        image.layer.borderWidth  = 1
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    } ()
    
    var contactName = UILabel()
    
    var contactNumber : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 8)
        return label
    } ()
    
    var stack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        return stack
    } ()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {
        backgroundColor = .systemGray5
        
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
        addSubview(stack)
        stack.addArrangedSubview(contactName)
        stack.addArrangedSubview(contactNumber)
        [companyImageView, stack].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            companyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            companyImageView.heightAnchor.constraint(equalToConstant: 40),
            companyImageView.widthAnchor.constraint(equalToConstant: 40),
            companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stack.leadingAnchor.constraint(equalTo: companyImageView.trailingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
