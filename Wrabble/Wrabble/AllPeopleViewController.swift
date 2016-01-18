//
//  AllPeopleViewController.swift
//  Wrabble
//
//  Created by Eyolph on 16/01/16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse

class AllPeopleViewController: CollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func getUsers() {
        let query = PFUser.query()!
        query.orderByAscending("username")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            self.users = objects
            self.collectionView.reloadData()
        }
    }
    
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
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

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
    
    
}