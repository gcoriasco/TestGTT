//
//  StopDetailsViewControllerTableViewController.swift
//  TestGTT
//
//  Created by Giovanni Coriasco on 01/11/15.
//  Copyright © 2015 Giovanni Coriasco. All rights reserved.
//

import UIKit

class StopDetailsViewController: UITableViewController {
    var stop: Stop!
    var lines: [LineDepartures]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "loadDepartures", forControlEvents: UIControlEvents.ValueChanged)
        
        if stop != nil {
            navigationItem.title = stop.name
        }
        
        loadDepartures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDepartures() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                if !self.refreshControl!.refreshing {
                    self.refreshControl!.beginRefreshing()
                    self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl!.frame.size.height), animated: true)
                }
            }
            
            if self.stop != nil {
                self.lines = GTT.sharedInstance.departuresForStopId(self.stop.id)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl!.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if stop != nil {
            if let l = lines {
                return l.count + 1
            }
            return 1
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        default:
            return lines[section - 1].departures.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        default:
            return "\(lines[section - 1].name) (\(lines[section - 1].lineType))"
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StopDetail", forIndexPath: indexPath)

        // Configure the cell...
        if cell.contentView.subviews.count == 2 {
            if let title = cell.contentView.subviews[0] as? UILabel {
                if let subtitle = cell.contentView.subviews[1] as? UILabel {
                    if indexPath.section == 0 {
                        title.text = stop.location
                        subtitle.text = stop.placeName
                    } else {
                        title.text = "\(lines[indexPath.section - 1].departures[indexPath.row].time)\(lines[indexPath.section - 1].departures[indexPath.row].rt ? " (RT)" : "")"
                        subtitle.text = lines[indexPath.section - 1].longName
                    }
                }
            }
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
