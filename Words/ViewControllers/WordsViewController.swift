//
//  ViewController.swift
//  Words
//
//  Created by Айдар Оспанов on 28.03.2023.
//

import UIKit

final class WordsViewController: UITableViewController {
    
    private var words: [Word] = []
    private let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        setupNavigationBar()
        fetchWords()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        let word = words[indexPath.row]
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
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
