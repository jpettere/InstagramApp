//
//  PhotosViewController.swift
//  InstagramApp
//
//  Created by Julia Pettere on 3/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var posts: [PFObject]?
    var post: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300


    }
    
    override func viewWillAppear(animated: Bool) {
        UserMedia.getPosts(nil, completion: { (posts, error) -> () in
            self.posts = posts!
            self.tableView.reloadData()
        })
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*if posts != nil {
            return posts!.count
        } else {
            return 0
        }*/
        
        if let photoPosts = posts {
            return photoPosts.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.post = posts![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        cell.post = posts![indexPath.row]
        return cell
    }
    
    @IBAction func profilePicturePressed(sender: AnyObject) {
        performSegueWithIdentifier("profileSegue", sender: nil)
    }
    
    @IBAction func backToHomeScreen(segue:UIStoryboardSegue) {
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
