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
import CoreLocation

struct postStruct2 {
    let animalName: String!
    let location: String!
    let picture: NSURL!
    let token: String!
    let time: String!
    let code: String!
    let Lati: String!
    let Longi: String!
}


class aaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var homeTab: UITableView!
    
    var posts = [postStruct2]()
    
    var dataRef: FIRDatabaseReference!
    var cellNumber : Int!
    var cellID: String!
    
    var myLat: CLLocationDegrees!
    var myLong: CLLocationDegrees!
    
    let manager = CLLocationManager()
    
    let loggedUser = FIRAuth.auth()?.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.startUpdatingLocation()
        
        self.posts.removeAll()
        
        dataRef = FIRDatabase.database().reference()
        
        //grabbing the title, price, date and picture to a structure and storing that in an array
                dataRef.child("Sightings").queryOrdered(byChild: "Time").observe(.childAdded, with: { (snapshot) in
//                    
                    if snapshot.exists() == true{
                    let snapshotValueName = snapshot.value as? NSDictionary
                    let Name = snapshotValueName?["Name"] as? String

                    let snapshotValuePrice = snapshot.value as? NSDictionary
                    let Location = snapshotValuePrice?["Location"] as? String
                
                    let snapshotValueDate = snapshot.value as? NSDictionary
                    let TimeAgo = snapshotValueDate?["date"] as? String

                    let snapshotValuePic = snapshot.value as? NSDictionary
                        var url = NSURL()
                    if let pic = snapshotValuePic?["Pic1"] as? String
                    {
                        url = NSURL(string:pic)!
                       
                    }
                    else{
                        url = NSURL(string:"")!
                    
                        }
                        
                    let snapshotValueToken = snapshot.value as? NSDictionary
                    let Token = snapshotValueToken?["token"] as? String
                        
                    let snapshotValueCode = snapshot.value as? NSDictionary
                    let Code = snapshotValueCode?["code"] as? String
                        
                    let snapshotValueLat = snapshot.value as? NSDictionary
                    let lat = snapshotValueLat?["Latitude"] as? String
                        
                    let snapshotValueLong = snapshot.value as? NSDictionary
                    let long = snapshotValueLong?["Longitude"] as? String
                        
                        
                        self.posts.insert(postStruct2(animalName: Name, location: Location, picture:url, token: Token, time: TimeAgo, code: Code, Lati: lat, Longi: long), at: 0)
                        
                        self.posts.sort { (object1, object2) -> Bool in
                            if object1.Lati == object2.Lati {
                                return object1.Longi < object2.Longi
                            } else {
                                return object1.Lati < object2.Lati
                            }
                        }
                        
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
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.myLat = location.coordinate.latitude
        self.myLong = location.coordinate.longitude
        if manager.location != nil
        {
            manager.stopUpdatingLocation()
        }
        
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
                                        //TABLE FUNCTIONS
    
    
    
             func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                //creates as many rows as there are posts
                return posts.count
            }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creates a cell in the table and sets information based on the tag (Check tag in main.storyboard)
        
//        let location1 = CLLocation(latitude: self.posts[indexPath.row].Lati, longitude: self.posts[indexPath.row].Lati)
//        let location2 = CLLocation(latitude: myLat, longitude: myLong)
//        
//        let distance = location2.distance(from: location1)
//        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2")
        
       
        
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = posts[indexPath.row].animalName
        
    
        let label2 = cell?.viewWithTag(2) as! UILabel
        if let temp1 = posts[indexPath.row].time{
        label2.text = temp1
        }
    
        
        let label3 = cell?.viewWithTag(3) as! UILabel
        label3.text = posts[indexPath.row].location
        
        
        let img4 = cell?.viewWithTag(4) as! UIImageView
        img4.sd_setImage(with: posts[indexPath.row].picture as URL!, placeholderImage: UIImage(named: "Animal")!)
        img4.layer.cornerRadius = 4
        img4.clipsToBounds = true

        return cell!
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellNumber = indexPath.row
        self.cellID = posts[cellNumber].token
        let cellCode = posts[cellNumber].code
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "animal") as! AnimalViewController

            myVC.token = self.cellID!
            myVC.code = cellCode!
        
//            print(myVC.token)
            self.present(myVC, animated: true)
    
        
        
        
//        }
    }
    
    @IBAction func addPost(_ sender: Any) {
    }
   
    @IBAction func refresh(_ sender: Any) {
        self.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    
}
