//
//  ViewController.swift
//  NewProduct
//
//  Created by Greg  MacEachern on 2017-03-10.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

                                            //CODE FOR MAIN PROFILE

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation
import Photos

struct profileStruct{
    let animalName: String!
    let location: String!
    let time: String!
    let code: String!
}


class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    //@IBOutlet weak var Logout: UIButton!
    @IBOutlet weak var Loader: UIActivityIndicatorView!
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet var longpress: UILongPressGestureRecognizer!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet var longLabel: UILongPressGestureRecognizer!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tblSight: UITableView!
    
    
    
    let dataRef = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference()
    let loggedUser = FIRAuth.auth()?.currentUser
    
    var upload = false
    var coder: String!
    var posts = [profileStruct]()
 
    var cellID: String!
    var cellCode: String!
    
    var email:String!
    
    var imagePicker = UIImagePickerController()

    let user = FIRAuth.auth()?.currentUser
    
    //I was being lazy and made variables for these references
   let NameLoad = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Name")

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.posts.removeAll()
        
       dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").queryOrdered(byChild: "Time").observe(.childAdded, with: { (snapshot) in
        
        if snapshot.exists() == true{
            let snapshotValueName = snapshot.value as? NSDictionary
            let Name = snapshotValueName?["Name"] as? String
            
            let snapshotValuePrice = snapshot.value as? NSDictionary
            let Location = snapshotValuePrice?["Location"] as? String
            
            let snapshotValueDate = snapshot.value as? NSDictionary
            let TimeAgo = snapshotValueDate?["date"] as? String
            
            let snapshotValueCode = snapshot.value as? NSDictionary
            let Code = snapshotValueCode?["code"] as? String
            self.coder = Code
            
            
            self.posts.insert(profileStruct(animalName: Name, location: Location, time: TimeAgo, code: Code), at: 0)
        }
        
        self.tblSight.reloadData()
        
       })
        
        
        
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
       
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // cellNumber = indexPath.row
        cellID = loggedUser!.uid
        cellCode = posts[indexPath.row].code
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "animal") as! AnimalViewController
        
        myVC.token = cellID!
        myVC.code = cellCode!
        
        //            print(myVC.token)
        self.present(myVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //creates as many rows as there are posts
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            
            let alertContoller = UIAlertController(title: "Confirm!", message: "Are You Sure You Want To Delete This Sighting?", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
                alert -> Void in
                
                let alertContoller2 = UIAlertController(title: "Success!", message: "You Successfully Deleted This Sighting", preferredStyle: .alert)
                
                let defaultAction2 = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alertContoller2.addAction(defaultAction2)
                
                self.dataRef.child("users").child(self.loggedUser!.uid).child("Sightings").child("\(self.loggedUser!.uid) - \(self.posts[indexPath.row].code!)").removeValue()
                
                self.dataRef.child("Sightings").child("\(self.loggedUser!.uid) - \(self.posts[indexPath.row].code!)").removeValue()
                
                self.posts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
               
                
                
                self.present(alertContoller2, animated:true, completion: nil)
            
            
        })
            
            alertContoller.addAction(yesAction)
            alertContoller.addAction(defaultAction)
            
            self.present(alertContoller, animated:true, completion: nil)
        }
        
        
        
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
            let myVC = self.storyboard?.instantiateViewController(withIdentifier: "Edit") as! EditViewController
            
        
            myVC.code = self.posts[indexPath.row].code
            
            //            print(myVC.token)
            self.present(myVC, animated: true)
            
            
           
            
        }
        
       
        
        
        
        edit.backgroundColor = .blue
        
        
        
        return [edit, delete]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creates a cell in the table and sets information based on the tag (Check tag in main.storyboard)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        
        
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = posts[indexPath.row].animalName
        
        
        let label2 = cell?.viewWithTag(2) as! UILabel
        if let temp1 = posts[indexPath.row].location{
            label2.text = temp1
        }
        
        
        let label3 = cell?.viewWithTag(3) as! UILabel
        label3.text = posts[indexPath.row].time
        
        
        return cell!
    }

 


    //when save button is clickedtab Bar
    
    @IBAction func SaveChanges(_ sender: Any) {
        
        
       // saveChange()
        
        
        
        //"upload" is if the image has been changed. If not (false), then the image isn't reuploaded which saves data, memory and database storage
        
        if upload == true{
            saveChange()
            self.dataRef.child("users").child(self.user!.uid).child("Name").setValue(lblName.text)
            //self.NameRef.child("artistProfiles").child(self.user!.uid).child("name").setValue(lblName.text)
            upload = false
        }
        else{
            self.dataRef.child("users").child(self.user!.uid).child("Name").setValue(lblName.text)
           
            btnSave.isHidden=true
            
                   }
    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
                                                    //SETTING UP THE PROFILE
    func setupProfile(){

        imgMain.layer.cornerRadius = imgMain.frame.width/2
        imgMain.clipsToBounds = true
        
        btnSave.layer.cornerRadius = 5
        btnSave.clipsToBounds = true

        self.Loader.startAnimating()
        
        
        //loading image from database into view. Found this online. Not as efficient as I would have liked but it works
            let uid = FIRAuth.auth()?.currentUser?.uid
            dataRef.child("users").child(uid!).observeSingleEvent(of: .value, with: {  (snapshot) in
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
                            self.imgMain?.image = UIImage(data: data!)
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
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
                                            //Loading all the default value
        NameLoad.observe(.value){
            (snap: FIRDataSnapshot) in
            self.lblName.text = snap.value as? String
            
        }

        dataRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Email").observe(.value){
            (snap: FIRDataSnapshot) in
            if let temp1 = snap.value as? String{
                self.email = temp1
                self.lblEmail.text = temp1
            }
            
        }
        
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    //image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        btnSave.isHidden = false

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
            imgMain.image = selectedImage2
            upload = true
            Loader.stopAnimating()
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //if persons presses cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
   
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
                                                    //SAVING CHANGES
    func saveChange(){
        
        Loader.startAnimating()
        let imageName =  NSUUID().uuidString
        let storedImage = storageRef.child("imgMain").child(imageName)
        
        
        //also found this online
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
                        self.dataRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["pic" : urlText], withCompletionBlock: { (error,ref) in
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
    }

//what happens when logout is clicked
    func LogoutSeq(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "login")
        self.present(loginVC, animated: true, completion: nil)
        
        }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //When user taps profile picture
    @IBAction func Tapped(_ sender: UITapGestureRecognizer) {
        
        //this method opens a little menu at the bottom with the options; View Picture, Photos and Camera
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        let myActionSheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let viewPicture = UIAlertAction(title: "View Picture", style: UIAlertActionStyle.default) { (action) in
            //Put code for what happens when the button is clicked
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
        
        
        myActionSheet.addAction(viewPicture)
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    // This func just dismisses the view when the user tappen "View Picture"
    func dismissFullScreenImage(_sender:UITapGestureRecognizer){
        _sender.view?.removeFromSuperview()
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    

                        //long press for cover photo (Not being used)
    @IBAction func LongPress(_ sender: UILongPressGestureRecognizer) {
}

    @IBAction func longPressLabel(_ sender: UILongPressGestureRecognizer) {
        //When the label with the name stored in it is long pressed, this occurs
        
        //Allows me to edit the name in the database. I don't like the look of it but it will suffice for now
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
    
 
    

    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    @IBAction func btnMoreAction(_ sender: Any) {
        

        let myActionSheet = UIAlertController(title: "Options", message: "Select", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        let Logout = UIAlertAction(title: "Logout", style: UIAlertActionStyle.default) { (action) in
            
            
            self.setupProfile()
            try! FIRAuth.auth()?.signOut()
            self.LogoutSeq()
            
        }
        
        myActionSheet.addAction(Logout)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        self.viewDidLoad()
    }
    
    
   
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
}
