//
//  SettingsViewController.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 28/5/23.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    
    // MARK: Properties
    private let settingsViewModel = SettingsViewModel()
    private let dataPersistenceViewModel = DataPersistenceViewModel()
    var contactsModel: [Contact] = [Contact]()
    var settingsModel: [Setting] = [Setting]()
    let deleteButton = UIButton()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        deleteButton.backgroundColor = .systemRed
    }
    
    @objc func didClickDeleteButton(sender: UIButton) {
        showAlert(sender)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == settingsTableView) {
            return settingsModel.count
        }
        return contactsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == settingsTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsViewCell
            tableView.allowsSelection = false
            cell?.backgroundColor = .clear
            cell?.setup(icon: settingsModel[indexPath.row].icon,
                        title: settingsModel[indexPath.row].title,
                        action: settingsModel[indexPath.row].actionItem,
                        screenWidth: self.view.frame.width)
            
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as? ContactsViewCell
            cell?.backgroundColor = .clear
            cell?.setup(linkTitle: contactsModel[indexPath.row].title,
                        path: contactsModel[indexPath.row].path)
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == contactsTableView) {
            settingsViewModel.makeHyperLink(contactsModel[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == settingsTableView) {
            return tableView.frame.height / CGFloat(settingsModel.count)
        }
        else {
            return tableView.frame.height / CGFloat(contactsModel.count)
        }
    }
}

extension SettingsViewController {
    private func updateUI() {
        DispatchQueue.main.async {
            self.settingsTableView.reloadData()
            self.contactsTableView.reloadData()
        }
    }
    
    private func statsDeleted() {
        deleteButton.isEnabled = false
    }
    
    private func setUpView() {
        settingsTableView.isScrollEnabled = false
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.layer.cornerRadius = 10
        
        contactsTableView.isScrollEnabled = false
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.layer.cornerRadius = 10
        profileView.layer.cornerRadius = 10
        
        let deleteIcon = UIImage(systemName: "exclamationmark.triangle", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        let trashImage = UIImage(systemName: "trash",withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        deleteButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        deleteButton.setImage(trashImage, for: .normal)
        deleteButton.tintColor = .white
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.layer.cornerRadius = 10
        deleteButton.addTarget(self, action: #selector(didClickDeleteButton(sender:)), for: .touchUpInside)

        settingsModel = [
            Setting(icon: deleteIcon ?? UIImage(), title: Constants.deleteMessage, pickerItem: nil ,actionItem: deleteButton)]
        
        contactsModel = [
            Contact(title: Constants.twitterTitle, path: Constants.twitterPath),
            Contact(title: Constants.linkedinTitle, path: Constants.linkedinPath)]
    }
}

extension SettingsViewController {
    private func showAlert(_ sender: UIButton) {
        // Create new Alert
        let dialogMessage = UIAlertController(title: "Confirm", message: Constants.deleteAlertMessage, preferredStyle: .alert)
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in
            sender.backgroundColor = .systemGreen
            //sender.isEnabled = false
 
            self.dataPersistenceViewModel.deleteAllWishlistTitles()
         })
        // Create CANCEL button with action handler
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        //Add CANCEL button to a dialog message
        dialogMessage.addAction(cancel)
        
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
