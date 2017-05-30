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
    let name: String!
    let price: String!
    let skills: String!
    let picture: NSURL!
    let token: String!
}


class aaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    
    @IBOutlet weak var homeTab: UITableView!
    
    var posts = [postStruct2]()
    
    var dataRef: FIRDatabaseReference!
    var cellNumber : Int!
    var cellID: String!
    
    
    
    let loggedUser = FIRAuth.auth()?.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //without this method, the code would run to fast and the data wouldnt have time to load, giving nil which casued it to crash
        let delayInSeconds = 0.2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {}
        
        self.posts.removeAll()
        
                dataRef = FIRDatabase.database().reference()
        
        //grabbing the title, price, date and picture to a structure and storing that in an array
                dataRef.child("artistProfiles").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
//                    
                    if snapshot.exists() == true{
                    let snapshotValueName = snapshot.value as? NSDictionary
                    let name = snapshotValueName?["name"] as? String

                    let snapshotValuePrice = snapshot.value as? NSDictionary
                    let Price = snapshotValuePrice?["Price1_0"] as? String
                
                    let snapshotValueDate = snapshot.value as? NSDictionary
                    let Skills = snapshotValueDate?["skills"] as? String

                    let snapshotValuePic = snapshot.value as? NSDictionary
                        var url = NSURL()
                    if let pic = snapshotValuePic?["pic"] as? String
                    {
                        url = NSURL(string:pic)!
                       
                    }
                    else{
                        url = NSURL(string:"")!
                    
                        }
                        
                    let snapshotValueToken = snapshot.value as? NSDictionary
                    let Token = snapshotValueToken?["token"] as? String
                        
                        
                    self.posts.insert(postStruct2(name: name, price: Price, skills: Skills, picture:url, token: Token), at: 0)
                    }
                    else
                    {
                        let alertContoller = UIAlertController(title: "Oops!", message: "Please Enter a Username/Password", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertContoller.addAction(defaultAction)
                        
                        self.present(alertContoller, animated:true, completion: nil)
                    }
                    
                    
                    
                   
                   
                    
                   
                    
                    self.homeTab.reloadData()
                    
                })
        
        //if the title is non existant (post doesn't exist), the activity moniter stops
        if (title == nil)
        {
            self.Loader.stopAnimating()
            
        }
            }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
                                        //TABLE FUNCTIONS
    
             func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                //creates as many rows as there are posts
                return posts.count
            }
            
             func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                //creates a cell in the table and sets information based on the tag (Check tag in main.storyboard)
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2")
                
               
                
                let label1 = cell?.viewWithTag(1) as! UILabel
                label1.text = posts[indexPath.row].name
                
            
                let label2 = cell?.viewWithTag(2) as! UILabel
                if let temp1 = posts[indexPath.row].price{
                label2.text = "$\(temp1)"
                }
            
                
                let label3 = cell?.viewWithTag(3) as! UILabel
                label3.text = posts[indexPath.row].skills
                
                
                //not as functional as I want. Sets picture fine but if the user changes their propfile pic, this doesnt update it. This is in the method of sending the picture to the database, not so much setting it
                let img4 = cell?.viewWithTag(4) as! UIImageView
                img4.sd_setImage(with: posts[indexPath.row].picture as URL!, placeholderImage: UIImage(named: "City")!)
                img4.layer.cornerRadius = 4
                img4.clipsToBounds = true
 
                return cell!
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellNumber = indexPath.row
        
        
//        dataRef.child("artistProfiles").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
//            
//            let snapshotValueName = snapshot.value as? NSDictionary
//            let token = snapshotValueName?["name"] as? String
//            self.cellID = token
//            
//        })
        self.cellID = posts[cellNumber].token
//        print("token is \(self.cellID)")
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "Artist") as! ArtistViewController

            myVC.token = self.cellID!
        
//            print(myVC.token)
            self.present(myVC, animated: true)
    
        
        
        
//        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
     
        self.viewDidLoad()
    }
    
    
}
