//
//  BookingViewController.swift
//  NewProduct
//
//  Created by Greg  MacEachern on 2017-06-02.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class BookingViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var lblPrice1: UILabel!
    @IBOutlet weak var lblPrice2: UILabel!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    
    var posts:[String?] = ["Nothing Here!","Nothing Here!","Nothing Here!"]
    var posts2:[String?] = ["Nothing Here!","Nothing Here!","Nothing Here!"]
    var dataRef = FIRDatabase.database().reference()
    var userID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetUp()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //sets the label in the cell to be data from the array "posts" which is a string of values grabbed from the database
        
        if tableView == tableView1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            
            let tb1 = cell?.viewWithTag(1) as! UILabel
            tb1.text = posts[indexPath.row]!
            
            return cell!
        }
            
        else
        {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2")
            
            let tb1 = cell2?.viewWithTag(2) as! UILabel
            tb1.text = posts2[indexPath.row]!
            
            return cell2!
            
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //count = indexPath.row
        // print(count)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }

    

   func SetUp()
    {
        dataRef.child("artistProfiles").child(self.userID).child("Name").observe(.value){
            (snap: FIRDataSnapshot) in
            self.navTitle.title = snap.value as? String
        }
        
        dataRef.child("artistProfiles").child(self.userID).child("Price1").child("Pricing1").observe(.value){
            (snap: FIRDataSnapshot) in
            if snap.exists() == true{
            self.lblPrice1.text = "$\(snap.value as! String)"
            }
            else
            {
                self.lblPrice1.text = "Not Set"
            }
            
        }
        
        dataRef.child("artistProfiles").child(self.userID).child("Price2").child("Pricing2").observe(.value){
            (snap: FIRDataSnapshot) in
            if snap.exists() == true
            {
            self.lblPrice2.text = "$\(snap.value as! String)"
            }
            else {
                self.lblPrice2.text = "Not Set"
            }
            
        }
        
        dataRef.child("artistProfiles").child(self.userID).child("Price1").child("Price1_0").observe(.value){
            (snap: FIRDataSnapshot) in
            let temp1: String!
            temp1 = snap.value as? String
            if temp1 != nil
            {
                self.posts[0] = temp1!
                self.tableView1.reloadData()
            }
           
        }
        dataRef.child("artistProfiles").child(self.userID).child("Price1").child("Price1_1").observe(.value){
            (snap: FIRDataSnapshot) in
            let temp2: String!
            temp2 = snap.value as? String
            if temp2 != nil
            {
                self.posts[1] = temp2!
                self.tableView1.reloadData()
            }
         
        }
        
        
        dataRef.child("artistProfiles").child(self.userID).child("Price1").child("Price1_2").observe(.value){
            (snap: FIRDataSnapshot) in
            let temp3: String!
            temp3 = snap.value as? String
            if temp3 != nil
            {
                self.posts[2] = temp3!
                self.tableView1.reloadData()
            }
 
        }
        dataRef.child("artistProfiles").child(self.userID).child("Price2").child("Price2_0").observe(.value){
            (snap: FIRDataSnapshot) in
            var temp4: String!
            temp4 = snap.value as? String
            if temp4 != nil
            {
                self.posts2[0] = temp4!
                self.tableView2.reloadData()
            }
            
        }
        dataRef.child("artistProfiles").child(self.userID).child("Price2").child("Price2_1").observe(.value){
            (snap: FIRDataSnapshot) in
            var temp5: String!
            temp5 = snap.value as? String
            if temp5 != nil
            {
                self.posts2[1] = temp5!
                self.tableView2.reloadData()
            }
            
        }
        
        
        dataRef.child("artistProfiles").child(self.userID).child("Price2").child("Price2_2").observe(.value){
            (snap: FIRDataSnapshot) in
            var temp6: String!
            temp6 = snap.value as? String
            if temp6 != nil
            {
                self.posts2[2] = temp6!
                self.tableView2.reloadData()
            }
            
            
        }

    }
    @IBAction func cancelAction(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "Artist") as! ArtistViewController
        
        myVC.token = self.userID
        
        //            print(myVC.token)
        self.present(myVC, animated: true)
    }
    

}
