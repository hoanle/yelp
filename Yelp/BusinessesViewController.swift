//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var businesses: [Business]!
    var switchCountryStates = [Int:Bool]()
    var distance: Int!
    
    @IBOutlet weak var tableView: UITableView!
    var currentCategories: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.searchBar.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                println(business.name!)
                println(business.address!)
            }
             self.tableView.reloadData()
        })
        self.navigationController?.navigationBarHidden = true
        
        let login = FBSDKLoginButton()
        login.center = self.view.center
        login.readPermissions = ["public_profile", "email", "user_friends"]
        
        self.view.addSubview(login)

        login.delegate = self
        
        let share = UIButton(frame: CGRectMake(0, 0, 100, 100))
        share.center.x = 100
        share.center.y = 100
        self.view.addSubview(share)
        share.backgroundColor = UIColor.blueColor()
        share.addTarget(self, action: "share", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func share(){
        let shareContent = FBSDKShareLinkContent()
        shareContent.contentURL = NSURL(string: "http://google.com")
        
        shareContent.contentTitle = "title"
        
        FBSDKShareDialog.showFromViewController(self, withContent: shareContent, delegate: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print(result)
      /*
        let me = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "name, email"])
        me.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            
            print(result)
            
        }
        */
        
        let test = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: nil, HTTPMethod: "GET")
        
        test.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            print(result)
            //Get friend list okie
            
        }

        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if businesses != nil {
            return businesses!.count
        }else{
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject]){
        
        currentCategories = filters["categories"] as? [String]
    
        Business.searchWithTerm("Restaurant", sort: nil, categories: currentCategories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.tableView.reloadData()
        }
    }
    
    func filtersViewControllerUpdateCountryState(filtersViewController: FiltersViewController, row: Int, on: Bool) {
        switchCountryStates[row] = on
    }
    
    func filtersViewControllerUpdateDistanceState(filtersViewController: FiltersViewController, distance: Int) {
       self.distance = distance
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationViewController = segue.destinationViewController as! UINavigationController
        
        let filtersViewController = navigationViewController.topViewController as! FiltersViewController
        filtersViewController.switchCountryStates = self.switchCountryStates
        filtersViewController.distance = self.distance
        filtersViewController.delegate = self
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        var text = searchBar.text
        
        if (text == "") {
            text = "Restaurant"
        }
        
        if (currentCategories != nil){
            Business.searchWithTerm(text, sort: nil, categories: currentCategories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                
                self.tableView.reloadData()
            }
        }else{
            Business.searchWithTerm(text, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                
                self.tableView.reloadData()
            })
        }
    }
    
}
