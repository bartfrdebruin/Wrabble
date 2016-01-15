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

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    //let searchController =    (searchResultsController: nil)
    
    var users : Array<PFObject>?
    var emptyArray : Array<PFObject>?
    var searchBarActive:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = UIView(frame: UIScreen.mainScreen().bounds)

        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout:layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar = UISearchBar(frame: CGRectMake(0,100,self.view.frame.size.width, 50))
        searchBar.delegate = self
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        getUsers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false
        self.view.addSubview(collectionView)
        self.view.addSubview(searchBar)

    }
    
    func getUsers() {
        let query = PFUser.query()
        query!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            self.users = objects
            self.collectionView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText:String){
        self.emptyArray = self.users?.filter({ (ob:PFObject) -> Bool in
            let us = ob["username"]
            return us.containsString(searchText)
        })
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.filterContentForSearchText(searchText)
            self.collectionView.reloadData()
            searchBarActive = true
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
            return self.emptyArray!.count;
        } else {
            if users == nil {
                return 0
            } else {
                return self.users!.count
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(90, 100)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // for SearchBar array
        
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
    
    func setCell(object: PFObject, indexPath : NSIndexPath) -> CollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        let file = object["image"] as! PFFile
        cell.image.file = file
        cell.image.layer.cornerRadius = cell.image.frame.size.width/2
        cell.image.clipsToBounds = true
        cell.image.loadInBackground()
        cell.label.text = object["username"] as? String
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let userPeople = self.users![indexPath.row]
        let people = PeopleViewController()
        people.userPeople = userPeople
        self.navigationController?.pushViewController(people, animated: true)
    }
    
    
}


