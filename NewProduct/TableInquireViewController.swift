//
//  TableInquireViewController.swift
//  NewProduct
//
//  Created by Greg  MacEachern on 2017-06-09.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

struct inquireStuct {
    let name: String!
    let theme: String!
    let code: String!
}

class TableInquireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeTab: UITableView!
    
    var dataRef = FIRDatabase.database().reference()
    var inqposts = [inquireStuct]()

    let loggedUser = FIRAuth.auth()?.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        
        SetUp()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //creates as many rows as there are posts
        return inqposts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creates a cell in the table and sets information based on the tag (Check tag in main.storyboard)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2")
        
        
        
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = inqposts[indexPath.row].name
        
        
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = inqposts[indexPath.row].theme
            
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellNumber = indexPath.row
        let cellID = inqposts[cellNumber].code
        
        print(cellID!)
    
        let myVC = storyboard?.instantiateViewController(withIdentifier: "Inquire") as! inquireViewController
        
        myVC.code = cellID!
        
        //            print(myVC.token)
        self.present(myVC, animated: true)
        
        
        
        
        
    }
    

    func SetUp()
    {
         self.inqposts.removeAll()
        
        dataRef.child("artistProfiles").child(loggedUser!.uid).child("Inquires").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            //
            if snapshot.exists() == true{
                let snapshotValueName = snapshot.value as? NSDictionary
                let Name = snapshotValueName?["Client Name"] as? String
                
                let snapshotValueTheme = snapshot.value as? NSDictionary
                let Theme = snapshotValueTheme?["Theme"] as? String
                
                let snapshotValueCode = snapshot.value as? NSDictionary
                let Code = snapshotValueCode?["code"] as? String
                
                
                
                
                self.inqposts.insert(inquireStuct(name: Name, theme: Theme, code: Code), at: 0)
                
                //print(self.inqposts)
                self.homeTab.reloadData()
            }
        })
        if inqposts.count == 0
        {
            let alertContoller = UIAlertController(title: "Oops!", message: "You have no inquires! Advertise yourself to get some :)", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertContoller.addAction(defaultAction)
            self.present(alertContoller, animated:true, completion: nil)
        }

    }

}
