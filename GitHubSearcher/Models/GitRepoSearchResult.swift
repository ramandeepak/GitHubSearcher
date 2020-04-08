//
//  GitRepoSearchResult.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/6/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

class GitRepoSearchResult: Decodable {
    var total_count: Int
    var items: [GitRepository]
}
