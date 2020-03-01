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
    private var contactDetailsViewModel: ContactDetailsViewModelProtocol!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        valueTF.delegate = self
    }

    func configure(viewModel: ContactDetailsViewModelProtocol, indexPath: IndexPath) {
        contactDetailsViewModel = viewModel
        let detailsData = viewModel.keyValuePairForContactDetailAtIndexPath(indexPath: indexPath)
        titleLbl.text =  detailsData.0
        valueTF.text = detailsData.1
        valueTF.placeholder = detailsData.2
        
        if contactDetailsViewModel.isInEditMode {
            valueTF.isEnabled = true
        } else {
            valueTF.isEnabled = false
        }
        if titleLbl.text == Constants.ContactDetailKeys.mobile {
            valueTF.keyboardType = .numberPad
        } else {
            valueTF.keyboardType = .default
        }
    }
}

extension ContactDetailTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        contactDetailsViewModel.saveForTitle(titleLbl.text ?? "", value: textField.text ?? "")
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
