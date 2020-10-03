//
//  Comment.swift
//  Comments
//
//  Created by Yogesh Padekar on 03/10/20.
//  Copyright © 2020 Yogesh. All rights reserved.
//

import CoreData

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

class Comment: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case id, postId, body, email, name
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int16.self, forKey: .id)
        self.postId = try container.decode(Int16.self, forKey: .postId)
        self.body = try container.decode(String.self, forKey: .body)
        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(postId, forKey: .postId)
        try container.encode(body, forKey: .body)
        try container.encode(email, forKey: .email)
        try container.encode(email, forKey: .name)
    }
}
