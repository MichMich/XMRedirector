//
//  Contacts.swift
//  XMRedirector
//
//  Created by Michael Teeuw on 23/09/14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import Foundation


struct Contact {
    var id:Int
    var name:String
    var number:String
    var image:String
    var redirect_since:NSDate?
}


class Contacts {
    
    class var sharedInstance : Contacts {
        struct Static {
            static let instance : Contacts = Contacts()
        }
        return Static.instance
    }
    
    
    var delegate: ContactsDelegate?
    var list = [Contact]()
    
    let dateFormatter = NSDateFormatter()
    
    
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    func fetchContacts() {
        Api.sharedInstance.performRequestWithUri("numbers") {
            (json, error) -> () in
            if (error != nil) {
                println("Error: \(error)")
                self.delegate?.contactsUpdateFailed?()
            } else {
                
                if let contacts = json?.arrayValue {
                    
                    
                    var newContacts = [Contact]()
                 
                    for contact in contacts {
                        
                        let id = contact["id"].intValue ?? 0
                        let name = contact["name"].stringValue ?? "Unknown"
                        let number = contact["number"].stringValue ?? "Unknown"
                        let image = contact["image"].stringValue ?? "Unknown"
                        
                        var redirect_since:NSDate?
                        if let redirect_since_string  =  contact["redirect_since"].stringValue ?? nil {
                            redirect_since = self.dateFormatter.dateFromString(redirect_since_string)
                        }
                        
                        newContacts.append(Contact(id: id, name: name, number: number, image: image, redirect_since: redirect_since))
                        
                        
                        
                    }
                    
                    self.list = newContacts
                    self.delegate?.contactsUpdated?()
                    
                }
            }
        }
            
    }
    
    func activeContact() -> Contact? {
        for contact in list {
            if contact.redirect_since != nil {
                return contact
            }
        }
        
        return nil
    }
}

@objc protocol ContactsDelegate {
    
    optional func contactsUpdated()
    optional func contactsUpdateFailed()
    
}