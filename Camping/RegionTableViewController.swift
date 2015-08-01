//
//  RegionTableViewController.swift
//  Camping
//
//  Created by okchuri on 2015. 8. 1..
//  Copyright (c) 2015년 okchuri. All rights reserved.
//

import UIKit

class RegionTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    var regionTableData = []

    @IBOutlet weak var RegionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRegionJSON("http://192.168.15.9:9999/list")
    }
    
    func getRegionJSON(serverURL: String) {
        let mySession = NSURLSession.sharedSession()
        let url: NSURL = NSURL(string: serverURL)!
        let task = mySession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            var err: NSError?
            var theJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSMutableDictionary
            let results: NSArray = theJSON["data"] as! NSArray
            dispatch_async(dispatch_get_main_queue(), {
                self.regionTableData = results
                self.RegionTableView.reloadData()
            })
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView,  numberOfRowsInSection section: Int) -> Int {
        return regionTableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "RegionTableCell")
        let regionEntry: NSMutableDictionary = self.regionTableData[indexPath.row] as! NSMutableDictionary
        cell.textLabel!.text = (regionEntry["index"] as! String) + ". " + (regionEntry["title"] as! String)
        return cell
    }
    
    func displayMyAlertMessage(userMessage: String) {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
}
