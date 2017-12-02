//
//  AnimalViewController.swift
//  Trackr
//
//  Created by Greg  MacEachern on 2017-06-17.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

class AnimalViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLoc: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    
    var dataRef = FIRDatabase.database().reference()
    
    var token: String!
    var code: String!
    
    var images = [NSURL!]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        dataRef.child("Sightings").child("\(token!) - \(code!)").observe(.value){
            (snapshot: FIRDataSnapshot) in
            
            if snapshot.exists() == true{
                let snapshotValueName = snapshot.value as? NSDictionary
                let Name = snapshotValueName?["Name"] as? String
                self.lblName.text = Name
                
                let snapshotValueLoc = snapshot.value as? NSDictionary
                let Location = snapshotValueLoc?["Location"] as? String
                self.lblLoc.text = Location
                
                let snapshotValueAmount = snapshot.value as? NSDictionary
                let Amount = snapshotValueAmount?["Amount Animals"] as? String
                self.lblAmount.text = "Amount: \(Amount!)"
                
                
                let snapshotValuePic = snapshot.value as? NSDictionary
                var urlPic = NSURL()
                if let pic = snapshotValuePic?["Pic1"] as? String
                {
                    urlPic = NSURL(string:pic)!
                    self.images.append(urlPic)
                    
                }
                else{
                    urlPic = NSURL(string:"")!
                    
                }
                
                
                let snapshotValuePic2 = snapshot.value as? NSDictionary
                var urlPic2 = NSURL()
                if let pic2 = snapshotValuePic2?["Pic2"] as? String
                {
                    urlPic2 = NSURL(string:pic2)!
                    self.images.append(urlPic2)
                    
                }
                else{
                    urlPic2 = NSURL(string:"")!
                    
                }
                
                
                let snapshotValuePic3 = snapshot.value as? NSDictionary
                var urlPic3 = NSURL()
                if let pic3 = snapshotValuePic3?["Pic3"] as? String
                {
                    urlPic3 = NSURL(string:pic3)!
                    self.images.append(urlPic3)
                    
                }
                else{
                    urlPic3 = NSURL(string:"")!
                    
                }

                
                
            }
        }
        
        

        

        
        
        
               
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagesCollectionViewCell
        
        
        cell.myImage.sd_setImage(with: images[indexPath.row] as URL!, placeholderImage: UIImage(named: "IMGDefault")!)
        cell.myImage.layer.cornerRadius = 4
        cell.myImage.clipsToBounds = true
        cell.Loader.stopAnimating()
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
