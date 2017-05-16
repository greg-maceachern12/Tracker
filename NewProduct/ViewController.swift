//
//  ViewController.swift
//  NewProduct
//
//  Created by Greg  MacEachern on 2017-03-10.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Photos


class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var Logout: UIButton!
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    //@IBOutlet weak var imgCover: UIImageView!
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet var longpress: UILongPressGestureRecognizer!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet var longLabel: UILongPressGestureRecognizer!
    @IBOutlet weak var tbAbout: UITextField!
    @IBOutlet weak var tabBar: UITabBarItem!
    
    //declarations for about section
    @IBOutlet weak var lblLoc: UILabel!
    @IBOutlet weak var lblBirth: UILabel!
    @IBOutlet weak var lblGend: UILabel!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
   
    
    
    let NameRef = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference()
    
    var upload = false
    
    var loc = ""
    var birth = ""
    var gend = ""
    var ID = ""
    
    
    var imagePicker = UIImagePickerController()
    //var coverPicker = UIImagePickerController()
    
    var state = false
    
    let user = FIRAuth.auth()?.currentUser
    
   let NameLoad = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("name")
    let aboutLoad = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("about")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  tabbaritem.image = [[UIImage imageNamed:@“image”] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        lblName.isUserInteractionEnabled = true
        
        
        btnSave.layer.mask?.cornerRadius = 5
        
        
        
        
            //if user is logged out
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            LogoutSeq()
        }
        
        //set profile qualities
        setupProfile()
        
        
        
        
        
        //allow the profile pic to be clicked
        self.imgMain.isUserInteractionEnabled = true
        //self.imgCover.isUserInteractionEnabled = true
       
    }
    


    //when save button is clicked
    @IBAction func SaveChanges(_ sender: Any) {
       // saveChange()
        
        
        if upload == true{
            saveChange()
            self.NameRef.child("users").child(self.user!.uid).child("name").setValue(lblName.text)
           // self.NameRef.child("users").child(self.user!.uid).child("about").setValue(tbAbout.text)
//            
//            self.NameRef.child("users").child(self.user!.uid).child("location").setValue(lblLoc.text)
//            self.NameRef.child("users").child(self.user!.uid).child("birthday").setValue(lblBirth.text)
//            self.NameRef.child("users").child(self.user!.uid).child("gender").setValue(lblGend.text)
//            self.NameRef.child("users").child(self.user!.uid).child("ID").setValue(lblID.text)
            upload = false
        }
        else{
            self.NameRef.child("users").child(self.user!.uid).child("name").setValue(lblName.text)
            //self.NameRef.child("users").child(self.user!.uid).child("about").setValue(tbAbout.text)
            btnSave.isHidden=true
            
            self.NameRef.child("users").child(self.user!.uid).child("location").setValue(loc)
            self.NameRef.child("users").child(self.user!.uid).child("birthday").setValue(birth)
            self.NameRef.child("users").child(self.user!.uid).child("gender").setValue(gend)
            self.NameRef.child("users").child(self.user!.uid).child("ID").setValue(ID)
            print(ID)

        }
    }
    

    //when logout is clicked
    @IBAction func LogoutAct(_ sender: Any) {
        
       setupProfile()
        try! FIRAuth.auth()?.signOut()
        
        LogoutSeq()
    }
    
    //loading image from database into view
    func setupProfile(){
    
        imgMain.layer.cornerRadius = 4
        imgMain.clipsToBounds = true
        
        btnSave.layer.cornerRadius = 5
        btnSave.clipsToBounds = true
        
        
      self.Loader.startAnimating()
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            NameRef.child("users").child(uid!).observeSingleEvent(of: .value, with: {  (snapshot) in
                
                
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    
                //self.lblName.text = dict["username"] as? String
                    
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
                            self.imgMain?.image = UIImage(data: data!)
                            self.Loader.stopAnimating()
                            }
                            
                            
                        }
                        
                    }).resume()
                    
                    
                    //cover
//                    if let coverImageURL = dict["cover"] as? String
//                    {
//                        let url2 = URL(string: coverImageURL)
//                        URLSession.shared.dataTask(with: url2!, completionHandler: { (data2, response, error) in
//                            if error != nil{
//                                print(error!)
//                                return
//                            }
//                            DispatchQueue.main.async {
//                                self.imgCover?.image = UIImage(data: data2!)
//                                self.Loader.stopAnimating()
//                            }
//                            
//                        }).resume()
                    }
                }
        })
        
        NameLoad.observe(.value){
            (snap: FIRDataSnapshot) in
            self.lblName.text = snap.value as? String
            
        }

        NameRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("location").observe(.value){
            (snap: FIRDataSnapshot) in
            if let temp1 = snap.value as? String{
                self.loc = temp1
                self.lblLoc.text = "Location: \(temp1)"
            }
            
        }
        NameRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("birthday").observe(.value){
            (snap: FIRDataSnapshot) in
            if let temp2 = snap.value as? String{
                self.birth = temp2
                self.lblBirth.text = "Birthday: \(temp2)"
            }
        }
        NameRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("gender").observe(.value){
            (snap: FIRDataSnapshot) in
            if let temp3 = snap.value as? String{
                self.gend = temp3
                self.lblGend.text = "Gender: \(temp3)"
            }
            
        }
        NameRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("ID").observe(.value){
            (snap: FIRDataSnapshot) in
            if let temp4 = snap.value as? String{
                self.ID = temp4
                self.lblID.text = "ID Verification: \(temp4)"
            }
        }
    
}

    //image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        btnSave.isHidden = false
        
