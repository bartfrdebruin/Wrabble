//
//  CollectionViewController.swift
//  Wrabble
//
//  Created by Bart de Bruin on 09-01-16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Properties.
    var collectionView: UICollectionView!

    // View did load.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Screensize. 
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
//        let height = bounds.size.height

        let textFieldFrame = CGRectMake(10, 20, width - 20, 40)
        
        // Searchfield. 
        let searchField = UITextField(frame: textFieldFrame)
        searchField.backgroundColor = UIColor.whiteColor()
        searchField.borderStyle = .RoundedRect
        
        
        // Setting up the collectionView. 
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.purpleColor()
        
        // Setting up the view.
 
        
        self.view.addSubview(collectionView)
        self.view.addSubview(searchField)

        
        
        
    }
    
    
    
    
    
    
    // Collection View.
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }
}
