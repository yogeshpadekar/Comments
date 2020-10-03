//
//  MasterViewController.swift
//  Comments
//
//  Created by Yogesh Padekar on 02/10/20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        //Fetch comments
        WebServices.fetchCommentsFromAPIAndSaveInDatabase {
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.delegate = self
            }
        }
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let controller = (segue.destination as? UINavigationController)?.topViewController as? DetailViewController {
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                let comment = self.fetchedResultsController.object(at: indexPath)
                controller.detailItem = CommentViewModel(comment: comment)
                self.detailViewController = controller
                }
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let comment = self.fetchedResultsController.object(at: indexPath)
        self.configureCell(cell, withCommentViewModel: CommentViewModel(comment: comment))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.fetchedResultsController.sections?[section].name ?? ""
    }
    
    func configureCell(_ cell: UITableViewCell, withCommentViewModel commentViewModel: CommentViewModel) {
        cell.textLabel?.text = commentViewModel.title
    }
    
    // MARK: - Fetched results controller
    
    var _fetchedResultsController: NSFetchedResultsController<Comment>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Comment> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Comment> = Comment.fetchRequest()
        
        fetchRequest.fetchBatchSize = 30
        
        //Comments are sorted based on post id
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "postId", ascending: true),
                                        NSSortDescriptor(key: "id", ascending: true)]
        
        //Comments are sectioned as per post id
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: self.managedObjectContext!,
                                                                   sectionNameKeyPath: "postId",
                                                                   cacheName: "CommentsCache")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            print("Unresolved error in fetchedResultsController \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }

}

