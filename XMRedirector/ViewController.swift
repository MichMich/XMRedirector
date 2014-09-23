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

struct Contact {
    var name:String
    var number:String
    var image:String
}



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let contacts:[Contact] = [
        Contact(name: "Raymond", number: "06 54 25 72 31", image: "https://pbs.twimg.com/profile_images/2702827401/b7a754378f178d0e1d1bad94c81ce1b3_400x400.jpeg"),
        Contact(name: "Michael", number: "06 51 71 36 15", image: "https://pbs.twimg.com/profile_images/1195146498/image.jpg"),
        Contact(name: "Natascha", number: "06 21 50 03 16", image: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xaf1/v/t1.0-1/c34.34.431.431/s160x160/398797_103835056418671_925295838_n.jpg?oh=2e258b1b3c7854ec920c75a176a317df&oe=549A06EF&__gda__=1418848380_874d680813abad787cbb71ceb5b9e2ab"),
        Contact(name: "Valerie", number: "06 10 43 28 29", image: "https://pbs.twimg.com/profile_images/505471251461468160/7MkDuGla_400x400.jpeg"),
    ]
    
    let statusBarBackgroundView = UIView()
    let statusView = StatusView()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(ContactTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.Contact.toRaw())
        tableView.registerClass(ActionTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.Action.toRaw())
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
                return (statusView.contact != nil) ? 1 : 0 // TODO: should come out of the model
            case 1:
                //contacts
                return contacts.count
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
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Action.toRaw(), forIndexPath: indexPath) as ActionTableViewCell
                cell.actionNameLabel.text = "Cancel Call Forwarding"
                cell.actionImageView.image = UIImage(named: "cancel")
                return cell
            
            case 1:
                //contacts
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Contact.toRaw(), forIndexPath: indexPath) as ContactTableViewCell
                let contact = contacts[indexPath.row]
                cell.contactImageView.imageURL(NSURL(string: contact.image))
                cell.contactNameLabel.text = contact.name
                cell.contactDetailLabel.text = contact.number
                return cell
            
            case 2:
                //add contact
                let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.Action.toRaw(), forIndexPath: indexPath) as ActionTableViewCell
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
                statusView.contact = nil
            case 1:
                statusView.contact = contacts[indexPath.row]
            case 2:
                println("Add contact")
            default:
                println("Unknow action")
        }
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}