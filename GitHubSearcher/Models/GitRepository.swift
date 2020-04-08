//
//  GitRepository.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/6/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

class GitRepository: Decodable {
    let name: String
    let forks: Int
    let stars: Int
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case forks = "forks"
        case stars = "stargazers_count"
        case url = "html_url"
    }
}
