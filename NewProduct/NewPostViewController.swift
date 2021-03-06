
//
//  NewPostViewController.swift
//  NewProduct
//
//  Created by Greg  MacEachern on 2017-04-29.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation


class NewPostViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate {
    

    @IBOutlet weak var tbName: UITextField!
    @IBOutlet weak var tbLoc: UITextField!
    @IBOutlet weak var tbAmount: UITextField!
    @IBOutlet weak var imgMain1: UIImageView!
    @IBOutlet weak var imgMain2: UIImageView!
    @IBOutlet weak var imgMain3: UIImageView!
    @IBOutlet weak var tvNearby: UITextView!
    @IBOutlet weak var searchLoc: UISearchBar!
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    
    var placeholderLabel: UILabel!
    
    


    @IBOutlet weak var DatePick: UIDatePicker!
    @IBOutlet weak var btnPost: UIButton!
    
     var imagePicker = UIImagePickerController()

    var dataRef = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference()
    var loggedUser = FIRAuth.auth()?.currentUser
    
    var tempDate:String!
    
    var Lati = "Not"
    var Longi = "NOT"
    
    var code: String!
    
    var img1 = false
    var img2 = false
    var img3 = false
    
    var manager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tvNearby.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        placeholderLabel.numberOfLines = 4
        placeholderLabel.text = "Is this nearby any landmarks?"
        placeholderLabel.font = UIFont(name: "Avenir Next", size: 14)
        placeholderLabel.sizeToFit()
        tvNearby.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tvNearby.font?.pointSize)!/2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tvNearby.text.isEmpty
        
        btnPost.layer.cornerRadius = btnPost.frame.height/2
    }
    
    //function to remove placeholder text
    func textViewDidBeginEditing(_ textView: UITextView) {
        
//        if (tbDescription.textColor == UIColor.lightGray || tbDescription.text == "Enter A Detailed Description")
//        {
//            tbDescription.text = ""
//            tbDescription.textColor = UIColor.black
//        }
    }
    
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        Lati = String(location.coordinate.latitude)
        Longi = "\(location.coordinate.longitude)"
        if manager.location != nil
        {
            manager.stopUpdatingLocation()
        }
        
    }
    

    func textViewDidChangeSelection(_ textView: UITextView) {
        placeholderLabel.isHidden = !tvNearby.text.isEmpty
    }

    
    //code for cancel
    @IBAction func didCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

            //dismisses the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tbLoc.resignFirstResponder()
        tbName.resignFirstResponder()
        tbAmount.resignFirstResponder()
        tvNearby.resignFirstResponder()
        return false
    }
    
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
            if img1 == true
            {
            imgMain1.image = selectedImage2

                
            }
            if img2 == true
            {
                imgMain2.image = selectedImage2
            
            }
            if img3 == true
            {
                imgMain3.image = selectedImage2
                
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //if persons presses cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func generateRandomStringWithLength(length:Int) -> String {
        
        let randomString:NSMutableString = NSMutableString(capacity: length)
        
        let letters:NSMutableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var i: Int = 0
        
        while i < length {
            
            let randomIndex:Int = Int(arc4random_uniform(UInt32(letters.length)))
            randomString.append("\(Character( UnicodeScalar( letters.character(at: randomIndex))!))")
            i += 1
        }
        
        return String(randomString)
    }
    
    
    
    func saveChange(){
        
        
       
        
        if imgMain1.image !=  #imageLiteral(resourceName: "IMGDefault")
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
                            self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").updateChildValues(["Pic1" : urlText], withCompletionBlock: { (error,ref) in
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
        
        if imgMain2.image != #imageLiteral(resourceName: "IMGDefault")
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

        if imgMain3.image != #imageLiteral(resourceName: "IMGDefault")
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
    
    
   
    @IBAction func didTapPhoto(_ sender: UITapGestureRecognizer) {
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
        
        self.img1 = true
        self.img2 = false
        self.img3 = false
        
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func didTap2(_ sender: UITapGestureRecognizer) {
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
        
        self.img2 = true
        self.img1 = false
        self.img3 = false
        
        self.present(myActionSheet, animated: true, completion: nil)

    }
    
    @IBAction func didTap3(_ sender: UITapGestureRecognizer) {
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
        
        self.img3 = true
        self.img2 = false
        self.img1 = false
        
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    
    
    

    //code for posting
    @IBAction func didPost(_ sender: Any) {
        
        //If there is text in both boxes
        if (tbName.text != "" && tbLoc.text != "" && imgMain1.image != #imageLiteral(resourceName: "Default") && tbAmount.text != "")
        {
            
            
            let alertController = UIAlertController(title: "Are you at the site now?", message: "This gives us better location", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "No", style: .default, handler: {
            alert -> Void in
                
                self.Loader.startAnimating()
               self.uploadData()
                self.saveChange()
                
                
         
                
            })
        
        
            let OkayAction = UIAlertAction(title: "Yes", style: .default, handler: {
                alert -> Void in
                
                self.manager.startUpdatingLocation()
                self.Loader.startAnimating()
                self.uploadData()
                self.saveChange()
                
                
            })
            
            
            
            alertController.addAction(defaultAction)
            alertController.addAction(OkayAction)
            
            self.present(alertController, animated:true, completion: nil)
           
            
            //if the text boxes are blank, show the error
        }
        else
        {
            let alertContoller = UIAlertController(title: "Oops!", message: "Please Fill In Fields", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertContoller.addAction(defaultAction)
            
            self.present(alertContoller, animated:true, completion: nil)
        }
    }
    
    func uploadData()
    {
        self.code = self.generateRandomStringWithLength(length: 10)
        
        
        
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
        
        
        let animal = self.tbName.text
        let location = self.tbLoc.text
        
        let token = self.loggedUser!.uid
        
        
        let post: [String : AnyObject] = ["Name": animal as AnyObject,
                                          "Location": location as AnyObject,
                                          "Latitude": self.Lati as AnyObject,
                                          "Longitude": self.Longi as AnyObject,
                                          "date": dob as AnyObject,
                                          "Time": self.tempDate as AnyObject,
                                          "Amount Animals": self.tbAmount.text as AnyObject,
                                          "Nearby": self.tvNearby.text as AnyObject,
                                          "code": self.code as AnyObject,
                                          "token": token as AnyObject]
        
        
        self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").setValue(post)
        
        
        self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.code!)").setValue(post)
    }
    
}

