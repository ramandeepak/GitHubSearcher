//
//  DetailViewModel.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/5/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

class DetailViewModel: BaseViewModel {
    
    //Binding variables for git user profile
    
    public var username: String {
        get {
            return self.gitUser?.login ?? ""
        }
    }
    
    public var email: String {
        get {
            return self.gitUser?.email ?? ""
        }
    }
    
    public var location: String {
        get {
            return self.gitUser?.location ?? ""
        }
    }
    
    public var createdAt: String {
        get {
            if let date = Date.getUserAccountCreatedDate(dateString: self.gitUser?.createdAt ?? "") {
                return Date.shortDate(date: date) ?? ""
            }
            return ""
        }
    }
    
    public var followers: String {
        get {
            return "\(self.gitUser?.followers ?? 0) Followers"
        }
    }
    
    public var following: String {
        get {
            return "Following \(self.gitUser?.following ?? 0)"
        }
    }
    
    public var biography: String {
        get {
            return self.gitUser?.bio ?? ""
        }
    }
    
    //Helper binding variables
    
    public var currentRow: Int = 0
    
    public var selectedRow: Int = 0 {
        didSet {
            self.selectedRepoURL = self.gitRepos?.items[self.selectedRow].url
        }
    }
    
    public var numberOfRows: Int {
        get {
            return self.gitRepos?.items.count ?? 0
        }
    }
    
    public var selectedRepoURL: String?
    
    
    //Binding variables for repositories table
    
    public var placeholderText: String {
        return "Search for User's Repositories"
    }
    
    public var repoName: String {
        get {
            return self.gitRepos?.items[self.currentRow].name ?? ""
        }
    }
    
    public var numberOfForks: String {
        get {
            let numForks = "\(self.gitRepos?.items[self.currentRow].forks ?? 0)"
            return "\(numForks) Forks"
        }
    }
    
    public var numberOfStars: String {
        get {
            let numStars = "\(self.gitRepos?.items[self.currentRow].stars ?? 0)"
            return "\(numStars) Stars"
        }
    }
    
    // Models
    
    private var gitUser: GitUser?
    
    private var gitRepos: GitRepoSearchResult? {
        didSet {
            self.view?.refresh(type: .table(indexPathsToReload: []))
        }
    }
    
    init(gitUser: GitUser?, view: BindingView?) {
        super.init()
        self.gitUser = gitUser
        self.view = view
    }
    
    public func getAvatarImageData(completionHandler: @escaping (Data?)->Void) {
        if let imageURL = self.gitUser?.avatarURL  {
            ImageCacheRepository.shared.getImageForURL(url: imageURL) { data in
                completionHandler(data)
            }
        }
    }
    
    public func getRepos(searchText: String) {
        self.getRepos(searchText: searchText, completionHandler: { result, _, _ in
            DispatchQueue.main.async {
                self.gitRepos = result
            }
        })
    }
    
    private func getRepos(searchText: String, completionHandler: @escaping APIManagerCompletionHandler<GitRepoSearchResult>) {
        guard let unwrappedLoginID = self.gitUser?.login else {
            return
        }
        APIManager.shared.request(type: .searchRepos(searchText: searchText, loginID: unwrappedLoginID), completionHandler: completionHandler)
    }
}
