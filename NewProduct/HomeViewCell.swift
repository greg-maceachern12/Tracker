//
//  HomeViewCell.swift
//  NewProduct
//
//  Created by Greg  MacEachern on 2017-04-29.
//  Copyright © 2017 Greg MacEachern. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

  class HomeViewCell: UITableViewCell{
    
    var dataRef = FIRDatabase.database().reference()
    var loggedUser = FIRAuth.auth()?.currentUser
    var storage = FIRStorage.storage()
    

    @IBOutlet weak var Loader: UIActivityIndicatorView!
    @IBOutlet weak var imgMain: UIImageView!
   // @IBOutlet weak var lblTitle: UILabel!
   // @IBOutlet weak var tbDescript: UITextView!
  //  @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgMain.layer.cornerRadius = 3
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = CGRect(origin: CGPoint(x: 8,y :8), size: CGSize(width: 40, height: 40))
        self.imageView?.frame = rect
        self.imageView?.layer.cornerRadius = 10
        
    }
}
