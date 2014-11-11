//
//  BeerViewController.swift
//  HearsayMeals
//
//  Created by Mel Ludowise on 11/8/14.
//  Copyright (c) 2014 Mel Ludowise. All rights reserved.
//

import UIKit

private let kCellIdentifier = "BeerRequestTableCell"
private let kSectionHeaderIdentifier = "BeerRequestSectionHeader"
private let kSectionFooterIdentifier = "BeerRequestSectionFooter"

var emptyKegReports : [String] = []

class BeerViewController: UITableViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerSubView: UIView!
    
    @IBOutlet weak var kickedView: UIView!
    @IBOutlet weak var emptyKegReportsLabel: UILabel!
    
    @IBOutlet weak var currentKegLabel: UILabel!
    
    @IBOutlet weak var reportEmptyButton: UIButton!
    @IBOutlet weak var reportEmptyActivityIndicator: UIActivityIndicatorView!
    
    private var beerRequests = [PFObject]()
    private var beerVotes = [String: [PFObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportEmptyButton.selected = find(emptyKegReports, PFUser.currentUser().email) != nil
        
        kickedView.hidden = true
        headerSubView.frame.origin.y -= kickedView.frame.height
        headerView.frame.size.height -= kickedView.frame.height
        tableView.tableHeaderView = headerView
        
        updateKegReport()
        updateBeerRequests()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerRequests.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as RequestTableViewCell
        cell.beerRequest = beerRequests[indexPath.row]
        cell.loadView()
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCellWithIdentifier(kSectionHeaderIdentifier) as UITableViewCell
    }
    
    @IBAction func onMakeRequest(sender: AnyObject) {
        var noteViewController = storyboard?.instantiateViewControllerWithIdentifier(kNoteViewControllerID) as NoteViewController
        noteViewController.title = "Request Beer"
        noteViewController.onDone = { (text: String) -> Void in
//            kegRequests.append(name: text, requests: [PFUser.currentUser().email])
            self.tableView.reloadData()
        }
        presentViewController(noteViewController, animated: true, completion: nil)
    }
    
    @IBAction func onReportEmpty(sender: AnyObject) {
        reportEmptyActivityIndicator.startAnimating()
        reportEmptyButton.setTitle(reportEmptyButton.currentTitle, forState: UIControlState.Disabled)
        reportEmptyButton.enabled = false
        delay(1, { () -> () in
            self.reportEmptyActivityIndicator.stopAnimating()
            self.reportEmptyButton.enabled = true
            self.reportEmptyButton.selected = !self.reportEmptyButton.selected
            
            var index = find(emptyKegReports, PFUser.currentUser().email)
            if (index != nil) {
                emptyKegReports.removeAtIndex(index!)
            } else {
                emptyKegReports.append(PFUser.currentUser().email)
            }
            
            self.updateKegReport()
        })
    }
    
    private func updateBeerRequests() {
        var beerRequestQuery = PFQuery(className: kBeerRequestTableKey)
        beerRequestQuery.whereKey(kBeerRequestInactiveKey, notEqualTo: true)
        beerRequestQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error != nil) {
                NSLog("%@", error)
            } else {
                self.beerRequests = objects as [PFObject]!
                self.tableView.reloadData()
                
//                var queries : [PFQuery] = []
//                for beerRequest in self.beerRequests {
//                    self.beerVotes[beerRequest.objectId] = [PFObject]()
//                    var query = PFQuery(className: kBeerVotesTableKey)
//                    var s : String = beerRequest.objectId
//                    query.whereKey(kBeerVotesBeerKey, equalTo: beerRequest.objectId)
//                    queries.append(query)
//                }
//                var query = PFQuery.orQueryWithSubqueries(queries)
//                query.findObjectsInBackgroundWithBlock({ (results: [AnyObject]!, error: NSError!) -> Void in
//                    if (error != nil) {
//                        NSLog("%@", error)
//                    } else {
//                        var votes = results as [PFObject]
//                        for vote in votes {
//                            self.beerVotes[vote[kBeerVotesBeerKey] as String]?.append(vote)
//                        }
//                    }
//                })
            }
        }
    }
    
    private func updateKegReport() {
        // Scroll to the top of the view
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.tableView.contentOffset.y = -self.tableView.contentInset.top
        })
        
        if (emptyKegReports.count > 0) {
            emptyKegReportsLabel.text = "Reported by \(emptyKegReports.count) people"
            if (kickedView.hidden) {
                kickedView.hidden = false
                UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
                    self.headerSubView.frame.origin.y += self.kickedView.frame.height
                    self.headerView.frame.size.height += self.kickedView.frame.height
                    self.tableView.tableHeaderView = self.headerView
                    }, completion: nil)
            }
        } else if (!kickedView.hidden) {
            UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
                self.headerSubView.frame.origin.y -= self.kickedView.frame.height
                self.headerView.frame.size.height -= self.kickedView.frame.height
                self.tableView.tableHeaderView = self.headerView
                }, completion: { (Bool) -> Void in
                    self.kickedView.hidden = true
            })
        }
    }
    
}