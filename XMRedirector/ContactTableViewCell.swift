//
//  ContactTableViewCell.swift
//  XMRedirector
//
//  Created by Michael Teeuw on 11-09-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    let contactImageViewSize:CGFloat = 60
    let leftMargin = 12
    
    
    let contactImageView = PASImageView()
    let contactNameLabel = UILabel()
    let contactDetailLabel = UILabel()
    
    
    override init() {
        super.init()
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup() {
        setupViews()
        setupAppearance()
    }
    
    private func setupViews() {
        // add contact image view
        contentView.addSubview(contactImageView)
        contactImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // add contact name label
        contentView.addSubview(contactNameLabel)
        contactNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // add contact detail label
        contentView.addSubview(contactDetailLabel)
        contactDetailLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let views = ["civ":contactImageView,"cnl":contactNameLabel,"cdl":contactDetailLabel]
        let metrics = ["leftMargin":leftMargin,"cis":contactImageViewSize]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(leftMargin)-[civ]-[cnl]", options: nil, metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(leftMargin)-[civ]-[cdl]", options: nil, metrics: metrics, views: views))

        contentView.addConstraint(NSLayoutConstraint(item: contactImageView, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1, constant: -10))
        contentView.addConstraint(NSLayoutConstraint(item: contactImageView, attribute: .Width, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1, constant: -10))

        contentView.addConstraint(NSLayoutConstraint(item: contactImageView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))

        
        contentView.addConstraint(NSLayoutConstraint(item: contactNameLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 0.55, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: contactDetailLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 0.55, constant: 0))
        
        contactNameLabel.text = "Name"
        contactDetailLabel.text = "Detail"

    }

    private func setupAppearance() {
        backgroundColor = UIColor.clearColor()
        contactNameLabel.font = UIFont.systemFontOfSize(16)
        contactDetailLabel.font = UIFont.systemFontOfSize(12)
        
        contactDetailLabel.textColor = UIColor(white: 0.5, alpha: 1)
        
        contactImageView.backgroundProgressColor(UIColor.whiteColor())
        contactImageView.progressColor(UIColor(red: 1, green: 0.5, blue: 0.25, alpha: 1))
    }
}
