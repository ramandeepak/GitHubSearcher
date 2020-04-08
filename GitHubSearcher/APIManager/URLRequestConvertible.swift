//
//  URLRequestConvertible.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/6/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

struct BaseURL {
    static let url: String = "https://api.github.com"
}

enum ServiceType {
    case searchUsers(searchText: String, page: Int)
    case getUser(loginID: String)
    case searchRepos(searchText: String, loginID: String)
}

protocol URLRequestConvertible {
    var url: String { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
    //var bodyParameters: [String: String]
}
