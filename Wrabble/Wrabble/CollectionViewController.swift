//
//  CollectionViewController.swift
//  Wrabble
//
//  Created by Bart de Bruin on 09-01-16.
//  Copyright © 2016 Wrabble. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    var searchBarActive:Bool = false


    var users : Array<PFObject>?
    var filtered : Array<PFObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "Cell")
        searchBar.delegate = self
        getUsers()
        self.navigationController?.navigationBarHidden = false
    }
    
    func getUsers() {
        let query = PFUser.query()
        query!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            self.users = objects
            self.collectionView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText:String){
        self.filtered = self.users?.filter({ (ob:PFObject) -> Bool in
            let us = ob["username"]
            return us.containsString(searchText)
        })
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.filterContentForSearchText(searchText)
            searchBarActive = true
            self.collectionView?.reloadData()
        }else{
            searchBarActive = false
            self.collectionView?.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBarActive = false
        self.searchBar!.setShowsCancelButton(false, animated: false)
    }
    func cancelSearching(){
        self.searchBarActive = false
        self.searchBar!.resignFirstResponder()
        self.searchBar!.text = ""
    }
    
    
    // Collection View.
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchBarActive {
            return self.filtered!.count;
        } else {
            if users == nil {
                return 0
            } else {
                return self.users!.count
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        let file = self.users![indexPath.row]["image"] as! PFFile
        cell.image.file = file
        cell.image.layer.cornerRadius = cell.image.frame.size.width/2
        cell.image.loadInBackground()
        cell.label.text = self.users![indexPath.row]["username"] as? String
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    
    
    
    
    
    
}


