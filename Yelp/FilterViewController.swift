//
//  FilterViewController.swift
//  Yelp
//
//  Created by Lam Do on 11/21/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    optional func filerViewController( filterViewController: FilterViewController, didUpdateFile filters: [String:AnyObject])
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchTableViewCellDelegate {
    weak var delegate : FilterViewControllerDelegate?
    var categories :[[String:String]]!
    var switchStates = [Int:Bool]()
    var dealState = false
    var distanceState = 40000
    var sortState = 0
    
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var dealSwitch: UISwitch!
    @IBOutlet weak var distanceSegment: UISegmentedControl!
    @IBOutlet weak var sortSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.dataSource = self
        filterTableView.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if var _ = defaults.stringForKey("distanceIndex") {
            distanceSegment.selectedSegmentIndex = defaults.integerForKey("distanceIndex")
        } else {
            distanceSegment.selectedSegmentIndex = 2
            defaults.setInteger(distanceSegment.selectedSegmentIndex, forKey: "distanceIndex")
        }
        
        if var _ = defaults.stringForKey("sortIndex") {
            sortSegment.selectedSegmentIndex = defaults.integerForKey("sortIndex")
        } else {
            sortSegment.selectedSegmentIndex = sortState
            defaults.setInteger(sortSegment.selectedSegmentIndex, forKey: "sortIndex")
        }
        
        if var _ = defaults.stringForKey("dealIndex") {
            dealSwitch.on = defaults.boolForKey("dealIndex")
        } else {
            dealSwitch.on = dealState
            defaults.setBool(dealSwitch.on, forKey: "dealIndex")
        }
        
        categories = makeCategoriesDict()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil )
    }

    @IBAction func onsearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil )
        
        var filters = [String:AnyObject]()
        var selectedCategories = [String]()
        
        for (row,isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        filters["deal_state"] = self.dealState
        filters["sort_state"] = self.sortState
        filters["distance_state"] = self.distanceState
        
        delegate?.filerViewController?(self, didUpdateFile: filters)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories != nil {
            return categories.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell" , forIndexPath: indexPath ) as! SwitchTableViewCell
        cell.categoryFilterLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        cell.categorySwitch.on = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func switchTableViewCell(switchTableViewCell: SwitchTableViewCell, didchangeValue value: Bool) {
        let indexPath = filterTableView.indexPathForCell(switchTableViewCell)!
        switchStates[indexPath.row] = value
    }

    func makeCategoriesDict() -> [[String:String]] {
        return [["name":"Thai Food", "code":"thai"],
            ["name":"Sea Food", "code":"seafood"],
            ["name":"Salad", "code":"salad"],
            ["name":"Beer, Wine & Spirits", "code":"beer_and_wine"],
            ["name":"Tea", "code":"tea"],
            ["name":"Coffee", "code":"coffee"],
            ["name":"Food Delivery Services", "code":"fooddeliveryservices"],
            ["name":"Street Vendor", "code":"streetvendors"],
            ["name":"Juice & Smoothies", "code":"juicebars"]]
    }
    
    @IBAction func onDealSwitchChange(sender: UISwitch) {
        self.dealState = dealSwitch.on
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(dealSwitch.on, forKey: "dealIndex")
    }
    
    @IBAction func onDistanceChange(sender: AnyObject) {
        if distanceSegment.selectedSegmentIndex == 0 {
            self.distanceState = 1609
        } else if distanceSegment.selectedSegmentIndex == 1 {
            self.distanceState = 8045
        } else {
            self.distanceState = 40000
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(distanceSegment.selectedSegmentIndex, forKey: "distanceIndex")
    }
  
    @IBAction func onSortChange(sender: AnyObject) {
        self.sortState = sortSegment.selectedSegmentIndex
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(sortSegment.selectedSegmentIndex, forKey: "sortIndex")
    }
}
