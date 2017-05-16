//
//  aaViewController.swift
//  NewProduct
//
//  Created by Greg  MacEachern on 2017-05-06.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

struct postStruct2 {
    let title: String!
    let price: String!
    let date: String!
    let picture: NSURL!
}

class aaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    
    @IBOutlet weak var homeTab: UITableView!
    
    var posts = [postStruct2]()
    
    var dataRef: FIRDatabaseReference!
    
    let loggedUser = FIRAuth.auth()?.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
                dataRef = FIRDatabase.database().reference()
                
                dataRef.child("posts").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
                    
                    let snapshotValueTitle = snapshot.value as? NSDictionary
                    let Title = snapshotValueTitle?["title"] as? String
                    
                    let snapshotValuePrice = snapshot.value as? NSDictionary
                    let Price = snapshotValuePrice?["price"] as? String
                
                    let snapshotValueDate = snapshot.value as? NSDictionary
                    let Date = snapshotValueDate?["date"] as? String
                    
                    let snapshotValuePic = snapshot.value as? NSDictionary
                    let pic = snapshotValuePic?["img"] as? String
                    let url = NSURL(string:pic!)
                    
                    
                    
                    self.posts.insert(postStruct2(title: Title, price: Price, date: Date, picture:url), at: 0)
                    
                   
                    
                    self.homeTab.reloadData()
                    
                })
        if (title == nil)
        {
            self.Loader.stopAnimating()
            
        }
            }
    
             func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return posts.count
            }
            
             func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
               
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2")
                
               
                
                let label1 = cell?.viewWithTag(1) as! UILabel
                label1.text = posts[indexPath.row].title
               //
            
                let label2 = cell?.viewWithTag(2) as! UILabel
                if let temp1 = posts[indexPath.row].price{
                label2.text = "$\(temp1)"
                }
            
                
                let label3 = cell?.viewWithTag(3) as! UILabel
                label3.text = posts[indexPath.row].date
                
                let img4 = cell?.viewWithTag(4) as! UIImageView
                img4.sd_setImage(with: posts[indexPath.row].picture as URL!, placeholderImage: UIImage(named: "City")!)
                img4.layer.cornerRadius = 4
                img4.clipsToBounds = true
               
                //cell?.imageView?.sd_setImage(with: posts[indexPath.row].picture as URL!, placeholderImage: UIImage(named: "City")!)
                

                return cell!
}
}
