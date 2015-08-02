//
//  SearchViewController.swift
//  Camping
//
//  Created by okchuri on 2015. 8. 2..
//  Copyright (c) 2015년 okchuri. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData = []
    var filteredTableData = [String]()
    var tmpTableData = [String]()
    var resultSearchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        getRegionJSON("http://192.168.15.9:9999/search")
        
        
        //        // Reload the table
        //        self.tableView.reloadData()
    }
    
    func getRegionJSON(serverURL: String) {
        let mySession = NSURLSession.sharedSession()
        let url: NSURL = NSURL(string: serverURL)!
        let task = mySession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            var err: NSError?
            var theJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSMutableDictionary
            let results: NSArray = theJSON["data"] as! NSArray
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData = results
                self.tableView.reloadData()
            })
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            if (self.tableData.count != 0) {
                for var i=0; i<self.tableData.count; i++ {
                    let entry: NSMutableDictionary = tableData[i] as! NSMutableDictionary
                    self.tmpTableData += [ (entry["index"] as! String) + ". " + (entry["title"] as! String) ]
                }
            }
            return self.tableData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        if (self.resultSearchController.active) {
            cell.textLabel!.text = self.filteredTableData[indexPath.row]
        } else {
            let entry: NSMutableDictionary = tableData[indexPath.row] as! NSMutableDictionary
            //            self.tmpTableData += [(entry["index"] as! String) + ". " + (entry["title"] as! String)]
            //            cell.textLabel!.text = self.tmpTableData[indexPath.row]
            cell.textLabel!.text = (entry["index"] as! String) + ". " + (entry["title"] as! String)
        }
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredTableData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        let array = (tmpTableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [String]
        self.tableView.reloadData()
    }
    
    
    
}