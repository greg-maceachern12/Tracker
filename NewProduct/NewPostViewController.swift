
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

struct postStruct {
    let title: String!
    let price: Int!
    let date: String!
    let picture: FIRDatabaseReference!
}

class NewPostViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    
    @IBOutlet weak var tbTitle: UITextField!
   //@IBOutlet weak var tbDescription: UITextView!
    @IBOutlet weak var tbPrice: UITextField!
    @IBOutlet weak var Date: UIDatePicker!
    @IBOutlet weak var btnPost: UIButton!

    var dataRef = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference()
    var loggedUser = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tbDescription.text = "Enter A Detailed Description"
//        tbDescription.textColor = UIColor.lightGray
        btnPost.layer.cornerRadius = 7
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
//        if (tbDescription.textColor == UIColor.lightGray || tbDescription.text == "Enter A Detailed Description")
//        {
//            tbDescription.text = ""
//            tbDescription.textColor = UIColor.black
//        }
    }
    
    //code for cancel
    @IBAction func didCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tbPrice.resignFirstResponder()
        tbTitle.resignFirstResponder()
        return false
    }
   
    
    

    //code for posting
    @IBAction func didPost(_ sender: Any) {
        
        //format for making date appear as dd/mm/yy
        
        
       // self.dataRef.child("users").child(self.loggedUser!.uid).child("posts").child("Title").setValue(tbTitle.text)
       // self.dataRef.child("users").child(self.loggedUser!.uid).child("posts").child("Description").setValue(tbDescription.text)
        //self.dataRef.child("users").child(self.loggedUser!.uid).child("posts").child("Time").setValue(tbTitle.text)
        
        
        if (tbPrice.text!.characters.count > 0 && tbTitle.text != "")
        {

              //let imageName =  NSUUID().uuidString
            //let storedImage = storageRef.child("imgMain").child(imageName)
            
            dataRef.child("users").child(loggedUser!.uid).observeSingleEvent(of: .value, with: {  (snapshot) in
                
                
                let dict = snapshot.value as? [String: AnyObject]
            
            
                let profileImageURL = dict?["pic"] as? String
                
                if profileImageURL == nil
                {
                    let alertContoller = UIAlertController(title: "Oops!", message: "Set A Profile Picture", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertContoller.addAction(defaultAction)
                    
                    self.present(alertContoller, animated:true, completion: nil)
                }
                else
                {
                
                let url = URL(string: profileImageURL!)
                let urlText = url?.absoluteString
                
            
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = DateFormatter.Style.short
                let dob = dateformatter.string(from: NSDate() as Date)
                
                
                
                let tableTitle = self.tbTitle.text
                let price = self.tbPrice.text
              
                
                let post: [String : AnyObject] = ["title": tableTitle as AnyObject,
                                                  "price": price as AnyObject,
                                                  "date": dob as AnyObject,
                                                  "img": urlText as AnyObject]
                
                
                self.dataRef.child("posts").childByAutoId().setValue(post)
                self.dismiss(animated: true, completion: nil)
                }
                
            })
            
            
           
            //print(img)
            
        }
        else
        {
            let alertContoller = UIAlertController(title: "Oops!", message: "Please Fill In Fields", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertContoller.addAction(defaultAction)
            
            self.present(alertContoller, animated:true, completion: nil)
        }
    }
    
    
}
