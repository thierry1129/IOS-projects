//
//  CommunityController.swift
//  The Vibe
//
//  Created by Rocomenty on 4/11/17.
//  Copyright © 2017 Shuailin Lyu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class CommunityController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var theTableView: UITableView!
    let searchIndicator =   UIActivityIndicatorView()
    var detailedData :NSDictionary = [:]
    var ref: FIRDatabaseReference?
    var refHandle: UInt!
    var activityArr : [Activities] = []
    var filteredAct : [Activities] = []
    var peekview = peekViewController()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchController.hidesNavigationBarDuringPresentation = false
        super.viewWillAppear(true)
        theTableView.dataSource = self
        theTableView.delegate = self
//        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ref = FIRDatabase.database().reference()
        setUpIndicator()
         DispatchQueue.global(qos: .userInitiated).async {
            self.searchIndicator.startAnimating()
            self.fetchActivities()
            DispatchQueue.main.async {
                self.theTableView.reloadData()
                self.searchIndicator.stopAnimating()
            }
        }
        
        registerForPreviewing(with: self, sourceView: theTableView)
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        theTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.barTintColor = UIColor.black
        searchController.searchBar.tintColor = getOrange()
        UIApplication.shared.statusBarStyle = .lightContent
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : getOrange()]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        print("trying to feeelltingggg    !!!")
        filteredAct = activityArr.filter { activity in
            return activity.title.lowercased().contains(searchText.lowercased())
        }
        
        theTableView.reloadData()
    }
    
    func setUpIndicator(){
        searchIndicator.color = .black
        searchIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchIndicator.center = self.view.center
        searchIndicator.hidesWhenStopped = true
        self.view.addSubview(searchIndicator)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredAct.count
        }
        return activityArr.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = theTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let activity : Activities
        if searchController.isActive && searchController.searchBar.text != "" {
            activity = filteredAct[indexPath.row]
        } else {
            print(activityArr)
            activity = activityArr[indexPath.row]
        }
        cell.textLabel?.text = activity.title
        cell.detailTextLabel?.text = activity.organizer
        return cell
    }
    
    
    
    
    
    var indexSelected = 0
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        indexSelected = indexPath.row
        
        self.performSegue(withIdentifier: "communityToDetail", sender: nil)
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "communityToDetail"{
            
            print("prepare for segue com to detail called")
            print("index is \(indexSelected)")
            
            if let detailedVC = segue.destination as? detailedViewController{
                
                
                detailedVC.eTitle = self.activityArr[indexSelected].title
                detailedVC.eOrganizer = self.activityArr[indexSelected].organizer
            }
        }
    }
    
    
    
    func fetchActivities() {
        refHandle = ref?.child("Activities").observe(.value, with: { (snapshot) in
            self.activityArr = []
            if let dic = snapshot.value! as? NSDictionary {
                let array = dic.allValues as NSArray
                
                for singleAct in array {
                    let dicAct = singleAct as! NSDictionary
                    
                    let activityFetched = Activities()
                    activityFetched.description = dicAct["description"]! as! String
                    activityFetched.title = dicAct["title"]! as! String
                    activityFetched.organizer = dicAct["organizer"]! as! String
                    activityFetched.startTime = stringToDate(dateString: dicAct["time"]! as! String)
                    activityFetched.type = stringToActivityType(str: dicAct["type"] as! String)
                    self.activityArr.append(activityFetched)
                }

            }
            self.theTableView.reloadData()
        })
    }
    
    
}



extension CommunityController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
extension CommunityController : UISearchResultsUpdating{
    
   
    func updateSearchResults(for: UISearchController){
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)

    }
 
}

extension CommunityController : UIViewControllerPreviewingDelegate{
     func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = theTableView.indexPathForRow(at: location) else {return nil}
        
        print("3dpressed !!!!!!!!!111")
        guard let cell = theTableView.cellForRow(at: indexPath) else {return nil}
        previewingContext.sourceRect = cell.frame
        let description = activityArr[indexPath.row].description
        self.peekview.peekText?.text = description
        
        
        let preferedWidth = self.view.frame.width - 50.0
        self.peekview.preferredContentSize = CGSize(width: preferedWidth, height: preferedWidth)
        
        return self.peekview

        
        
        
        
    
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(self.peekview, sender: self)
    }
    
    
}
