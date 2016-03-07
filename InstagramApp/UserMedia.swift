//
//  UserMedia.swift
//  InstagramApp
//
//  Created by Julia Pettere on 3/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import Parse

class UserMedia: NSObject {
    
    class func postProfileImage(image: UIImage?) {
        let user = PFUser.currentUser()!
        user["profilePic"] = getPFFileFromImage(image)
        
        user.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("successfully updated profile image")
            } else {
                print("did not update profile image")
            }
            NSNotificationCenter.defaultCenter().postNotificationName("EndProfileUpload", object: nil)
        }
    }
    
    class func postUserImage(image: UIImage?, caption: String?) {
        let media = PFObject(className: "userMedia")
        media["media"] = getPFFileFromImage(image)
        media["author"] = PFUser.currentUser()
        media["username"] = PFUser.currentUser()!.username
        media["caption"] = caption
        
        media.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("successfully saved image")
            } else {
                print("did not save image")
            }
            NSNotificationCenter.defaultCenter().postNotificationName("EndUpload", object: nil)
        }
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                print("got image")
                return PFFile(name: "image.png", data: imageData)
            }
        }
        print("could not get image")
        return nil
    }
    
    class func getPosts(predicate: String?, completion: (posts: [PFObject]?, error: NSError?) -> ()) {
        var query: PFQuery
        if predicate != nil {
            let predicate = NSPredicate(format: predicate!)
            query = PFQuery(className: "userMedia", predicate: predicate)
        } else {
            query = PFQuery(className: "userMedia")
        }
        query.includeKey("author")
        query.orderByDescending("_created_at")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock{ (media: [PFObject]?, error: NSError?) -> Void in
            if let unwrappedMedia = media {
                completion(posts: unwrappedMedia, error: nil)
                
                print("got media" + String(unwrappedMedia))
            } else {
                completion(posts: nil, error: error)
                print("failed to get media")
            }
        }
    }
}
