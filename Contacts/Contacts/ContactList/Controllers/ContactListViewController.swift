//
//  ContactListViewController.swift
//  Contacts
//
//  Created by Supriyo Mondal on 29/02/20.
//  Copyright © 2020 Supriyo Mondal. All rights reserved.
//

import UIKit

protocol ContactViewDelegate {
    func updateRowAtIndexPath(indexPath: IndexPath)
}

let showContactDetailsIdentifier = "showContactDetails"

class ContactListViewController: UIViewController {
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var contactsListViewModel: ContactsListViewModelProtocol!
    
    required init?(coder: NSCoder) {
        self.contactsListViewModel = ContactsListViewModel(model: [])
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactsTableView.tableFooterView = UIView()
        self.contactsTableView.sectionIndexBackgroundColor = .clear
        getAllContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contactsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func getAllContacts() {
        self.activityIndicator.startAnimating()
        contactsListViewModel.getContacts { [unowned self] (error) in
            if error != nil {
                UIAlertController.show(Constants.AlertMessages.serviceError, from: self, completion: { (action) in
                    self.activityIndicator.stopAnimating()
                    self.getAllContacts()
                })
            } else {
                self.activityIndicator.stopAnimating()
                self.contactsTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showContactDetailsIdentifier {
            let contactDetailsVC = segue.destination as! ContactDetailsViewController
            //contactDetailsVC.contactDetailsViewModel = ContactDetailsViewModel(contact: sender as? Contact)
        }
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let contactDetailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailsController") as! ContactDetailsViewController
        let navigationController = UINavigationController(rootViewController: contactDetailsVC)

        self.present(navigationController, animated: true, completion: nil)
    }
}

extension ContactListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        contactsListViewModel.numberOfSections
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        contactsListViewModel.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        contactsListViewModel.titleForSection(index: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactsListViewModel.numberOfRowsInSection(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        guard let contact = contactsListViewModel.contactForIndexPath(indexPath: indexPath) else {
            return cell
        }
        cell.configure(contact: contact)
        return cell
    }
}

extension ContactListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mainContact = contactsListViewModel.contactForIndexPath(indexPath: indexPath) {
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            contactsListViewModel.getContact(id: mainContact.id!) { (contact, error) in
                mainContact.phoneNumber = contact?.phoneNumber
                mainContact.email = contact?.email
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                if contact != nil {
                    self.performSegue(withIdentifier: showContactDetailsIdentifier, sender: mainContact)
                } else {
                    UIAlertController.show(Constants.AlertMessages.serviceError, from: self, completion: nil)
                }
            }
        }
    }
}
