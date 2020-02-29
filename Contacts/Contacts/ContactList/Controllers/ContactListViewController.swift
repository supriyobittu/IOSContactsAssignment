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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contactsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
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
    }
}
