//
//  DownloadJokesViewController.swift
//  ChuckNorrisJokes
//
//  Created by Razumov Pavel on 31.07.2025.
//

import UIKit

enum State {
    case all
    case single
}

final class DownloadJokesViewController: UIViewController {
    
    private var jokes: [JokeObject]
    private let tableView = UITableView()
    private var state: State
    private var category: JokeCategoryObject?
    
    init(jokes: [JokeObject], state: State, category: JokeCategoryObject?) {
        self.jokes = jokes
        self.state = state
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if state == .all {
            jokes = StorageService.shared.getDownloadJokes()
            tableView.reloadData()
        }
    }
}

extension DownloadJokesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let joke = jokes[indexPath.row]
        var config = UIListContentConfiguration.cell()
        config.text = joke.value
        config.secondaryText = DateFormatter.localizedString(
            from: joke.createdAt,
            dateStyle: .medium,
            timeStyle: .short
        )
        cell.contentConfiguration = config
        return cell
    }
}
