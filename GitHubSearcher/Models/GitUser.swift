//
//  GitUser.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/5/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

class GitUser: Decodable {
    let login: String
    let email: String?
    let location: String?
    let createdAt: String
    let followers: Int?
    let following: Int?
    let bio: String?
    let avatarURL: String
    let numberOfRepos: Int?
    
    private enum CodingKeys: String, CodingKey {
        case login = "login"
        case email = "email"
        case location = "location"
        case followers = "followers"
        case following = "following"
        case createdAt = "created_at"
        case bio = "bio"
        case avatarURL = "avatar_url"
        case numberOfRepos = "public_repos"
    }
}
