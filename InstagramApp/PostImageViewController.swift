//
//  PostImageViewController.swift
//  InstagramApp
//
//  Created by Julia Pettere on 3/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class PostImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var postPhotoButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var imageToPost: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        selectPhotoButton.backgroundColor = UIColor.lightGrayColor()
        previewImageView.image = nil
        previewImageView.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didSaveImage:"), name: "EndUpload", object: nil)
        
        postPhotoButton.clipsToBounds = true
        postPhotoButton.layer.cornerRadius = 2

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pickImageSelected(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
        print ("got picture")
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            self.imageToPost = resize(editedImage, newSize: CGSizeMake(750, 750))
            self.previewImageView.image = self.imageToPost
            self.previewImageView.hidden = false
            self.selectPhotoButton.alpha = 0.0
            self.dismissViewControllerAnimated(true, completion: nil)
            
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
    
    func didSaveImage(notification: NSNotification) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.tabBarController!.selectedIndex = 0
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dropKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func onSharePressed(sender: AnyObject) {
        UserMedia.postUserImage(self.imageToPost!, caption: captionTextField.text!)
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading Image"
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
