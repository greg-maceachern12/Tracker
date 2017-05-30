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



class ArtistViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tbDescription: UITextView!
    @IBOutlet weak var picturePicker: UIPickerView!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnPin: UIButton!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var Scroller: UIScrollView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var lblPrice1: UILabel!
    @IBOutlet var Long1: UILongPressGestureRecognizer!
    @IBOutlet weak var NAVTitle: UINavigationItem!
    @IBOutlet var LongPrice: UILongPressGestureRecognizer!

    var dataRef = FIRDatabase.database().reference()
    var storageRef = FIRStorage.storage().reference()
    var loggedUser = FIRAuth.auth()?.currentUser
    
    var Loader: UIActivityIndicatorView!
    
    var tracker: Int! = 0
    
    var status: String!
    
    var table1 = false
    var count = 0
    var posts:[String?] = ["Add Something!","Add Something!","Add Something!"]
    var posts2:[String?] = []
    
    var imagePicker = UIImagePickerController()
    var url: NSURL!
    var tempImg = UIImageView()
    
    var placeholderLabel: UILabel!
    var tempImg1 = UIImageView()
    var tempImg2 = UIImageView()
    var tempImg3 = UIImageView()
    
    var temp1: String!
    var temp2: String!
    var temp3: String!
    
    var key: Int!
    
    var token: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Scroller.contentSize = CGSize(width: self.view.frame.width, height: 1400)
        
        if token != loggedUser?.uid
        {
            tbDescription.isUserInteractionEnabled = false
            Long1.isEnabled = false
            LongPrice.isEnabled = false
            
            dataRef.child("artistProfiles").child(self.token).child("name").observe(.value){
                (snap: FIRDataSnapshot) in
                self.NAVTitle.title = "\(snap.value as! String)'s Profile"
            }
        }
        else
        {
            dataRef.child("artistProfiles").child(self.token).child("name").observe(.value){
                (snap: FIRDataSnapshot) in
                self.NAVTitle.title = "\(snap.value as! String) (Your Profile)"
            }
        }
        
        
        //print("the key is \(cellNumber)")
        
        tbDescription.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        placeholderLabel.numberOfLines = 4
        placeholderLabel.text = "Give your clients some information about yourself \n Eg. Where you're from \n Eg. The equipment you use \n Eg. Links to websites/other portals"
        placeholderLabel.font = UIFont(name: "Avenir Next", size: 14)
        placeholderLabel.sizeToFit()
        tbDescription.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tbDescription.font?.pointSize)!/2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tbDescription.text.isEmpty
        
        SetUp()
        SetPic()
        //print(posts)
        
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        placeholderLabel.isHidden = !tbDescription.text.isEmpty
    }
 
  
 
    func textViewDidChange(_ textView: UITextView) {
       self.dataRef.child("artistProfiles").child(token).child("about").setValue(tbDescription.text)
        
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////////////

    
    
    
                            //PICKER VIEW FUNCTIONS
    
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
        //print(tracker)
        
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //declaring the things which will be in the pickerview
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 120))
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 120))
        Loader = UIActivityIndicatorView(frame: CGRect(x: pickerView.frame.width/2, y: 60, width: 40, height: 40))
        let myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 120))
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.backgroundColor = UIColor.clear
        var rowString = String()
        
        
        
        Loader.color = UIColor.white
    
    
        

            //initializing the picker rows data
        switch row {
        case 0:
            if tempImg1.image == nil
            {
                myImageView.image = #imageLiteral(resourceName: "Default")
            }
            else
            {
            myImageView.image = tempImg1.image
            }
            //
            
        case 1:
            if tempImg2.image == nil
            {
              myImageView.image = #imageLiteral(resourceName: "Default")
            }
            else
            {
            myImageView.image = tempImg2.image
            }

        case 2:
            if tempImg3.image == nil{
                myImageView.image = #imageLiteral(resourceName: "Default")
            }
            else
            {
            myImageView.image = tempImg3.image
            }

        
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
    
    
    
    //method for setting an image and saving it
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
            //ugh.image = selectedImage2 as UIImage
            tempImg.image = selectedImage2 as UIImage
            
        }
        
        //very important. This keeps track of which row was clicked to have the image uploaded. Overall, using the pickercontroller was inefficient and was very slow. Might change
       
            if (tracker == 0)
            {
                status = "ProfilePic1"
                tempImg1.image = tempImg.image
                
                UploadImage()
            }
                
            else if (tracker == 1)
            {
                status = "ProfilePic2"
                tempImg2.image = tempImg.image
                
                UploadImage()
            }
            else if tracker == 2
            {
                status = "ProfilePic3"
                tempImg3.image = tempImg.image
                
                UploadImage()
            }
            
        
        dismiss(animated: true, completion: nil)
    
    }
    
    
    @IBAction func longPressPicker(_ sender: UILongPressGestureRecognizer) {
        
        
        
        
        // this is for whena  row is long pressed to change the image
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
    
    
    
                                //Uploading Images
    func UploadImage(){
        
        let imageName =  NSUUID().uuidString
        //let imageNameCover = NSUUID().uuidString
        
        let storedImage = storageRef.child("imgProfile").child(self.token).child(imageName)

        
        
        if let uploadData = UIImagePNGRepresentation(self.tempImg.image!)
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
                            self.dataRef.child("artistProfiles").child(self.token).updateChildValues(["\(self.status!)" : urlText], withCompletionBlock: { (error,ref) in
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
    
    
    ///////////////////////////////////////////////////////////////////////////////////////
    
    
    
                    //TABLE FUNCTIONS
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //count = indexPath.row
       // print(count)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //sets the label in the cell to be data from the array "posts" which is a string of values grabbed from the database
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let tb1 = cell?.viewWithTag(1) as! UITextView
        tb1.text = posts[indexPath.row]!
        
        return cell!
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    @IBAction func LongPrice1(_ sender: UILongPressGestureRecognizer) {
        let alertController = UIAlertController(title: "Edit Pricing", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            firstTextField.keyboardType = UIKeyboardType.decimalPad
            
            if firstTextField.text == ""
            {
                
            }
            else
            {
                
                self.lblPrice1.text = "$\(firstTextField.text!)"
                self.dataRef.child("artistProfiles").child(self.token).child("Pricing1").child("Price1_0").setValue(firstTextField.text)
                
                
                
                
            }
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Describe this pricing"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        print("true")
        

    }
    
    

    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
    
        //swipe to edit feature
          if token == loggedUser?.uid
          {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            //What happens when Edit button is tapped
            self.count = index.row
            //print(self.count)
            
       
            
            let alertController = UIAlertController(title: "Edit", message: "", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
                alert -> Void in
                
                let firstTextField = alertController.textFields![0] as UITextField
                
                if firstTextField.text == ""
                {
                    
                }
                else
                {
                    //print("firstName \(firstTextField.text)")
                if self.count == 0
                {
                    self.dataRef.child("artistProfiles").child(self.token).child("Price1").child("Price1_0").setValue(firstTextField.text)
                    }
                else if self.count == 1
                    {
                        self.dataRef.child("artistProfiles").child(self.token).child("Price1").child("Price1_1").setValue(firstTextField.text)
                    }
                 else if self.count == 2
                    {
                        self.dataRef.child("artistProfiles").child(self.token).child("Price1").child("Price1_2").setValue(firstTextField.text)
                    }
                }
            
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
                
            })
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Describe this pricing"
            }
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        

            
            
        }
        edit.backgroundColor = .blue
        
        return [edit]
        }
        else
          {
            return nil
        }
        
    }
    
    
    
    
    
    
    
    func SetUp(){
       
        
        btnPin.layer.cornerRadius = 5
        btnPin.clipsToBounds = true
        
        btnBook.layer.cornerRadius = 5
        btnBook.clipsToBounds = true
        
        btnMessage.layer.cornerRadius = 5
        btnMessage.clipsToBounds = true
        
        //print("token oss \(self.token!)")
        
        dataRef.child("artistProfiles").child(self.token).child("pic").observe(.value){
            (snap: FIRDataSnapshot) in
            if snap.exists() == true{
            if let pic = snap.value as? String{
                self.url = NSURL(string:pic)
                //print(self.url)
                }
            else{
                
                }
            }
        }
        
        
       
        
        dataRef.child("artistProfiles").child(self.token).child("about").observe(.value){
            (snap: FIRDataSnapshot) in
            self.tbDescription.text = snap.value as? String
            
        }
        
        dataRef.child("artistProfiles").child(self.token).child("Pricing1").child("Price1_0").observe(.value){
            (snap: FIRDataSnapshot) in
            if snap.exists() == true
            {
            self.lblPrice1.text = "$\(snap.value! as! String)"
            }
            
            
        }
        
        if tbDescription.text == ""{
            
            tbDescription.text = "Enter A Detailed Description"
            tbDescription.textColor = UIColor.lightGray
            
        }
        dataRef.child("artistProfiles").child(self.token).child("name").observe(.value){
            (snap: FIRDataSnapshot) in
            self.lblName.text = snap.value as? String
        }
        dataRef.child("artistProfiles").child(self.token).child("Price1").child("Price1_0").observe(.value){
            (snap: FIRDataSnapshot) in
            self.temp1 = snap.value as? String
            if self.temp1 != nil
            {
                self.posts[0] = self.temp1!
                self.tableView1.reloadData()
            }
            else{
            
            }
        }
        dataRef.child("artistProfiles").child(self.token).child("Price1").child("Price1_1").observe(.value){
            (snap: FIRDataSnapshot) in
            self.temp2 = snap.value as? String
            if self.temp2 != nil
            {
            self.posts[1] = self.temp2!
            self.tableView1.reloadData()
            }
            else
            {
                
            }
        }
        
        
        dataRef.child("artistProfiles").child(self.token).child("Price1").child("Price1_2").observe(.value){
            (snap: FIRDataSnapshot) in
            self.temp3 = snap.value as? String
            if self.temp3 != nil
            {
            self.posts[2] = self.temp3!
            self.tableView1.reloadData()
            }
            else{
                
            }
            
        }
        
        

        
        //print(posts)

    }
    func SetPic()
    {
       
                   dataRef.child("artistProfiles").child(self.token).observeSingleEvent(of: .value, with: {  (snapshot) in
                
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
                                    print("nil")
                                    
                                }
                                else
                                {
                                    self.tempImg1.image = UIImage(data: data!)
                                    
                                }
                                
                                
                            }
                        }).resume()
                    }
                }
            
            })
            
     
            dataRef.child("artistProfiles").child(self.token).observeSingleEvent(of: .value, with: {  (snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    
                    
                    if let profileImageURL = dict["ProfilePic2"] as? String
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
                                    print("nil")
                                    
                                }
                                else
                                {
                                    self.tempImg2.image = UIImage(data: data!)
                                  
                                }
                                
                                
                            }
                        }).resume()
                    }
                }
                
            })
            
       
        
       
            dataRef.child("artistProfiles").child(self.token).observeSingleEvent(of: .value, with: {  (snapshot) in
                
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
                                print(data!)
                                if data == nil
                                {
                                    print("nil")
                                    
                                }
                                else
                                {
                                    self.tempImg3.image = UIImage(data: data!)
                                    
                                    
                                }
                                
                                
                            }
                        }).resume()
                    }
                }
                
            })
        
      
    }
    
    



}
