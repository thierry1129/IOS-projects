//
//  pet.swift
//  firstPet
//
//  Created by Terry Lyu on 2/4/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import Foundation
import UIKit
class Pet{
    
    
    
   private(set) var happiness:Int
    private (set) var food:Int
    var name:String?
    
    
    
    
    func play(){
        food -= 1
        
        
        happiness += 1
        if (food<0){
            food = 0
            
           
            
            

        }
        if (happiness > 10 ){
            happiness = 10
        }
    
    }
    func eat(){
       food += 1
        
        
        if (food > 10){
            food = 10
        }
    }
    func starve(){
        food -= 1
        if (food < 0){
            food = 0
        }

    }
    static func ==(lhs: Pet, rhs: Pet) -> Bool {
        return lhs.name == rhs.name
    }
    
    func  checkDead1() -> Bool{
        if (food <= 0)
        {
          
            return true
            
        }
        else {return false}
        
        
    }
    
    
    
    func revive(){
       food+=1
        
        
        
        
    }
    init(name:String){
         self.name = name
        food = 5
        happiness = 5
        
    
    }
    
    
    
}
