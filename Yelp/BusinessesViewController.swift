//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar()
    var searchText: String?
    
    var businesses: [Business]!
    var filteredCategories: [String]!
    var categories: [String]?
    var sortState = YelpSortMode.BestMatched
    var dealState = false
    var radiusState = 40000
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight =  120
        
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Restaurants"
  
        Business.searchWithTerm("Restaurants", sort: nil, categories: ["thai", "burgers"], deals: nil, radius: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
             return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell" , forIndexPath: indexPath ) as! BusinessTableViewCell
        cell.business = businesses[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FilterViewController
        filtersViewController.delegate = self
    }
    
    func filerViewController(filterViewController: FilterViewController, didUpdateFile filters: [String : AnyObject]) {
        self.categories = filters["categories"] as? [String]
        //ase BestMatched = 0, Distance, HighestRated
        let sortStateNum = filters["sort_state"] as! Int
        
        if sortStateNum == 1 {
            self.sortState = YelpSortMode.Distance
        } else if sortStateNum == 2 {
            self.sortState = YelpSortMode.HighestRated
        }
        self.dealState = filters["deal_state"] as! Bool
        self.radiusState = filters["distance_state"] as! Int
        Business.searchWithTerm("Restaurants", sort: self.sortState, categories: self.categories, deals: self.dealState, radius: self.radiusState) { (businesses: [Business]!, error: NSError!) -> Void in

            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        Business.searchWithTerm((self.searchText)!, sort: self.sortState, categories: self.categories, deals: self.dealState, radius: self.radiusState) { (businesses: [Business]!, error: NSError!) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
        }

        searchBar.placeholder = self.searchText
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        self.searchText = searchText
    }

}
