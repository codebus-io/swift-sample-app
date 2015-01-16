//
//  RecipeTableViewController.swift
//  Sample
//
//  Created by Muneeb Samuels on 2015/01/16.
//  Copyright (c) 2015 Codebus.io (Pty) Ltd. All rights reserved.
//

import UIKit
import CoreData

class RecipeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, RecipeAddDelegate {

    let cellIdentifier = "RecipeCell"
    
    lazy var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
        }()
    
    var fetchedResultsController:NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginRequired:", name: "AuthenticationRequired", object: nil)
        
        fetchedResultsController = getFetchedResultsController()
        
        var error:NSError?
        fetchedResultsController?.performFetch(&error)
        
        if (error != nil) {
            println("Unresolved error: \(error?.userInfo)")
            abort()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var i = UIImage(named: "navbar")
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(i, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        self.navigationController?.navigationBar.topItem?.title = "Recipes"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @objc func loginRequired(notification: NSNotification) {
        performSegueWithIdentifier("loginModal", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController?.sections {
            if sections.count == 0 {
                return 1
            }
            return sections.count
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections {
            println("number of objects: \(sections[section].numberOfObjects)")
            return sections[section].numberOfObjects
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        if let recipe = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Recipe {
            cell.textLabel?.text = recipe.title
        }
        
        return cell
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showRecipe" {
            
        } else if (segue.identifier == "addRecipe") {
            if let viewController:RecipeAddViewController = segue.destinationViewController as? RecipeAddViewController {
                viewController.cdh = self.cdh
                viewController.delegate = self
            }
        }
    }
    
    
    // MARK: RecipeAddDelegate methods
    
    func didAddRecipe(recipe: Recipe) {
        var error:NSError?
        fetchedResultsController?.performFetch(&error)
        
        if (error != nil) {
            println("Unresolved error: \(error?.userInfo)")
            abort()
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate methods
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        if fetchedResultsController == nil {
            let fetchRequest = NSFetchRequest()
            let entity = NSEntityDescription.entityForName("Recipe", inManagedObjectContext: cdh.managedObjectContext!)
            fetchRequest.entity = entity
            
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            let sortDescriptors = NSArray(objects: sortDescriptor)
            
            fetchRequest.sortDescriptors = sortDescriptors
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: cdh.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Root")
            
            fetchedResultsController?.delegate = self
        }
        
        return fetchedResultsController!
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        let tableView = self.tableView
        
        switch (type) {
        case .Delete:
            tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case .Update:
            tableView.deleteRowsAtIndexPaths(NSArray(object:indexPath!), withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths(NSArray(object: newIndexPath!), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        case .Move:
            tableView.deleteRowsAtIndexPaths(NSArray(object: indexPath!), withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths(NSArray(object: newIndexPath!), withRowAnimation: UITableViewRowAnimation.Fade)
            break
        default:
            println("nothing to do here")
            // do nothing
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch (type) {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            println("nothing to do here")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
