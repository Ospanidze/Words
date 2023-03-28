//
//  ViewController.swift
//  Words
//
//  Created by Айдар Оспанов on 28.03.2023.
//

import UIKit

final class WordsViewController: UITableViewController {
    
    //MARK: Private Properties
    
    private var words: [Word] = []
    private var filteredWords: [Word] = []
    private let networkManager = NetworkManager.shared
    
    private let searchController = UISearchController(
        searchResultsController: nil
    )
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    //MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        setupNavigationBar()
        setupSearchController()
        fetchWords()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredWords.count : words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        var content = cell.defaultContentConfiguration()
        let word = isFiltering
            ? filteredWords[indexPath.row]
            : words[indexPath.row]
        content.text = word.word
        content.secondaryText = "\(word.score)"
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: Private Methods

extension WordsViewController {
    private func fetchWords() {
        networkManager.fetch(from: Link.wordURL.url) { [weak self] result in
            switch result {
            case .success(let words):
                self?.words = words
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupNavigationBar() {
        title = "Words"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .black
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }
}

// MARK: UISearchResultsUpdating

extension WordsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredWords = words.filter { word in
            word.word.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}
