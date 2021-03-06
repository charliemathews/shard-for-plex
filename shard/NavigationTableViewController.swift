/*
 Shard by Charlie Mathews & Sarah Burgess
 This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License
 */

//https://github.com/John-Lluch/SWRevealViewController
//http://www.appcoda.com/sidebar-menu-swift/

import UIKit

class NavigationTableViewController: UITableViewController, SWRevealViewControllerDelegate {
    
    var current_row = 0
    var current_section = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        loadObservers()
    }
    
    func refresh() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadObservers() {
        servers.addObserver(self, forKeyPath: "foundResults", options: Constants.KVO_Options, context: nil)
        libraries.addObserver(self, forKeyPath: "foundResults", options: Constants.KVO_Options, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        tableView.reloadData()
        
    }
    
    deinit {
        servers.removeObserver(self, forKeyPath: "foundResults", context: nil)
        libraries.removeObserver(self, forKeyPath: "foundResults", context: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return servers.results.count
        } else if section == 1 {
            return libraries.results.count
        } else if section == 2 {
            return 2 // feedback, logout
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        current_row = indexPath.row
        current_section = indexPath.section
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            servers.selectedServer = indexPath.row
        } else if indexPath.section == 1 {
            libraries.selectedLibrary = indexPath.row
            //media.get(servers.selectedServer, library: indexPath.row)
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                
                // send feedback email
                let email = "charlie@charliemathews.com"
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.sharedApplication().openURL(url!)
                
            } else if indexPath.row == 1 {
                
                // logout
                let ad = UIApplication.sharedApplication().delegate as! AppDelegate
                ad.logout(self.view)
                
            }
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Servers"
        } else if section == 1 {
            return "Libraries"
        } else if section == 2 {
            return ""
        } else {
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            if servers.results.count == 0 {
                return "No servers found."
            } else {
                return ""
            }
        } else if section == 1 {
            if libraries.results.count == 0 {
                return "No libraries found."
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("server", forIndexPath: indexPath) as! ServerCell
            cell.name.text = servers.results[indexPath.row].name
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("library", forIndexPath: indexPath) as! LibraryCell
            cell.name.text = libraries.results[indexPath.row].title
            return cell
            
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("button", forIndexPath: indexPath) as! ButtonCell
            
            if(indexPath.row == 0) {
                cell.name.text = "Report A Bug"
            } else if(indexPath.row == 1) {
                cell.name.text = "Logout"
                cell.name.textColor = UIColor.redColor()
            }
            
            return cell
            
        } else {
            
            return tableView.dequeueReusableCellWithIdentifier("server", forIndexPath: indexPath)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMovieLibrary" {
            
        }
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

}
