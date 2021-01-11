//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Bagus setiawan on 15/10/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var bubbleMessageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarLeftImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bubbleMessage()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bubbleMessage() {
        self.bubbleMessageView?.layer.cornerRadius = bubbleMessageView.frame.size.height / 5
    }
    
    
}
