//
//  DetailViewController.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/5/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    @IBOutlet private weak var usernameLabel: UILabel!
    
    @IBOutlet private weak var emailLabel: UILabel!
    
    @IBOutlet private weak var locationLabel: UILabel!
    
    @IBOutlet private weak var createdAtLabel: UILabel!
    
    @IBOutlet private weak var followersLabel: UILabel!
    
    @IBOutlet private weak var followingLabel: UILabel!
    
    @IBOutlet private weak var bioLabel: UILabel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    var viewModel: DetailViewModel? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        self.setUserProfile()
    }
}

extension DetailViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        self.viewModel?.getRepos(searchText: searchText)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRows ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableViewCell
        self.viewModel?.currentRow = indexPath.row
        cell.repoNameLabel.text = self.viewModel?.repoName
        cell.numberOfForksLabel.text = self.viewModel?.numberOfForks
        cell.numberOfStarsLabel.text = self.viewModel?.numberOfStars
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.selectedRow = indexPath.row
        guard let repoURL = self.viewModel?.selectedRepoURL else {
            return
        }
        if let url = URL(string: repoURL) {
            UIApplication.shared.open(url)
        }
    }
}

extension DetailViewController: BindingView {
    func refresh(type: ViewType) {
        switch type {
        case .table:
            self.tableView.reloadData()
        default:
            return
        }
    }
}

extension DetailViewController {
    
    private func setupSearchBar() {
        self.searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = self.viewModel?.placeholderText
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func setUserProfile() {
        self.usernameLabel.text = self.viewModel?.username
        self.emailLabel.text = self.viewModel?.email
        self.locationLabel.text = self.viewModel?.location
        self.createdAtLabel.text = self.viewModel?.createdAt
        self.followersLabel.text = self.viewModel?.followers
        self.followingLabel.text = self.viewModel?.following
        self.bioLabel.text = self.viewModel?.biography
        self.viewModel?.getAvatarImageData() { [weak self] data in
            if let imageData = data {
                self?.avatarImageView.image = UIImage(data: imageData)
            }
        }
    }
}


