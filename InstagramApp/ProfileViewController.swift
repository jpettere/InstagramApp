//
//  ProfileViewController.swift
//  InstagramApp
//
//  Created by Julia Pettere on 3/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var updateProfileButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var imageToUpload: UIImage?
    var currentUser = PFUser.currentUser()
    var profileUser: PFUser?
    var user: PFUser?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureState()
        
        if profileUser != nil {
            user = profileUser
            if profileUser != currentUser {
                updateProfileButton.hidden = true
            }
        } else {
            user = currentUser
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didEndUpload:"), name: "EndProfileUpload", object: nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let imageFile = user!["profilePic"] as? PFFile {
            self.profileImageView.file = imageFile
            self.profileImageView.loadInBackground()
        } else {
            self.profileImageView.image = UIImage(named: "Profile.png")
        }
        
    }

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        PFUser.logOut()
        
        if (PFUser.currentUser() == nil) {
            print("You are logged out")
        }
        performSegueWithIdentifier("logoutSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureState() {
        
        //logoutButton.tintColor = UIColor.whiteColor()
        //logoutButton.backgroundColor = UIColor.redColor()
        logoutButton.clipsToBounds = true
        logoutButton.layer.cornerRadius = 10
        
        //updateProfileButton.backgroundColor = UIColor.lightGrayColor()
    }
    
    @IBAction func onUpdateProfilePicPressed(sender: AnyObject) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
        viewDidAppear(true)
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            let image = info[UIImagePickerControllerEditedImage] as! UIImage
            self.imageToUpload = resize(image, newSize: CGSizeMake(750, 750))
            self.profileImageView.image = self.imageToUpload
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Updating"
            UserMedia.postProfileImage(self.imageToUpload)
    }
    
    func didEndUpload(notification: NSNotification) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.view.alpha = 1
    }
    
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
