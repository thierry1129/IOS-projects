//
//  ViewController.swift
//  firstPet
//
//  Created by Terry Lyu on 2/2/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
class ViewController: UIViewController {
    
    
    var pianoSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "cat", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    
    //image buttons
    
    @IBOutlet weak var imgBackground: UIView!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var dogButton: UIButton!
    
    @IBOutlet weak var catButton: UIButton!
    
    @IBOutlet weak var birdButton: UIButton!
    
    
    @IBOutlet weak var bunnyButton: UIButton!
    
    @IBOutlet weak var fishButton: UIButton!
    
    
    // action buttons
    
    @IBOutlet weak var feedButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    // labels
    
    
    @IBOutlet weak var happyLabel: UILabel!
    
    
    @IBOutlet weak var foodLabel: UILabel!
    
    //views
    
    @IBOutlet weak var happyView: DisplayView!
    @IBOutlet weak var foodView: DisplayView!
    
    
    
    // Spawn every 10 seconds to start with
    
    
    
    var currentPet:Pet!{
        didSet {
            updateView()
            
        }
        
        
        
    }
    
    
    
    let dog = Pet(name: "dog")
    
    let bird = Pet(name: "bird" )
    let bunny = Pet(name: "bunny")
    let cat = Pet(name: "cat" )
    let fish = Pet(name: "fish")
    var catSoundEffect: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBackground.backgroundColor = UIColor.red
        
        happyView.color = UIColor.red
        foodView.color = UIColor.red
        
        
        currentPet = dog
        let image1 = UIImage(named: "dog@2x.png") as UIImage!
        self.petImage.image = image1
        timePlay()
        timeCheckDead()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        petImage.isUserInteractionEnabled = true
        petImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if (currentPet == cat){
            let path = Bundle.main.path(forResource: "cat.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                catSoundEffect = sound
                sound.play()
            } catch {
                print("no file")
            }
        }
        else if (currentPet == dog){
            
            
            let path = Bundle.main.path(forResource: "dog.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                catSoundEffect = sound
                sound.play()
            } catch {
                print("no file")
            }
            
            
            
        }
        
        else if (currentPet == bunny){
            
            
            let path = Bundle.main.path(forResource: "bunny.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                catSoundEffect = sound
                sound.play()
            } catch {
                print("no file")
            }
            
            
            
        }
        else if (currentPet == fish){
            
            
            let path = Bundle.main.path(forResource: "fish.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                catSoundEffect = sound
                sound.play()
            } catch {
                print("no file")
            }
            
            
            
        }
        else if (currentPet == bird){
            
            
            let path = Bundle.main.path(forResource: "bird.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                catSoundEffect = sound
                sound.play()
            } catch {
                print("no file")
            }
            
            
            
        }

        
        
        
        
        
        // Your action
    }
    func timeCheckDead(){
        
        
        var timer
            = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector("checkDead"), userInfo: nil, repeats: true)
    }
    func checkDead(){
        
        if (currentPet.checkDead1()){
            
            
            updateView()
          
            
            
            let alertController = UIAlertController(title: "pet", message:
                "starved to death ", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "revive your pet", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
              currentPet.revive()
            updateView()

            
            
        }
            
            
            
            
            
            
            
        
        
    }
    func timePlay(){
        var timer
            = Timer.scheduledTimer(timeInterval: 8, target: self, selector: Selector("starvePet"), userInfo: nil, repeats: true)
    }
    func starvePet(){
        
                 currentPet.starve()
            
            
            updateView()
        

        
    }
    /*
    func funcPlay(){
        if (currentPet.food > 0){
            currentPet.food -= 1
            updateView()
        }
        else {
            
            
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dogClicked(_ sender: UIButton) {
        currentPet = dog
        
        let image1 = UIImage(named: "dog@2x.png") as UIImage!
        self.petImage.image = image1
        
        happyView.color = UIColor.red
        foodView.color = UIColor.red
         imgBackground.backgroundColor = UIColor.red

    }
    
    
    @IBAction func catClicked(_ sender: Any) {
        currentPet = cat
        let image1 = UIImage(named: "cat@2x.png") as UIImage!
        self.petImage.image = image1
        happyView.color = UIColor.yellow
        foodView.color = UIColor.yellow
         imgBackground.backgroundColor = UIColor.yellow
        

    }
    
    
    
    @IBAction func birdClicked(_ sender: Any) {
        currentPet = bird
        let image1 = UIImage(named: "bird@2x.png") as UIImage!
        self.petImage.image = image1
        happyView.color = UIColor.green
        foodView.color = UIColor.green
         imgBackground.backgroundColor = UIColor.green
        

    }
    
    
    
    
  
    
    @IBAction func bunnClicked(_ sender: Any) {
        currentPet = bunny
        let image1 = UIImage(named: "bunny@2x.png") as UIImage!
        self.petImage.image = image1
        happyView.color = UIColor.orange
        foodView.color = UIColor.orange
        imgBackground.backgroundColor = UIColor.orange
    }

    @IBAction func fishClicked(_ sender: UIButton) {
        currentPet = fish
        let image1 = UIImage(named: "fish@2x.png") as UIImage!
        self.petImage.image = image1
        happyView.color = UIColor.blue
        foodView.color = UIColor.blue
         imgBackground.backgroundColor = UIColor.blue

    }
    
    @IBAction func playClicked(_ sender: Any) {
        
        
        currentPet.play()
        updateView()
        
        
        
    }
    
    @IBAction func feedClicked(_ sender: UIButton) {
        currentPet.eat()
        updateView()
        
    }
    
   func updateView() {
        
        happyLabel.text = String(currentPet.happiness)
        
        let happyViewValue = Double(currentPet.happiness)/10
        happyView.animateValue(to: CGFloat(happyViewValue))
        
        
        foodLabel.text = String (currentPet.food)
        let foodViewValue = Double(currentPet.food)/10
        foodView.animateValue(to: CGFloat(foodViewValue))
        
        
    }
    
    @IBAction func screenShot(_ sender: Any) {
        
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        let alertController = UIAlertController(title: "photo", message:
            "saved ", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Go back to pets", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    
    
}

