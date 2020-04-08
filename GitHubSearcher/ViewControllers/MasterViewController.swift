//
//  MasterViewController.swift
//  GitHubSearcher
//
//  Created by Deepak Raman on 4/5/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    lazy private var viewModel: MasterViewModel? = MasterViewModel(view: self)
    
    private var detailViewController: DetailViewController? = nil
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var selectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchBar()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            let viewModel = DetailViewModel(gitUser: self.viewModel?.gitUserFor(row: self.selectedRow), view: controller)
            controller.viewModel = viewModel
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            detailViewController = controller
        }
    }
}

// SEARCHBAR DELEGATE

extension MasterViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        self.viewModel?.performSearch(searchText: searchText)
    }
}

// TABLEVIEWCONTROLLER OVERRIDES

extension MasterViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.totalUsers ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MasterTableViewCell
        self.viewModel?.currentRow = indexPath.row
        if isLoadingCell(for: indexPath) {
            //empty cell configuration
            cell.numberOfReposLabel.text = "Loading..."
            cell.usernameLabel.text = "Loading..."
            cell.avatarImageView.image = nil
        } else {
            cell.numberOfReposLabel.text = self.viewModel?.numberOfRepos
            cell.usernameLabel.text = self.viewModel?.username
            cell.avatarImageView.image = nil
            self.viewModel?.getAvatarImageData() { data in
                if let imageData = data {
                    cell.avatarImageView.image = UIImage(data: imageData)
                }
            }
        }
        return cell
    }
       
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}

extension MasterViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.viewModel?.performSearch()
        }
    }
}

// BINDINGVIEW DELEGATES

extension MasterViewController: BindingView {
    func refresh(type: ViewType) {
        switch type {
        case .table(let indexPathsToReload):
            if (indexPathsToReload?.count ?? 0) > 0 {
                let indexPathsToReload = visibleIndexPathsToReload(intersecting: indexPathsToReload ?? [])
                self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            } else {
                self.tableView.reloadData()
            }
        default:
            self.tableView.reloadData()
        }
    }
}

// OTHER PRIVATE HELPERS

extension MasterViewController {
    private func setupSearchBar() {
        self.searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = self.viewModel?.placeholderText
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
   private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= (viewModel?.numberOfRows ?? 0)
    }

   private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
