//
//  ContactDetailTableViewCell.swift
//  Contacts
//
//  Created by Supriyo Mondal on 01/03/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import UIKit

class ContactDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: UITextField!
    
    var textFieldDelegate: TextFieldScrollViewDelegate?
    
    static let identifier = "ContactDetailTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        valueTF.delegate = self
    }

}

extension ContactDetailTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textFieldDelegate?.scrollToTextField(textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        valueTF?.resignFirstResponder()
        return true
    }
}
