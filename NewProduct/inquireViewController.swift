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

    var loggedUser = FIRAuth.auth()?.currentUser
    var dataRef = FIRDatabase.database().reference()
    
    var code: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUp()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
func SetUp()
    {
        dataRef.child("artistProfiles").child(loggedUser!.uid).child("Inquires").child(code).child("Client Name").observe(.value){
            (snap: FIRDataSnapshot) in
            self.lblName.text = "Client Name: \(snap.value as! String)"
        }
        
        dataRef.child("artistProfiles").child(loggedUser!.uid).child("Inquires").child(code).child("Client Email").observe(.value){
            (snap: FIRDataSnapshot) in
            self.lblEmail.text = "Client Email: \(snap.value as! String)"
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
        
    
            
            
        
    }
  

}
