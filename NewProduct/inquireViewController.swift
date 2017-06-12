//
//  inquireViewController.swift
//  NewProduct
//
//  Created by Greg  MacEachern on 2017-06-09.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

import UIKit
import Firebase

class inquireViewController: UIViewController {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var imgprof: UIImageView!
    @IBOutlet weak var Loader: UIActivityIndicatorView!

    var loggedUser = FIRAuth.auth()?.currentUser
    var dataRef = FIRDatabase.database().reference()
    
    var code: String!
    var token: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUp()
        uploadPic()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
func SetUp()
    {
        imgprof.layer.cornerRadius = imgprof.frame.width/2
        imgprof.clipsToBounds = true
        dataRef.child("artistProfiles").child(loggedUser!.uid).child("Inquires").child(code).child("Client Name").observe(.value){
            (snap: FIRDataSnapshot) in
            self.navTitle.title = "\(snap.value as! String)'s Inquire"
            self.lblName.text = snap.value as? String
        }
        
        dataRef.child("artistProfiles").child(loggedUser!.uid).child("Inquires").child(code).child("Client Email").observe(.value){
            (snap: FIRDataSnapshot) in
            self.lblEmail.text = snap.value as? String
        }
        
        dataRef.child("artistProfiles").child(loggedUser!.uid).child("Inquires").child(code).child("Start Date").observe(.value){
            (snap: FIRDataSnapshot) in
            self.lblStart.text = "Start Date: \(snap.value as! String)"
        }
        
        dataRef.child("artistProfiles").child(loggedUser!.uid).child("Inquires").child(code).child("End Date").observe(.value){
            (snap: FIRDataSnapshot) in
            self.lblEnd.text = "End Date: \(snap.value as! String)"
        }
        
        dataRef.child("artistProfiles").child(loggedUser!.uid).child("Inquires").child(code).child("Extra Notes").observe(.value){
            (snap: FIRDataSnapshot) in
            self.lblNotes.text = "Extra Notes: \(snap.value as! String)"
        }
        dataRef.child("artistProfiles").child(loggedUser!.uid).child("Inquires").child(code).child("token").observe(.value){
            (snap: FIRDataSnapshot) in
            self.token = snap.value as? String
        }
        
        
    }
  
    func uploadPic()
    {
        dataRef.child("users").child(token).observeSingleEvent(of: .value, with: {  (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]
            {
                
                if let profileImageURL = dict["pic"] as? String
                {
                    
                    
                    let url = URL(string: profileImageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async {
                            
                            if data == nil
                            {
                                self.Loader.stopAnimating()
                            }
                            else
                            {
                                self.imgprof?.image = UIImage(data: data!)
                                self.Loader.stopAnimating()
                            }
                            
                            
                        }
                        
                    }).resume()
                    
                }
                else{
                    self.Loader.stopAnimating()
                }
            }
        })

    }

}
