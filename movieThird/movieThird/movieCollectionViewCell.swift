//
//  movieCollectionViewCell.swift
//  movieThird
//
//  Created by Terry Lyu on 2/25/17.
//  Copyright © 2017 Terry Lyu. All rights reserved.
//

import UIKit

class movieCollectionViewCell: UICollectionViewCell {
// each of the cell i display on the initial search screen, should have a poster, and a title 
    
    
    var imageView  : UIImageView!
    var textLabel : UILabel!


    override init(frame:CGRect){
        
        
        
        super.init(frame:frame)
        
        
        
        
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*2/3))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubview(imageView)
        
        textLabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.size.height, width: frame.size.width, height: frame.size.height/3))
        textLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
