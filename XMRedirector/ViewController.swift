//
//  ViewController.swift
//  XMRedirector
//
//  Created by Michael Teeuw on 11-09-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import UIKit

enum CellIdentifiers: String {
    case Contact = "CellIdentifierContact"
    case Action = "CellIdentifierAction"
}




class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ContactsDelegate {
    
    let statusBarBackgroundView = UIView()
    let statusView = StatusView()
    let tableView = UITableView()
    var refreshControl = UIRefreshControl()
    
    
    let contacts = Contacts()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(ContactTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.Contact.rawValue)
        tableView.registerClass(ActionTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.Action.rawValue)
        

        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        
        contacts.delegate = self
        contacts.fetchContacts()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        statusView.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.New, context: nil)
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        statusView.removeObserver(self, forKeyPath: "center")
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    override func viewDidLayoutSubviews() {
        tableView.contentInset = UIEdgeInsetsMake(statusView.frame.size.height, 0, 0, 0)
        //tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
}

// MARK: - KVO
extension ViewController {
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
        if object as NSObject == statusView {
            tableView.contentInset = UIEdgeInsetsMake(statusView.frame.size.height, 0, 0, 0)
        }
    }
    
}

// MARK: - Private Functions
extension ViewController {

    private func setupInterface() {
        
        //tableView
        view.addSubview(tableView)
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //statusView
        view.addSubview(statusView)
        statusView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //statusBarBackgroundView
        view.addSubview(statusBarBackgroundView)
        statusBarBackgroundView.setTranslatesAutoresizingMaskIntoConstraints(false)
        

        
        //add constraints
        let views = ["statusBarBackgroundView":statusBarBackgroundView,"statusView":statusView,"tableView":tableView]
        let metrics = ["statusBarHeight":20]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[statusBarBackgroundView]|", options: nil, metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[statusView]|", options: nil, metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: nil, metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[statusBarBackgroundView(statusBarHeight)]", options: nil, metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[statusView]", options: nil, metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: nil, metrics: metrics, views: views))
        
    
        statusBarBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        statusView.backgroundColor = UIColor(red: 153/255.0, green: 204/255.0, blue: 1, alpha: 1)
        statusView.backgroundColorView.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0.25, alpha: 1)
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
    }
    
    func refresh(sender:AnyObject)
    {
        contacts.fetchContacts()
    }
    
    func redirectTo(contact:Contact) {
        HUDController.sharedController.contentView = HUDContentView.ProgressView()
        HUDController.sharedController.show()
        
        
        Api.performRequestWithUri("redirect/\(contact.id)") {
            (json, error) -> () in
            if (error != nil) {
                self.showError("Could not perform redirect request.")
            } else {
                if json?["success"].boolValue == false {
                    self.showError(json?["message"].stringValue ?? "Unknow error")
                }
            }
            self.contacts.fetchContacts()
            HUDController.sharedController.hide()
        }
    }
    
    func removeRedirect() {
        HUDController.sharedController.contentView = HUDContentView.ProgressView()
        HUDController.sharedController.show()
        
        Api.performRequestWithUri("redirect") {
            (json, error) -> () in
            if (error != nil) {
                self.showError("Could not perform redirect request.")
            } else {
                if json?["success"].boolValue == false {
                    self.showError(json?["message"].stringValue ?? "Unknow error")
                }
            }
            self.contacts.fetchContacts()
            HUDController.sharedController.hide()
        }
    }
    
    func showError(message:String) {
        showAlert("Error", message: message)
    }
    func showAlert(title:String, message:String) {
        var myAlertView = UIAlertView()
        
        myAlertView.title = title
        myAlertView.message = message
        myAlertView.addButtonWithTitle("Ok")
        
        myAlertView.show()
    }
    
}

// MARK: - TableView Datasource
extension ViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                //disable forwarding
                return (contacts.activeContact() != nil) ? 1 : 0 
            case 1:
                //contacts
                return contacts.list.count
            case 2:
                //add contact
                return 0 // disabled
            default:
                return 0
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Action.rawValue, forIndexPath: indexPath) as ActionTableViewCell
                cell.actionNameLabel.text = "Cancel Call Forwarding"
                cell.actionImageView.image = UIImage(named: "cancel")
                return cell
            
            case 1:
                //contacts
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Contact.rawValue, forIndexPath: indexPath) as ContactTableViewCell
                let contact = contacts.list[indexPath.row]
                cell.contactImageView.imageURL(NSURL(string: contact.image)!)
                cell.contactNameLabel.text = contact.name
                cell.contactDetailLabel.text = contact.number
                cell.active = contact.redirect_since != nil
            
                return cell
            
            case 2:
                //add contact
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Action.rawValue, forIndexPath: indexPath) as ActionTableViewCell
                cell.actionNameLabel.text = "Add Contact"
                cell.actionImageView.image = UIImage(named: "add")
                return cell
            
            default:
                return UITableViewCell()
        }
   
    }
}

// MARK: - TableView Delegate
extension ViewController {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
            case 0:
                removeRedirect()
            case 1:
                redirectTo(contacts.list[indexPath.row])
            case 2:
                println("Add contact")
            default:
                println("Unknow action")
        }
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}

// MARK: - ContactsDelegate
extension ViewController {
    
    func contactsUpdated() {
        tableView.reloadData()
        self.refreshControl.endRefreshing()
        statusView.contact = contacts.activeContact()
    }
    
    func contactsUpdateFailed() {
        self.refreshControl.endRefreshing()
    }
}