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
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "Cell")
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
    
    override func getUsers() {
        if (users != nil){
            
        } else {
            let user = PFUser.currentUser()
            let array = user!["following"] as? Array<String>
            let query = PFQuery.queryForUser()
            query.whereKey("objectId", containedIn: array!)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                self.users = objects
                self.collectionView.reloadData()
            }
        }
    }

    // Collection View.

    
     override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        if (self.searchBarActive == true)
        {
            let object = self.emptyArray![indexPath.row]
            
            let cell = self.setCell(object, indexPath: indexPath)
            return cell
        } else {
            let object = self.users![indexPath.row]
            self.setCell(object, indexPath: indexPath)
            let cell = self.setCell(object, indexPath: indexPath)
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
