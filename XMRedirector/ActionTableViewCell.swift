//
//  ActionTableViewCell.swift
//  XMRedirector
//
//  Created by Michael Teeuw on 15-09-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {

    let imageViewSize = 60
    let leftMargin = 12
    
    
    let actionImageView = UIImageView()
    let actionNameLabel = UILabel()

    
    
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
    
    override init?(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        contentView.addSubview(actionImageView)
        actionImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // add contact name label
        contentView.addSubview(actionNameLabel)
        actionNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        let views = ["actionImageView":actionImageView,"actionNameLabel":actionNameLabel]
        let metrics = ["leftMargin":leftMargin,"imageViewSize":imageViewSize]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(leftMargin)-[actionImageView]-[actionNameLabel]", options: nil, metrics: metrics, views: views))
        contentView.addConstraint(NSLayoutConstraint(item: actionNameLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))

        
        contentView.addConstraint(NSLayoutConstraint(item: actionImageView, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1, constant: -10))
        contentView.addConstraint(NSLayoutConstraint(item: actionImageView, attribute: .Width, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1, constant: -10))
        
        contentView.addConstraint(NSLayoutConstraint(item: actionImageView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0))

        
        actionNameLabel.text = "Action"
    }
    
    private func setupAppearance() {
        backgroundColor = UIColor(white: 0.85, alpha: 1)
        actionNameLabel.font = UIFont.boldSystemFontOfSize(16)
        actionNameLabel.textColor = UIColor.whiteColor()

    }


}
