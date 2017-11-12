//
//  detailedViewController.swift
//  movieThird
//
//  Created by Terry Lyu on 2/25/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
class detailedViewController: UIViewController ,UINavigationControllerDelegate{
    var theImage: UIImage!
    var Year: String!
    var MetaScore : String!
    var Rated : String!
    var currentUser : String!
    
    
    @IBOutlet weak var detailToFavBtn: UIButton!
    
    
    
    
    let rootRef = FIRDatabase.database().reference()
    var favorited  = false
    var title1: String!
    
    override func viewDidLoad() {
        
    //    detailToFavBtn.isHidden = true;
        
     favoriteButton.isHidden = true
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            
            
            if (user?.email != nil) {
                               self.currentUser = user?.uid
              //  print(user?.displayName)
                self.favoriteButton.isHidden = false
            }
            else{
               self.favoriteButton.isHidden = true
            }
        }
        imageView.image = theImage
        titleLabel.text = title1
        metaScoreLabel.text = MetaScore
        yearLabel.text = Year
        ratedLabel.text = Rated
        if (!favorited){
            favoriteButton.setTitle("favorite", for: .normal)
            // favorited = true
        }
        else {
            favoriteButton.setTitle("unfavorite", for: .normal)
            //  favorite = false
            
        }
         navigationController?.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratedLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var metaScoreLabel: UILabel!
    
    
    
    
    
    
    @IBAction func favoritePressed(_ sender: Any) {
        let favoriteRef = self.rootRef.child(currentUser)

        if (!favorited){
            favoriteButton.setTitle("unfavor", for: .normal)
            favorited = true
           favoriteList.append(title1)

                      favoriteRef.setValue(favoriteList)
        }
        else {
            favoriteButton.setTitle("favorite", for: .normal)
            favorited = false
            if (favoriteList.contains(title1)){
                
                while(favoriteList.contains(title1)){
                    if let itemToRemoveIndex = favoriteList.index(of:title1){
                        favoriteList.remove(at: itemToRemoveIndex)
                       
                    }
                    
                }
               
                favoriteRef.setValue(favoriteList)

            }

            
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailToFav"{
            
            
            
            if let detailedVC = segue.destination as? favoriteViewController{
                
                detailedVC.loginField.isHidden = false
            
            
            
        }
        

    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
}
