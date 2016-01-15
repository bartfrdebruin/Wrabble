//
//  FollowersVC.swift
//  Wrabble
//
//  Created by Marina Huber on 1/15/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FollowersVC: CollectionViewController {
  
    var followersArray : Array<PFObject>?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // SearchBar View.
    override func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.filterContentForSearchText(searchText)
            self.collectionView.reloadData()
            searchBarActive = true
        }else{
            searchBarActive = false
            self.collectionView?.reloadData()
        }
    }

    // Collection View.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
     override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
