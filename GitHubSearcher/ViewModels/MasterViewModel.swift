//
//  MasterViewModel.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/6/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

class MasterViewModel: BaseViewModel {
    
    init(view: BindingView) {
        super.init()
        self.view = view
    }
    
    public var currentRow: Int = 0
    
    //Binding variables
    
    public var placeholderText: String {
        return "Search for Users"
    }
    
    public var numberOfRows: Int {
        get {
            return self.searchResult?.items.count ?? 0
        }
    }
    
    public var numberOfRepos: String {
        get {
            return "Repos: \(self.searchResult?.items[currentRow].user?.numberOfRepos ?? 0)"
        }
    }
    
    public var username: String {
        get {
            return self.searchResult?.items[currentRow].login ?? ""
        }
    }
    
    //Data model
    private var searchResult: GitUserSearchResult? {
        didSet {
            self.totalUsers = self.searchResult?.total_count ?? 0
            print("Total GitHub users found: \(self.totalUsers)")
        }
    }
    
    //Other private variables
    public var totalUsers: Int = 0
    
    private var currentPage: Int = 1
    
    private var isFetchInProgress: Bool = false
    
    private var searchText: String = ""
    
    private let group = DispatchGroup()
    
    //Functions
    public func performSearch(searchText: String = "") {
        
        if searchText != self.searchText && searchText.count > 0 {
            self.searchResult = nil
            self.totalUsers = 0
            self.currentPage = 1
            isFetchInProgress = false
        }
        
        if searchText.count > 0 {
            self.searchText = searchText
        }
        
        guard !isFetchInProgress else {
          return
        }
        
        isFetchInProgress = true
        
        self.performSearch(searchText: self.searchText, completionHandler: { result, _, _ in
            DispatchQueue.main.async {
                
                self.isFetchInProgress = false
                
                
                if self.currentPage == 1 {
                    self.searchResult = result
                    self.view?.refresh(type: .table(indexPathsToReload: []))
                } else {
                    self.searchResult?.items += result?.items ?? []
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: result?.items ?? [])
                    self.view?.refresh(type: .table(indexPathsToReload: indexPathsToReload))
                    
                }
                self.getUserInfoForSearchItems()
                self.currentPage += 1
            }
        })
    }
    
    private func getUserInfoForSearchItems() {
        guard let count = self.searchResult?.items.count, count > 0 else {
            return
        }
        let startingIndex = (self.currentPage - 1) * 30
        for i in (startingIndex...count-1) {
            self.group.enter()
            self.getUserInfoForSearchItem(itemIndex: i, completionHandler: { [weak self] result, _, _ in
                DispatchQueue.main.async {
                    self?.searchResult?.items[i].user = result
                    self?.group.leave()
                }
            })
        }
        self.group.notify(queue: .main) {
            [weak self] in
            if self?.currentPage == 1 {
                self?.view?.refresh(type: .table(indexPathsToReload: []))
            } else {
                let indexPathsToReload = (startingIndex..<count-1).map { IndexPath(row: $0, section: 0) }
                self?.view?.refresh(type: .table(indexPathsToReload: indexPathsToReload))
            }
        }
    }
    
    public func getAvatarImageData(completionHandler: @escaping (Data?)->Void) {
        if self.searchResult?.items.count ?? 0 > 0 {
            if let imageURL = self.searchResult?.items[self.currentRow].avatarURL  {
                ImageCacheRepository.shared.getImageForURL(url: imageURL) { data in
                    completionHandler(data)
                }
            }
        }
    }
    
    public func gitUserFor(row: Int) -> GitUser? {
        return self.searchResult?.items[row].user
    }
    
    private func performSearch(searchText: String, completionHandler: @escaping APIManagerCompletionHandler<GitUserSearchResult>) {
        APIManager.shared.request(type: .searchUsers(searchText: searchText, page: self.currentPage), completionHandler: completionHandler)
    }
    
    private func getUserInfoForSearchItem(itemIndex: Int, completionHandler: @escaping APIManagerCompletionHandler<GitUser>) {
        APIManager.shared.request(type: .getUser(loginID: self.searchResult?.items[itemIndex].login ?? ""), completionHandler: completionHandler)
    }
}

extension MasterViewModel {
    private func calculateIndexPathsToReload(from newUserSearchItems: [GitUserSearchItem]) -> [IndexPath] {
        let startIndex = (self.searchResult?.items.count ?? 0) - newUserSearchItems.count
        let endIndex = startIndex + newUserSearchItems.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