//        
//        if state == false
//        {
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
            imgMain.image = selectedImage2
            upload = true
            
            
        }
        //saveChange()
        dismiss(animated: true, completion: nil)
        //}
        
//        if state == true
//        {
//            var selectedCover:UIImage?
//            
//            
//            if let editedCover = info["UIImagePickerControllerEditedImage"] as? UIImage
//            {
//                selectedCover = editedCover
//            }
//            else if let originalCover = info["UIImagePickerControllerOriginalImage"] as? UIImage
//            {
//                selectedCover = originalCover
//            }
//            
//            if let selectedCover2 = selectedCover
//            {
//                imgCover.image = selectedCover2
//                upload = true
//                
//            }
//            dismiss(animated: true, completion: nil)
//        }
        
    }
    
    
    
    //if persons presses cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
   
    //saving changes
    func saveChange(){
        
        Loader.startAnimating()
        let imageName =  NSUUID().uuidString
        //let imageNameCover = NSUUID().uuidString
        
        let storedImage = storageRef.child("imgMain").child(imageName)
        //let storedCover = storageRef.child("imgCover").child(imageNameCover)
      
        
        if let uploadData = UIImagePNGRepresentation(self.imgMain.image!)
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
                        self.NameRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["pic" : urlText], withCompletionBlock: { (error,ref) in
                            if error != nil
                            {
                                print(error!)
                                return
                            }
                            self.Loader.stopAnimating()
                            self.btnSave.isHidden = true
                        })
                        }
                    })
                })
            }
        
        
        
//        if let uploadDataCover = UIImagePNGRepresentation(self.imgCover.image!)
//        {
//            storedCover.put(uploadDataCover, metadata: nil, completion: { ( metadata, error) in
//                if error != nil
//                {
//                    print(error!)
//                    return
//                }
//                storedCover.downloadURL(completion: { (url,error) in
//                    if error != nil
//                    {
//                        print(error!)
//                        return
//                    }
//                    if let urlText2 = url?.absoluteString{
//                        self.NameRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["cover" : urlText2], withCompletionBlock: { (error,ref) in
//                            if error != nil
//                            {
//                                print(error!)
//                                return
//                            }
//                            self.Loader.stopAnimating()
//                        })
//                    }
//                })
//            })
//        }
    }

