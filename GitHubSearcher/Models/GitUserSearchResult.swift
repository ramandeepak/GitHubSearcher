//
//  GitUserSearchResult.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/5/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

class GitUserSearchResult: Decodable {
    var total_count: Int
    var items: [GitUserSearchItem]
}

class GitUserSearchItem: Decodable {
    let login: String
    let avatarURL: String
    var user: GitUser?
    
    private enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarURL = "avatar_url"
        case user = "user"
    }
}
