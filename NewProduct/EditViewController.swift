//
//  EditViewController.swift
//  Trackr
//
//  Created by Greg  MacEachern on 2017-06-17.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import CoreLocation


//struct editStruct {
//    let name: String!
//    let location: String!
//    let picture: NSURL!
//    let token: String!
//    let time: String!
//    let code: String!
//}
class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var imgMain1: UIImageView!
    @IBOutlet weak var imgMain2: UIImageView!
    @IBOutlet weak var imgMain3: UIImageView!
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet weak var lblLoc: UITextField!
    @IBOutlet weak var lblAmount: UITextField!
    @IBOutlet weak var tvNearby: UITextView!
    @IBOutlet weak var DatePick: UIDatePicker!
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    
    var dataRef = FIRDatabase.database().reference()
    let loggedUser = FIRAuth.auth()?.currentUser
    var storageRef = FIRStorage.storage().reference()
    
    var posts = [postStruct2]()
    var code: String!
    var images = [NSURL!]()
    
    var imagePicker = UIImagePickerController()
    
    var animalName: String!
    var animalLocation: String!
    var animalAmount: String!
    var animalNearby: String!
    
    var tempDate: String!
    var fullLoc = "Not Provided"
    
    var manager = CLLocationManager()
    
    
    var img1temp = false
    var img2temp = false
    var img3temp = false
    
    var upload1 = false
    var upload2 = false
    var upload3 = false
    
    override func viewDidAppear(_ animated: Bool) {
        print(code)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(code!)").observe(.value) { (snapshot: FIRDataSnapshot) in
            if snapshot.exists() == true
            {
                let snapshotValueName = snapshot.value as? NSDictionary
                self.animalName = snapshotValueName?["Name"] as? String!
                self.lblName.text = self.animalName
                
                let snapshotValueLoc = snapshot.value as? NSDictionary
                self.animalLocation = snapshotValueLoc?["Location"] as? String!
                self.lblLoc.text = self.animalLocation
                
                let snapshotValueAmount = snapshot.value as? NSDictionary
                self.animalAmount = snapshotValueAmount?["Amount Animals"] as? String!
                self.lblAmount.text = self.animalAmount
                
                let snapshotValueNearby = snapshot.value as? NSDictionary
                self.animalNearby = snapshotValueNearby?["Nearby"] as? String!
                
                self.tvNearby.text = self.animalNearby
                
                let snapshotValuePic = snapshot.value as? NSDictionary
                var urlPic = NSURL()
                if let pic = snapshotValuePic?["Pic1"] as? String
                {
                    urlPic = NSURL(string:pic)!
                     self.imgMain1.sd_setImage(with: urlPic as URL!, placeholderImage: UIImage(named: "IMGDefault")!)
//                    self.images.append(urlPic)
                    
                }
                else{
                    urlPic = NSURL(string:"")!
                    
                }
                
                
                let snapshotValuePic2 = snapshot.value as? NSDictionary
                var urlPic2 = NSURL()
                if let pic2 = snapshotValuePic2?["Pic2"] as? String
                {
                    urlPic2 = NSURL(string:pic2)!
                    self.imgMain2.sd_setImage(with: urlPic2 as URL!, placeholderImage: UIImage(named: "IMGDefault")!)
                    
//                    self.images.append(urlPic2)
                    
                }
                else{
                    urlPic2 = NSURL(string:"")!
                    
                }
                
                
                let snapshotValuePic3 = snapshot.value as? NSDictionary
                var urlPic3 = NSURL()
                if let pic3 = snapshotValuePic3?["Pic3"] as? String
                {
                    urlPic3 = NSURL(string:pic3)!
                    
                    self.imgMain3.sd_setImage(with: urlPic3 as URL!, placeholderImage: UIImage(named: "IMGDefault")!)
//                    self.images.append(urlPic3)
                    
                }
                else{
                    urlPic3 = NSURL(string:"")!
                    
                }
                
            }
        }

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func saveChange(){
        
        
        
        if upload1 == true
        {
            let imageName =  NSUUID().uuidString
            let storedImage = storageRef.child("Sighting").child(imageName)
            if let uploadData = UIImagePNGRepresentation(self.imgMain1.image!)
            {
                storedImage.put(uploadData, metadata: nil, completion: { ( metadata, error) in
                    if error != nil
                    {
                        print(error!)
                        return
                    }
                    storedImage.downloadURL(completion: { (url,error) in
                        if error != nil
                        {
                            print(error!)
                            return
                        }
                        if let urlText = url?.absoluteString{
                            
                            
                            self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").updateChildValues(["Pic1" : urlText], withCompletionBlock: { (error,ref) in
                                if error != nil
                                {
                                    
                                    print(error!)
                                    return
                                }
                                else{
                                    self.Loader.stopAnimating()
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                                
                            })
                            self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").updateChildValues(["Pic1" : urlText], withCompletionBlock: { (error,ref) in
                                if error != nil
                                {
                                    
                                    print(error!)
                                    return
                                }
                                else{
                                    self.Loader.stopAnimating()
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                                
                            })
                            
                            
                        }
                        
                    })
                })
            }
        }
        
        if upload2 == true
        {
            let imageName =  NSUUID().uuidString
            let storedImage = storageRef.child("Sighting").child(imageName)
            if let uploadData = UIImagePNGRepresentation(self.imgMain2.image!)
            {
                storedImage.put(uploadData, metadata: nil, completion: { ( metadata, error) in
                    if error != nil
                    {
                        print(error!)
                        return
                    }
                    storedImage.downloadURL(completion: { (url,error) in
                        if error != nil
                        {
                            print(error!)
                            return
                        }
                        if let urlText = url?.absoluteString{
                            
                            
                            self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").updateChildValues(["Pic2" : urlText], withCompletionBlock: { (error,ref) in
                                if error != nil
                                {
                                    
                                    print(error!)
                                    return
                                }
                                else{
                                    self.Loader.stopAnimating()
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                                
                            })
                            self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").updateChildValues(["Pic2" : urlText], withCompletionBlock: { (error,ref) in
                                if error != nil
                                {
                                    
                                    print(error!)
                                    return
                                }
                                else{
                                    self.Loader.stopAnimating()
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                                
                            })
                            
                        }
                        
                    })
                })
            }
        }
        
        if upload3 == true
        {
            let imageName =  NSUUID().uuidString
            let storedImage = storageRef.child("Sighting").child(imageName)
            if let uploadData = UIImagePNGRepresentation(self.imgMain3.image!)
            {
                storedImage.put(uploadData, metadata: nil, completion: { ( metadata, error) in
                    if error != nil
                    {
                        print(error!)
                        return
                    }
                    storedImage.downloadURL(completion: { (url,error) in
                        if error != nil
                        {
                            print(error!)
                            return
                        }
                        if let urlText = url?.absoluteString{
                            
                            
                            self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").updateChildValues(["Pic3" : urlText], withCompletionBlock: { (error,ref) in
                                if error != nil
                                {
                                    
                                    print(error!)
                                    return
                                }
                                else{
                                    self.Loader.stopAnimating()
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                                
                            })
                            self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").updateChildValues(["Pic3" : urlText], withCompletionBlock: { (error,ref) in
                                if error != nil
                                {
                                    
                                    print(error!)
                                    return
                                }
                                else{
                                    self.Loader.stopAnimating()
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                                
                            })
                            
                        }
                        
                    })
                })
            }
        }
        
        
        
        //also found this online
    }

    
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
            {
                
                //Not sure why i have to set the imagepickers delegate to self. Thats the only way it worked tho
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                
                //This was a pain in the ass to get to work. In the in GoogleService-Info.plist you HAVE to add the camera permission (for future projects obvi)
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        img1temp = true
        img2temp = false
        img3temp = false
       
        
        self.present(myActionSheet, animated: true, completion: nil)
    
    }
    
    
    @IBAction func tapped2(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
            {
                
                //Not sure why i have to set the imagepickers delegate to self. Thats the only way it worked tho
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                
                //This was a pain in the ass to get to work. In the in GoogleService-Info.plist you HAVE to add the camera permission (for future projects obvi)
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        img2temp = true
        img3temp = false
        img1temp = false
       
        
        self.present(myActionSheet, animated: true, completion: nil)

    }
    
    @IBAction func tapped3(_ sender: UITapGestureRecognizer) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
            {
                
                //Not sure why i have to set the imagepickers delegate to self. Thats the only way it worked tho
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                
                //This was a pain in the ass to get to work. In the in GoogleService-Info.plist you HAVE to add the camera permission (for future projects obvi)
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        img3temp = true
        img2temp = false
        img1temp = false
      
        
        self.present(myActionSheet, animated: true, completion: nil)

    }
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        

        //Seeting the image equal to the profile picture. If the image was edited (cropped) it will upload that instead
        var selectedImage:UIImage?
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImage = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImage = originalImage
        }
        
        if let selectedImage2 = selectedImage
        {
            if img1temp == true
            {
                imgMain1.image = selectedImage2
                upload1 = true
                
            }
            if img2temp == true
            {
                imgMain2.image = selectedImage2
                upload2 = true
                
                
            }
            if img3temp == true
            {
                imgMain3.image = selectedImage2
                upload3 = true
              
                
            }
            
        }
        dismiss(animated: true, completion: nil)
    }

    
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        fullLoc = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        if manager.location != nil
        {
            manager.stopUpdatingLocation()
        }
        
    }
  
    @IBAction func Confirm(_ sender: Any) {
    
        let alertController = UIAlertController(title: "Are you at the site now?", message: "This gives us better location", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "No", style: .default, handler: {
            alert -> Void in
            
            
            
            self.Loader.startAnimating()
            self.UploadData()
            self.saveChange()
            
            
            self.dismiss(animated: true, completion: nil)
        })
        
        let OkayAction = UIAlertAction(title: "Yes", style: .default, handler: {
            alert -> Void in
            
            self.manager.startUpdatingLocation()
            self.Loader.startAnimating()
            self.UploadData()
            self.saveChange()
            
            self.dismiss(animated: true, completion: nil)
            
        })
        
        

        
        alertController.addAction(defaultAction)
        alertController.addAction(OkayAction)
        
        self.present(alertController, animated:true, completion: nil)
        
        //if the text boxes are blank, show the error
    }
    
    func UploadData()
    {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: self.DatePick.date)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "HH:mm:ss"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        
        
        let dateFormatter = DateFormatter()
        // Now we specify the display format, e.g. "27-08-2015
        dateFormatter.dateFormat = "dd-MM-YYYY"
        // Now we get the date from the UIDatePicker and convert it to a string
        let strDate = dateFormatter.string(from: self.DatePick.date)
        // Finally we set the text of the label to our new string with the date
        let dob = strDate
        
        self.tempDate = myStringafd
        
        
        let animal = self.lblName.text
        let location = self.lblLoc.text
        
        
        self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Name").setValue(animal!)
        
        
        self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Location").setValue(location!)
        
        self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Exact Location").setValue(fullLoc)
        
        self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("date").setValue(dob)
        
        self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Time").setValue(tempDate)
        
        self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Amount Animals").setValue(self.lblAmount.text!)
        
        self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Nearby").setValue(self.tvNearby.text!)
        
        
        
        
        self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Name").setValue(animal!)
        
        
        self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Location").setValue(location!)
        
        self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Exact Location").setValue(fullLoc)
        
        self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("date").setValue(dob)
        
        self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Time").setValue(tempDate)
        
        self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Amount Animals").setValue(self.lblAmount.text!)
        
        self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").child("Nearby").setValue(self.tvNearby.text!)
        
    }


}
