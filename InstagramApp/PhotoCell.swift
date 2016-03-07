//
//  PhotoCell.swift
//  InstagramApp
//
//  Created by Julia Pettere on 3/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class PhotoCell: UITableViewCell {


    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var photoImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: PFObject! {
        didSet {
            self.captionLabel.text = post["caption"] as? String
            self.photoImageView.file = post["media"] as? PFFile
            self.photoImageView.loadInBackground()
            self.usernameLabel.text = post["username"] as? String
            
            let user = post["author"] as? PFUser
            if let imageFile = user!["profilePic"] as? PFFile {
                self.profileImageView.file = imageFile
                self.profileImageView.loadInBackground()
            } else {
                self.profileImageView.backgroundColor = UIColor.whiteColor()
                self.profileImageView.image = UIImage(named: "Profile.png")
            }
            
            let createdAt = post.createdAt!
            let formatter = NSDateFormatter()
            //formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = .ShortStyle
            self.timestampLabel.text = formatter.stringFromDate(createdAt)
        }
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