//what happens when logout is clicked
    func LogoutSeq(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "login")
        self.present(loginVC, animated: true, completion: nil)
        
        }
    
    //Tap Gesture for profile picture
    @IBAction func Tapped(_ sender: UITapGestureRecognizer) {
        
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let viewPicture = UIAlertAction(title: "View Picture", style: UIAlertActionStyle.default) { (action) in
            
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            
            
            newImageView.frame = self.view.frame
            
            newImageView.backgroundColor = UIColor.black
            newImageView.contentMode = .scaleAspectFit
            
            newImageView.isUserInteractionEnabled = true
            
            
            
            let tap = UITapGestureRecognizer(target:self,action:#selector(self.dismissFullScreenImage))
            
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            
        }
        
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.state = false
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.state = false
                self.present(self.imagePicker, animated: true, completion: nil)
                
                
//                self.imagePicker.allowsEditing = false
//                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//                self.imagePicker.cameraCaptureMode = .photo
//                self.imagePicker.modalPresentationStyle = .fullScreen
//                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        
        myActionSheet.addAction(viewPicture)
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    
    func dismissFullScreenImage(_sender:UITapGestureRecognizer){
        _sender.view?.removeFromSuperview()
    }
    
    func dismissFullScreenCover(_sender:UITapGestureRecognizer){
        _sender.view?.removeFromSuperview()
    }
    
    

        //long press for cover photo
    @IBAction func LongPress(_ sender: UILongPressGestureRecognizer) {
//        
//        let picker2 = UIImagePickerController()
//        picker2.delegate = self
//        picker2.allowsEditing = true
//        picker2.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        
//        let myActionSheet = UIAlertController(title: "Cover Photo", message: "Select long and short photos for best results", preferredStyle: UIAlertControllerStyle.actionSheet)
//        
//        let viewPicture = UIAlertAction(title: "View Picture", style: UIAlertActionStyle.default) { (action) in
//            
//            let imageView = sender.view as! UIImageView
//            let newImageView = UIImageView(image: imageView.image)
//            
//            
//            newImageView.frame = self.view.frame
//            
//            newImageView.backgroundColor = UIColor.black
//            newImageView.contentMode = .scaleAspectFit
//            
//            newImageView.isUserInteractionEnabled = true
//            
//            let tap2 = UILongPressGestureRecognizer(target:self,action:#selector(self.dismissFullScreenCover))
//            
//            newImageView.addGestureRecognizer(tap2)
//            self.view.addSubview(newImageView)
//            
       }
        
//        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertActionStyle.default) { (action) in
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
//            {
//                self.imagePicker.delegate = self
//                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
//                self.imagePicker.allowsEditing = true
//                self.state = true
//               self.present(self.imagePicker, animated: true, completion: nil)
//                
//            }
//        }
//        
//        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
//            {
//                self.imagePicker.delegate = self
//                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//                self.imagePicker.allowsEditing = true
//                self.state = true
//                self.present(self.imagePicker, animated: true, completion: nil)
//            }
//        }
//        
//        
//        myActionSheet.addAction(viewPicture)
//        myActionSheet.addAction(photoGallery)
//        myActionSheet.addAction(camera)
//        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//        
//        self.present(myActionSheet, animated: true, completion: nil)
//
//    }

    @IBAction func longPressLabel(_ sender: UILongPressGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Edit Name", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            if firstTextField.text == ""
            {
                
            }
            else
            {
            //print("firstName \(firstTextField.text)")
            
            self.lblName.text = firstTextField.text
            
            self.btnSave.isHidden = false
            }
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            self.Loader.stopAnimating()
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter First and Last Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tbAbout.resignFirstResponder()
        return true
    }
   
    @IBAction func tbEditBeing(_ sender: Any) {
        btnSave.isHidden = false
    }
    
    @IBAction func editClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Edit Information", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            if firstTextField.text == ""
            {
                firstTextField.placeholder = "Please enter a location (City/State/Country)"
            }
            else
            {
                //print("firstName \(firstTextField.text)")
                if let temp1 = firstTextField.text{
                self.lblLoc.text = "Location: \(temp1)"
                self.loc = temp1
                self.btnSave.isHidden = false
                    
                }
            }
            
            let secondTextField = alertController.textFields![1] as UITextField
            
            if secondTextField.text == ""
            {
                secondTextField.placeholder = "Please enter a birthday(dd/mm/yy)"
            }
            else
            {
                //print("firstName \(firstTextField.text)")
                if let temp2 = secondTextField.text{
                self.lblBirth.text = "Birthday: \(temp2)"
                self.birth = temp2
                self.btnSave.isHidden = false
                }
            }
            
            let thirdTextField = alertController.textFields![2] as UITextField
            
            if thirdTextField.text == ""
            {
                thirdTextField.placeholder = "Please enter a gender"
            }
            else
            {
                if let temp3 = thirdTextField.text{
                
                self.lblGend.text = "Gender: \(temp3)"
                self.gend = temp3
                self.btnSave.isHidden = false
                }
            }
            
            let fourthTextField = alertController.textFields![3] as UITextField
            
            if fourthTextField.text == ""
            {
                fourthTextField.placeholder = "Please enter a valid ID"
            }
            else
            {
                //print("firstName \(firstTextField.text)")
                if let temp4 = fourthTextField.text{
                self.lblID.text = "ID Verification: \(temp4)"
                self.ID = temp4
                self.btnSave.isHidden = false
                }
            }
           
            
            
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            self.Loader.stopAnimating()
            
        })
        
        alertController.addTextField { (firstTextField : UITextField!) -> Void in
            
            if (self.lblLoc.text == "Location: Not Declared" || self.lblLoc.text == "Location:")
            {
            firstTextField.placeholder = "Please enter a location (City/State/Country)"
            }
            else
            {
                firstTextField.text = self.loc
            }
           
        }
        alertController.addTextField { (secondTextField : UITextField!) -> Void in
            if (self.lblBirth.text == "Birthday: Not Declared" || self.lblBirth.text == "Birthday:")
            {
                secondTextField.placeholder = "Please enter a birthday (dd/mm/yyyy)"
            }
            else
            {
                secondTextField.text = self.birth
            }
            
        }
        alertController.addTextField { (thirdTextField : UITextField!) -> Void in
            if (self.lblGend.text == "Gender: Not Declared" || self.lblGend.text == "Gender:")
            {
                thirdTextField.placeholder = "Please enter a gender"
            }
            else
            {
                thirdTextField.text = self.gend
            }
            
        }
        alertController.addTextField { (fourthTextField : UITextField!) -> Void in
            if (self.lblID.text == "ID Verification: Not Declared" || self.lblID.text == "ID Verification:")
            {
                fourthTextField.placeholder = "Please enter a valid ID"
            }
            else
            {
                fourthTextField.text = self.ID
            }
            
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
   
    
    
    
}
