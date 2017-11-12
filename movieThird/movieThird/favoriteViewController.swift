//
//  favoriteViewController.swift
//  movieThird
//
//  Created by Terry Lyu on 2/26/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class favoriteViewController: UIViewController , UITableViewDataSource, UITextViewDelegate,UITableViewDelegate, UITabBarControllerDelegate{
    var tableView: UITableView!
    var currentUser : String!
    var detailedData : [MovieData] = []
    var detailedImage : UIImage!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBAction func registerPressed(_ sender: Any) {
        
        
        FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordEntered.text!) { user, error in
            if error == nil {
                // 3
                FIRAuth.auth()!.signIn(withEmail: self.emailField.text!,
                                       password: self.passwordEntered.text!)
                
                
                self.loginField.isHidden = true
                self.setupTableView()
                self.tableView.reloadData()
            }
            
            else {
                
                let alertController = UIAlertController(title: "Error", message:
                    "email error, enter a non existing email or a valid email format  ", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "go back to register", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
  
                
                
            }
            
            
            
        }
        
        
    }
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var loginField: UIStackView!
    @IBOutlet weak var passwordEntered: UITextField!
    
    
    @IBAction func resetPressed(_ sender: Any) {
        
        let email = self.emailField.text!
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                
                let alertController = UIAlertController(title: "Error", message:
                    "reset password, enter a existing email or a valid email format  ", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "go back to reset", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                print(error)
                // An error happened.
            } else {
                print("password reset sent")
                // Password reset email sent.
            }
        }
    }
    @IBAction func logoutpressed(_ sender: Any) {
        logoutBtn.isHidden = true
        
         try! FIRAuth.auth()!.signOut()
        print("logging yo out ")
    self.loginField.isHidden = false
    self.tableView.isHidden = true
    }

    @IBAction func loginPressed(_ sender: Any) {
    let rootRef = FIRDatabase.database().reference()
        
        
        
        FIRAuth.auth()!.signIn(withEmail: self.emailField.text!,
                               password: self.passwordEntered.text!){user , error in
                                if error == nil {
                                    
                                    // now user is logged in, I need to retrieve user favorite list from firebase
                                    
                                    rootRef.child((user?.uid)!).observeSingleEvent(of: .value, with: {(snapshot) in
                                        
                                        // get user value
                                        
                                        
                                        let value = snapshot.value as? NSArray
                                        
                                        if (value == nil){
                                            favoriteList = []
                                        }
                                        // favorite list is a global variable maintaining user's favorite list 
                                        else{
                                         favoriteList = value! as! [String]
                                        }
                                        self.logoutBtn.isHidden = false
                                        self.emailField.text = ""
                                        self.passwordEntered.text = ""
                                        
                                        
                                        self.loginField.isHidden = true
                                        self.setupTableView()
                                        self.tableView.reloadData()
                                    
                                    })
                                    
                                }
                                
                                else{
                                    let alertController = UIAlertController(title: "sign in Error", message:
                                        "email and password combo invalid, if forgot, please register new account or reset your password  ", preferredStyle: UIAlertControllerStyle.alert)
                                    alertController.addAction(UIAlertAction(title: "Go back to login", style: UIAlertActionStyle.default,handler: nil))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                    self.passwordEntered.text = ""

                                }
        }
       
       
        
    }
    
    private func setupTableView() {
        
        tableView = UITableView(frame: view.frame.offsetBy(dx: 0, dy: 100))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
    }
    
    func tabBarController(_: UITabBarController, didSelect: UIViewController){
        reload()
        print("tab bar presesd in new view")
        
    }
    func reload(){
        
        
        self.tableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
              cell.textLabel!.text = favoriteList[indexPath.row]
        
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            favoriteList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let rootRef = FIRDatabase.database().reference()

              let favoriteRef = rootRef.child(currentUser)
            favoriteRef.setValue(favoriteList)

            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                 DispatchQueue.global(qos: .userInitiated).async {
                
                
                    if (favoriteList.count != 0){
                        self.fetchDetailedData(movieName: ViewController().parseMovieName(movieName: favoriteList[indexPath.row])
                        )

                
                DispatchQueue.main.async {
                    
                    // self.detailedImage = self.theImageCache[indexPath.row]
                
                    self.performSegue(withIdentifier: "favToDetail", sender: nil)
                    
                    
                    
                        }
                
                
            }
            
            
            
            
            
        }
        
    }
    
    // has a table view, need to load data from main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutBtn.isHidden = true
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            
            
            if user != nil {
                self.currentUser = user?.uid
            }
        }

    }
    
   
    func fetchDetailedData(movieName : String){
        detailedData = []
        
        let json = ViewController().getJSON("https://www.omdbapi.com/?t=\(movieName)&r=json")
        //print(json)
        let Title = json["Title"].stringValue
        let Year = json["Year"].stringValue
        let Rated = json["Rated"].stringValue
        let Poster = json["Poster"].stringValue
        let Metascore = json["Metascore"].stringValue
        
        detailedData.append(MovieData(Title:Title, Year:Year, Metascore:Metascore , Rated:Rated, url:Poster))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favToDetail"{
            
           
             if let detailedVC = segue.destination as? detailedViewController{
                
                
               
                if (favoriteList.contains(detailedData[0].Title)){
                    detailedVC.favorited = true
                }
                else{detailedVC.favorited = false
                }

                
             //   detailedVC.detailToFavBtn.isHidden = false;
                
                
                if (detailedData[0].Year != ""){
                    detailedVC.Year = detailedData[0].Year
                }
                if (detailedData[0].Rated != ""){
                    detailedVC.Rated = detailedData[0].Rated
                    
                }
                if ( detailedData[0].Metascore != ""){
                    detailedVC.MetaScore = detailedData[0].Metascore
                    
                    
                }
                
                let url = URL(string: self.detailedData[0].url)
                
                let data = try? Data(contentsOf: url!)
                
                if (data != nil){
                    
                    let image = UIImage(data: data!)
                    self.detailedImage = image
                    // theImageCache.append(image!)
                }
                else {
                    
                    
                    let image = UIImage(named: "404.jpg")
                    self.detailedImage = image
                    //theImageCache.append(image!)
                }

                
                              detailedVC.theImage = detailedImage
                detailedVC.title1 = detailedData[0].Title

                
                
            }
            
            
            
            
        }
    }
    
    //  @IBOutlet weak var testlabel: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.loginField.isHidden == true){
           self.tableView.reloadData()
        
        }
        
        
    }
    
    
 
    
}
