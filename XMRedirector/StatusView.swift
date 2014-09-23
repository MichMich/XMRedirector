//
//  StatusView.swift
//  XMRedirector
//
//  Created by Michael Teeuw on 11-09-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import UIKit

class StatusView: UIView {
    
    let dateFormatter = NSDateFormatter()
    
    var contact:Contact? {
        didSet {
            if contact != nil {
                stateActive = true
                contactNameLabel.text = contact!.name
                contactImageView.imageURL(NSURL(string:contact!.image)!)
                
                
                let redirect_since = dateFormatter.stringFromDate(contact!.redirect_since!)
                statusLabel.text = "Redirect since: \(redirect_since)"
                
            } else {
                stateActive = false
                contactNameLabel.text = "Forwarding Disabled"
                
            }
        }
    }
    
    var statusBarMargin:CGFloat = 20.0
    let margin:CGFloat = 20.0
    let contactImageSize:CGFloat = 100.0
    
    let contactImageView = PASImageView()
    let contactNameLabel = UILabel()
    let statusLabel = UILabel()
    let backgroundColorView = UIView()
    
    
    
    var contactNameLabelTopConstraint:NSLayoutConstraint!
    var contactNameLabelBottomConstraint:NSLayoutConstraint!
    var statusLabelBottomConstraint:NSLayoutConstraint!
    var contactImageViewTopConstraint:NSLayoutConstraint!
    
    
    var stateActive:Bool = false {
        didSet {
            updateUI()
        }
    }
    
 

    
    override init() {
        super.init()
        setup()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setup() {
        
        clipsToBounds = true

        
        contactNameLabel.textColor = UIColor.whiteColor()
        contactNameLabel.font = UIFont.systemFontOfSize(24)
        contactNameLabel.text = "Loading ..."
        contactNameLabel.textAlignment = .Center
        
        
        statusLabel.textColor = UIColor.whiteColor()
        statusLabel.font = UIFont.systemFontOfSize(12)
        statusLabel.text = ""
        statusLabel.textAlignment = .Center
        
        addSubview(backgroundColorView)
        backgroundColorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addConstraint(NSLayoutConstraint(item: backgroundColorView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundColorView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundColorView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundColorView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 0))
        backgroundColorView.alpha = 0
        
        addSubview(contactImageView)
        contactImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addConstraint(NSLayoutConstraint(item: contactImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contactImageView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0, constant: contactImageSize))
        addConstraint(NSLayoutConstraint(item: contactImageView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: contactImageSize))
        contactImageViewTopConstraint = NSLayoutConstraint(item: contactImageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        addConstraint(contactImageViewTopConstraint)
            
        addSubview(statusLabel)
        statusLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addConstraint(NSLayoutConstraint(item: statusLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        statusLabelBottomConstraint = NSLayoutConstraint(item: statusLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        addConstraint(statusLabelBottomConstraint)

        
        addSubview(contactNameLabel)
        contactNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addConstraint(NSLayoutConstraint(item: contactNameLabel, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contactNameLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        contactNameLabelTopConstraint = NSLayoutConstraint(item: contactNameLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        contactNameLabelBottomConstraint = NSLayoutConstraint(item: contactNameLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        addConstraint(contactNameLabelTopConstraint)
        addConstraint(contactNameLabelBottomConstraint)


        contactImageView.backgroundProgressColor(UIColor.whiteColor())
        contactImageView.progressColor(UIColor(red: 1, green: 0.5, blue: 0.25, alpha: 1))
        
        
        setMargins()
   
    }

    private func updateUI() {
        setMargins()
        
        UIView.animateWithDuration(0.25, delay:0, options:.LayoutSubviews | .BeginFromCurrentState, animations: { () -> Void in
            self.backgroundColorView.alpha = (self.stateActive) ? 1 : 0
            self.statusLabel.alpha = (self.stateActive) ? 1 : 0
            self.contactImageView.alpha = (self.stateActive) ? 1 : 0
            self.layoutIfNeeded()
        }, completion:nil)

        

    }
    
    func setMargins () {
        contactImageViewTopConstraint.constant = (stateActive) ? statusBarMargin + margin : 0 - contactImageSize
        contactNameLabelTopConstraint.constant = (stateActive) ? margin + statusBarMargin + contactImageSize +  (margin / 2) : statusBarMargin + margin
        contactNameLabelBottomConstraint.constant = (stateActive) ? 0 - margin * 1.75  : 0 - margin
        statusLabelBottomConstraint.constant = (stateActive) ? 0 - margin : 20
    }
    


    
}
