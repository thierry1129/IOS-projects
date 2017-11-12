//
//  ViewController.swift
//  movieThird
//
//  Created by Terry Lyu on 2/25/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
var favoriteList: [String] = []

class ViewController: UIViewController , UITextFieldDelegate, UICollectionViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITabBarControllerDelegate{
  
    @IBOutlet weak var numberPick: UIPickerView!
    var theImageCache: [UIImage] = []
    var theData: [MovieData] = []
    var detailedData : [MovieData] = []
    var testCount  = 0
    var detailedImage : UIImage!
    var peekView = peelViewController()
    
    
    
    var detailedJson :JSON!
    
    var pickerData: [String] = [String]()
    var movieSearch : String = ""
    var movieNum : Int = 10
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchFieldVal: UITextField!
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBAction func end(_ sender: Any) {
        
        let searchIndicator =   UIActivityIndicatorView()
        searchIndicator.color = .black
        searchIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchIndicator.center = self.view.center
        searchIndicator.hidesWhenStopped = true
                self.view.addSubview(searchIndicator)
        movieSearch = parseMovieName(movieName: searchFieldVal.text!)
        print(movieSearch)
       
        DispatchQueue.global(qos: .userInitiated).async {
            searchIndicator.startAnimating()
            self.fetchDataForCollectionView(movieName: self.movieSearch)
            self.cacheImages()
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                searchIndicator.stopAnimating()
            }
            
        }
        
        
        
        
        
        
    }
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        
        
        
        collectionView  = UICollectionView(frame: view.frame.offsetBy(dx: 0, dy: 0), collectionViewLayout: layout)
        collectionView.dataSource = self
        
        
        collectionView.delegate = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        registerForPreviewing(with: self,sourceView: collectionView)
        
        self.view.addSubview(collectionView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToDetail"{
            
            if let detailedVC = segue.destination as? detailedViewController{
                
                if (favoriteList.contains(detailedData[0].Title)){
                    detailedVC.favorited = true
                }
                else{detailedVC.favorited = false
                }
                
                
                
                if (detailedData[0].Year != ""){
                    detailedVC.Year = detailedData[0].Year
                }
                if (detailedData[0].Rated != ""){
                    detailedVC.Rated = detailedData[0].Rated
                    
                }
                if ( detailedData[0].Metascore != ""){
                    detailedVC.MetaScore = detailedData[0].Metascore
                    
                    
                }
                detailedVC.theImage = detailedImage
                detailedVC.title1 = detailedData[0].Title
                
                
            }
        }
        
        
        
    }
    
    private func cacheImages() {
        theImageCache = []
        for item in theData {
            
            let url = URL(string: item.url)
            
            let data = try? Data(contentsOf: url!)
            
            if (data != nil){
                
                let image = UIImage(data: data!)
                theImageCache.append(image!)
            }
            else {
                
                
                let image = UIImage(named: "404.jpg")
                theImageCache.append(image!)
            }
        }
        
    }
    
    func getJSON(_ url: String) -> JSON {
        
        if let url = URL(string: url){
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                
                return json
            } else {
                
                return JSON.null
            }
        } else {
            
            return JSON.null
        }
        
        
        
        
        
    }
    func fetchPeekData(movieName: String) -> String{
        
        let json = getJSON("https://www.omdbapi.com/?t=\(movieName)&r=json")
        
        var plot = json["Plot"].stringValue
        print("the plot is ", plot)
        if (plot == ""){
            plot = " no plot stored in database "
        }
        return plot
        
    }
    func fetchDetailedData(movieName : String){
        detailedData = []
        
        let json = getJSON("https://www.omdbapi.com/?t=\(movieName)&r=json")
        //print(json)
        let Title = json["Title"].stringValue
        let Year = json["Year"].stringValue
        let Rated = json["Rated"].stringValue
        let Poster = json["Poster"].stringValue
        let Metascore = json["Metascore"].stringValue
        
        detailedData.append(MovieData(Title:Title, Year:Year, Metascore:Metascore , Rated:Rated, url:Poster))
    }
    
    
    private func fetchDataForCollectionView( movieName : String){
        theData = []
        
        
        switch movieNum{
        case 20:
            let json = getJSON("https://www.omdbapi.com/?s=\(movieSearch)&page=\(movieNum/20)&r=json")
            let json1 = getJSON("https://www.omdbapi.com/?s=\(movieSearch)&page=\(movieNum/10)&r=json")
            
            let json2 = json["Search"].arrayValue
            let json3 = json1["Search"].arrayValue
            
            for result in json2{
                
                let Title = result["Title"].stringValue
                let Year = result["Year"].stringValue
                let Rated =  result["Rated"].stringValue
                let Metascore = result["Metascore"].stringValue
                let Poster = result["Poster"].stringValue
                theData.append(MovieData(Title:Title, Year:Year, Metascore:Metascore , Rated:Rated, url:Poster))
            }
            
            
            for result in json3{
                
                let Title = result["Title"].stringValue
                let Year = result["Year"].stringValue
                let Rated =  result["Rated"].stringValue
                let Metascore = result["Metascore"].stringValue
                let Poster = result["Poster"].stringValue
                theData.append(MovieData(Title:Title, Year:Year, Metascore:Metascore , Rated:Rated, url:Poster))
            }
            
        case 30:
            let json1 = getJSON("https://www.omdbapi.com/?s=\(movieSearch)&page=\(movieNum/30)&r=json")
            let json3 = json1["Search"].arrayValue
            
            for result in json3{
                
                let Title = result["Title"].stringValue
                let Year = result["Year"].stringValue
                let Rated =  result["Rated"].stringValue
                let Metascore = result["Metascore"].stringValue
                let Poster = result["Poster"].stringValue
                theData.append(MovieData(Title:Title, Year:Year, Metascore:Metascore , Rated:Rated, url:Poster))
            }
            let json2 = getJSON("https://www.omdbapi.com/?s=\(movieSearch)&page=\(movieNum/10-1)&r=json")
            let json4 = json2["Search"].arrayValue
            
            for result in json4{
                
                let Title = result["Title"].stringValue
                let Year = result["Year"].stringValue
                let Rated =  result["Rated"].stringValue
                let Metascore = result["Metascore"].stringValue
                let Poster = result["Poster"].stringValue
                theData.append(MovieData(Title:Title, Year:Year, Metascore:Metascore , Rated:Rated, url:Poster))
            }
            
            let json5 = getJSON("https://www.omdbapi.com/?s=\(movieSearch)&page=\(movieNum/10)&r=json")
            let json6 = json5["Search"].arrayValue
            
            for result in json6{
                
                let Title = result["Title"].stringValue
                let Year = result["Year"].stringValue
                let Rated =  result["Rated"].stringValue
                let Metascore = result["Metascore"].stringValue
                let Poster = result["Poster"].stringValue
                theData.append(MovieData(Title:Title, Year:Year, Metascore:Metascore , Rated:Rated, url:Poster))
            }
        default:
            
            let json5 = getJSON("https://www.omdbapi.com/?s=\(movieSearch)&page=\(movieNum/10)&r=json")
            let json6 = json5["Search"].arrayValue
            // print(json6)
            for result in json6{
                
                let Title = result["Title"].stringValue
                let Year = result["Year"].stringValue
                let Rated =  result["Rated"].stringValue
                let Metascore = result["Metascore"].stringValue
                let Poster = result["Poster"].stringValue
                theData.append(MovieData(Title:Title, Year:Year, Metascore:Metascore , Rated:Rated, url:Poster))
            }
            
            
            
        }
        
        
        
    }
    
    func parseMovieName (movieName : String)->String
    {
        var returnName = ""
        let realName = movieName.components(separatedBy: " ")
        
        for word in realName{
            returnName.append(word)
            if (word != realName.last){
                returnName.append("+")
            }
            
        }
        return returnName
        
    }
    
    
    //text field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // print("end")
    }
    
    
    
    
    
    
    // picker
    
    
    
    
    
    
    // The number of rows of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int)
    {
        
        if (row == 0 ){
            
            movieNum = 10
        }
        else if (row == 1){
            
            movieNum = 20
        }
            
        else{
            
            
            
        movieNum = 30
        }
        
        
        
    }
    
    
    
  
    
    override func viewDidLoad() {
               super.viewDidLoad()
       
        
        
        if let collectionView = self.collectionView {
            registerForPreviewing(with: self, sourceView: collectionView)
        }
        pickerData = ["10","20","30"]
        numberPick.delegate = self
        numberPick.dataSource = self
        
        
        self.tabBarController?.delegate = self
        searchFieldVal.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(movieCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
       
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController : UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
      //  print ("touched")
        
        previewingContext.sourceRect = cell.frame
        //var peekView = peelViewController()
        
        
        let plot =  fetchPeekData(movieName: self.theData[indexPath.row].Title)
        self.peekView.plotText?.text = plot
        //  self.peekView.setupText(text: plot)
        
        
        let preferedWidth = self.view.frame.width - 50.0
        self.peekView.preferredContentSize = CGSize(width: preferedWidth, height: preferedWidth)
        
        return self.peekView
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(self.peekView, sender: self)
    }
    
}

extension ViewController : UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! movieCollectionViewCell
        
        cell.textLabel.text = theData[indexPath.row].Title
        cell.imageView.image=theImageCache[indexPath.row]
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchIndicator =   UIActivityIndicatorView()
        searchIndicator.color = .black
        searchIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchIndicator.center = self.view.center
        searchIndicator.hidesWhenStopped = true
        self.view.addSubview(searchIndicator)
        
        
        DispatchQueue.global(qos: .userInitiated).async {
             searchIndicator.startAnimating()
            self.fetchDetailedData(movieName: self.parseMovieName(movieName:(self.theData[indexPath.row].Title)))
            DispatchQueue.main.async {
                
                self.detailedImage = self.theImageCache[indexPath.row]
                
                searchIndicator.stopAnimating()
                self.performSegue(withIdentifier: "mainToDetail", sender: nil)
                
            }
            
            
        }
        
        
        
        
        
        
    }
    
    
}


