//
//  ArtistViewController.swift
//  NewProduct
//
//  Created by Greg  MacEachern on 2017-05-11.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

//cant connect tb to normal class. must be tableviewcell class



class ArtistViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tbDescription: UITextView!
    @IBOutlet weak var picturePicker: UIPickerView!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnPin: UIButton!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var ugh: UIImageView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    

    var dataRef = FIRDatabase.database().reference()
    var storageRef = FIRStorage.storage().reference()
    var loggedUser = FIRAuth.auth()?.currentUser
    
    var tracker: Int! = 0
    
    var status: String!
    
    var table1 = false
    var count = 0
    var posts: [String?] = []
    var posts2:[String?] = []
    
    var imagePicker = UIImagePickerController()
    var url: NSURL!
    var tempImg: UIImageView!
    
    var temp1: String!
    var temp2: String!
    var temp3: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPin.layer.cornerRadius = 5
        btnPin.clipsToBounds = true
        
        btnBook.layer.cornerRadius = 5
        btnBook.clipsToBounds = true
        
        btnMessage.layer.cornerRadius = 5
        btnMessage.clipsToBounds = true
        
        
        dataRef.child("users").child(loggedUser!.uid).child("pic").observe(.value){
            (snap: FIRDataSnapshot) in
            
            if let pic = snap.value as? String{
            self.url = NSURL(string:pic)
            //print(self.url)
            }
        }
        
        
        dataRef.child("users").child(loggedUser!.uid).child("name").observe(.value){
            (snap: FIRDataSnapshot) in
            self.lblName.text = snap.value as? String
        }
        
        dataRef.child("users").child(loggedUser!.uid).child("about").observe(.value){
            (snap: FIRDataSnapshot) in
            self.tbDescription.text = snap.value as? String
            
        }
        dataRef.child("users").child(loggedUser!.uid).child("Price1").child("0").observe(.value){
            (snap: FIRDataSnapshot) in
            
           self.temp1 = snap.value as? String
        }
        dataRef.child("users").child(loggedUser!.uid).child("Price1").child("1").observe(.value){
            (snap: FIRDataSnapshot) in
            
            self.temp2 = snap.value as? String
        }
        dataRef.child("users").child(loggedUser!.uid).child("Price1").child("2").observe(.value){
            (snap: FIRDataSnapshot) in
            
            self.temp3 = snap.value as? String
        }
        
        if tbDescription.text == ""{
            
            tbDescription.text = "Enter A Detailed Description"
            tbDescription.textColor = UIColor.lightGray
            
        }
        else{
            
        }
        posts.insert(temp1, at: 0)
        posts.insert(temp2, at: 1)
        posts.insert(temp3, at: 2)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        
                if (tbDescription.textColor == UIColor.lightGray || tbDescription.text == "Enter A Detailed Description")
                {
                    tbDescription.text = ""
                    tbDescription.textColor = UIColor.black
                }
    }
    
 
    func textViewDidChange(_ textView: UITextView) {
        self.dataRef.child("users").child(self.loggedUser!.uid).child("about").setValue(tbDescription.text)
        
//        if count == 0
//        {
//            self.dataRef.child("users").child(self.loggedUser!.uid).child("Price1").child("0").setValue(TEMPTb.text!)
//            
//        }
//        else if count == 1
//        {
//            self.dataRef.child("users").child(self.loggedUser!.uid).child("Price1").child("1").setValue(TEMPTb.text!)
//        }
//        else if count == 2
//        {
//           self.dataRef.child("users").child(self.loggedUser!.uid).child("Price1").child("2").setValue(TEMPTb.text!)
//        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 120
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tracker = row
        print(tracker)
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 120))
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 120))
        let Loader = UIActivityIndicatorView(frame: CGRect(x: 168, y: 60, width: 40, height: 40))
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 120))
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.backgroundColor = UIColor.clear
        var rowString = String()
        rowString = "Upload a Picture"
        
        Loader.color = UIColor.orange
        Loader.startAnimating()
    


            //initializing the rows data
        switch row {
        case 0:
            
            dataRef.child("users").child(loggedUser!.uid).observeSingleEvent(of: .value, with: {  (snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject]
                {
                  
                    
                    if let profileImageURL = dict["ProfilePic1"] as? String
                    {
                        
                        let url = URL(string: profileImageURL)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async {
                                print(data!)
                                if data == nil
                                {
                                    rowString = "Upload an Image 1"
                               
                                }
                                else
                                {
                                    myImageView.image = UIImage(data: data!)
                                    Loader.stopAnimating()
                                    rowString = ""
                                }
                                
                                
                            }
                        }).resume()
                    }
                }
            })
            
        case 1:
    
            dataRef.child("users").child(loggedUser!.uid).observeSingleEvent(of: .value, with: {  (snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    
                    //self.lblName.text = dict["username"] as? String
                    
                    if let profileImageURL = dict["ProfilePic2"] as? String
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
                                    rowString = "Upload an image1"
                                   // myImageView.image = UIImage(named: "City")
                                }
                                else
                                {
                                    myImageView.image = UIImage(data: data!)
                                
                                    rowString = ""
                                    Loader.stopAnimating()
                                }
                                
                                
                            }
                        }).resume()
                    }
                }
            })
        case 2:
            
            dataRef.child("users").child(loggedUser!.uid).observeSingleEvent(of: .value, with: {  (snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    
                   
                    
                    if let profileImageURL = dict["ProfilePic3"] as? String
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
                                    rowString = "Upload an image1"
                                    myImageView.image = UIImage(named: "City")
                                }
                                else
                                {
                                    myImageView.image = UIImage(data: data!)
                                    
                                    Loader.stopAnimating()
                                    rowString = ""
                                }
                                
                                
                            }
                        }).resume()
                    }
                }
            })
        
            
        case 3: break
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        
        myLabel.text = rowString
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        myView.addSubview(Loader)
        return myView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
      
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
            ugh.image = selectedImage2 as UIImage
            
        }
        
       
            if (tracker == 0)
            {
                status = "ProfilePic1"
                
                UploadImage()
            }
                
            else if (tracker == 1)
            {
                status = "ProfilePic2"
                
                UploadImage()
            }
            else if tracker == 2
            {
                status = "ProfilePic3"
                
                UploadImage()
            }
            
        
        dismiss(animated: true, completion: nil)
    
    }
    

    @IBAction func longPressPicker(_ sender: UILongPressGestureRecognizer) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        let myActionSheet = UIAlertController(title: "Memory Picture", message: "Select", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        
        
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
    
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func UploadImage(){
        
        let imageName =  NSUUID().uuidString
        //let imageNameCover = NSUUID().uuidString
        
        let storedImage = storageRef.child("imgProfile").child(loggedUser!.uid).child(imageName)

        
        
        if let uploadData = UIImagePNGRepresentation(self.ugh.image!)
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
                            self.dataRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["\(self.status!)" : urlText], withCompletionBlock: { (error,ref) in
                                if error != nil
                                {
                                    print(error!)
                                    return
                                }
                                
                            })
                        }
                    })
                })
            }
        
        
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        count = indexPath.row
        enableCustomMenu()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
//        if table1 == false
//        {
//        
//        TEMPTb.text = "\(posts[indexPath.row]!)"
//        }
//        else{
////            let label1 = cell?.viewWithTag(1) as! UILabel
////            label1.text = "\(posts[indexPath.row]!)"
//        }
        
        return cell!
    }
    
    func enableCustomMenu() {
        let lookup = UIMenuItem(title: "Edit", action: #selector(EditData))
        UIMenuController.shared.menuItems = [lookup]
    }
    func EditData() {
//        TEMPTb.isEditable = true
//        TEMPTb.text = "Enter a description"
        
    }
    
}
