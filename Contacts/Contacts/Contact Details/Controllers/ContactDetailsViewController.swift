//
//  ContactDetailsViewController.swift
//  Contacts
//
//  Created by Supriyo Mondal on 01/03/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import UIKit

protocol TextFieldScrollViewDelegate {
    func scrollToTextField(_ textField: UITextField)
}

class ContactDetailsViewController: UIViewController {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuOptionsStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullNameToMenuOptionsConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var detailsTableView: UITableView!
    
    var contactDetailsViewModel: ContactDetailsViewModelProtocol!
    var imagePicker = UIImagePickerController()
    weak var activeTF: UITextField?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        detailsTableView.tableFooterView = UIView()
        profilePicImageView.layer.cornerRadius = self.profilePicImageView.bounds.height/2
        profilePicImageView.clipsToBounds = true
        
        if self.presentingViewController != nil {
            setupNavigationBarButtonItemsWhenPresented()
            toggleEditButton(self.navigationItem.rightBarButtonItem!, true)
        } else {
            setupNavigationBarButtonItemsWhenPushed()
        }
        navigationController?.navigationBar.tintColor = Constants.Color.navBarColor
        
        renderDataOnView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardNotifications()
    }
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func deRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
        
    private func setupNavigationBarButtonItemsWhenPushed() {
        
        let rightBarButton = UIBarButtonItem(title: Constants.BarButtonTitle.EDIT,
                                             style: .plain,
                                             target: self,
                                             action: #selector(editButtonTapped(_:)))
                
        rightBarButton.tag = contactDetailsViewModel.isInEditMode ? 1 : 0
        rightBarButton.title = contactDetailsViewModel.isInEditMode ? Constants.BarButtonTitle.DONE : Constants.BarButtonTitle.EDIT
        cameraButton.isHidden = contactDetailsViewModel.isInEditMode ? false : true
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupNavigationBarButtonItemsWhenPresented() {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //set cancel and done bar button item
        let cancelBarButtonItem = UIBarButtonItem(title: Constants.BarButtonTitle.CANCEL,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(cancelButtonClicked(_:)))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        let doneBarButtonItem = UIBarButtonItem(title: Constants.BarButtonTitle.DONE,
                                                style: .done,
                                                target: self,
                                                action: #selector(doneButtonClicked(_:)))
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    func renderDataOnView() {
        self.profilePicImageView.image = contactDetailsViewModel.profileImage
        self.fullNameLbl.text = contactDetailsViewModel.fullName
        if contactDetailsViewModel.isFavourite {
            self.favoriteButton.isSelected = true
        } else {
            self.favoriteButton.isSelected = false
        }
    }
}

extension ContactDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactDetailsViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailTableViewCell.identifier, for: indexPath) as? ContactDetailTableViewCell else {
            return UITableViewCell()
        }
        cell.textFieldDelegate = self
        cell.configure(viewModel: contactDetailsViewModel, indexPath: indexPath)
        return cell
    }
}

// Menu Actions
extension ContactDetailsViewController {
    
    @IBAction func messageButtonTapped(_ sender: UIButton) {
        guard  let messageURL = contactDetailsViewModel.messageURL else {
            UIAlertController.show("Contact number not valid.", from: self, completion: nil)
            return
        }
        UIApplication.shared.open(messageURL, options: [:], completionHandler: nil)
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        guard  let telURL = contactDetailsViewModel.telURL else {
            UIAlertController.show("Contact number not valid.", from: self, completion: nil)
            return
        }
        UIApplication.shared.open(telURL, options: [:], completionHandler: nil)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard  let mailURL = contactDetailsViewModel.mailURL else {
            UIAlertController.show("Contact email not valid.", from: self, completion: nil)
            return
        }
        UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
    }
}

//Button Actions
extension ContactDetailsViewController {
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        contactDetailsViewModel.makeContactFavourite()
        renderDataOnView()
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        if sender.tag == 0 { // Edit button clicked
            toggleEditButton(sender, true)
            contactDetailsViewModel.isInEditMode = true
        } else { // Done button clicked
            toggleEditButton(sender, false)
            contactDetailsViewModel.updateContactDetails()
            contactDetailsViewModel.isInEditMode = false
        }
        detailsTableView.reloadData()
        renderDataOnView()
    }
    
    @objc func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        let success = contactDetailsViewModel.isContactValid()
        if success {
            contactDetailsViewModel.createContactDetails()
            dismiss(animated: true, completion: nil)
        } else {
            UIAlertController.show(Constants.AlertMessages.validationError, from: self, completion: nil)
        }
    }
    
    fileprivate func toggleEditButton(_ button: UIBarButtonItem, _ editClicked: Bool) {
        button.tag = editClicked ? 1 : 0
        button.title = editClicked ? Constants.BarButtonTitle.DONE : Constants.BarButtonTitle.EDIT
        cameraButton.isHidden = editClicked ? false : true
        self.imageViewBottomConstraint.priority = editClicked ? .defaultHigh : .defaultLow
        self.fullNameToMenuOptionsConstraint.priority = editClicked ? .defaultLow : .defaultHigh
        self.menuOptionsStackViewConstraint.constant = editClicked ? 0 : 62
        self.fullNameLbl.isHidden = editClicked
    }
}

// Keyboard Related Events
extension ContactDetailsViewController: TextFieldScrollViewDelegate {
    func scrollToTextField(_ textField: UITextField) {
        self.activeTF = textField
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if activeTF != nil { // this method will get called even if a system generated alert with keyboard appears over the current VC.
            let info: NSDictionary = notification.userInfo! as NSDictionary
            let value: NSValue = info.value(forKey: UIResponder.keyboardFrameBeginUserInfoKey) as! NSValue
            let keyboardSize: CGSize = value.cgRectValue.size
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            let activeTextFieldRect: CGRect? = activeTF?.frame
            let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
            if (!aRect.contains(activeTextFieldOrigin!)) {
                scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        activeTF = nil
    }
}
