//
//  DetailViewController.swift
//  Comments
//
//  Created by Yogesh Padekar on 02/10/20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet private var postIdLabel: UILabel!
    @IBOutlet private var commentIdLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var bodyLabel: UILabel!
    
    var detailItem: CommentViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureView()
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let commentViewModel = detailItem {
            self.postIdLabel.text = CommentDetailConstants.PostId + commentViewModel.postId
            self.commentIdLabel.text = CommentDetailConstants.CommentId + commentViewModel.id
            self.emailLabel.text = CommentDetailConstants.Email + commentViewModel.email
            self.titleLabel.text = CommentDetailConstants.Title + commentViewModel.title
            self.bodyLabel.text = CommentDetailConstants.Body + commentViewModel.body
        }
    }

}

