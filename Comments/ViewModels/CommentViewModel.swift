//
//  CommentViewModel.swift
//  Comments
//
//  Created by Yogesh Padekar on 03/10/20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

struct CommentViewModel {
    
    private var comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    var title: String {
        return self.comment.name ?? ""
    }
    
    var body: String {
        return self.comment.body ?? ""
    }
    
    var id: String {
        return String(self.comment.id)
    }
    
    var postId: String {
        return String(self.comment.postId)
    }
    
    var email: String {
        return self.comment.email ?? ""
    }
}
