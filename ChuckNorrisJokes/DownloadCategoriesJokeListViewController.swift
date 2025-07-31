//
//  DownloadCategoriesJokeListViewController.swift
//  ChuckNorrisJokes
//
//  Created by Razumov Pavel on 30.07.2025.
//

import UIKit

final class DownloadCategoriesJokeListViewController: UIViewController {
    
    private var categories = StorageService.shared.getAllCategories()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categories = StorageService.shared.getAllCategories()
        tableView.reloadData()
    }
}

extension DownloadCategoriesJokeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let category = categories[indexPath.row]
        var config = UIListContentConfiguration.cell()
        config.text = category.name
        cell.contentConfiguration = config
        return cell
    }
}

extension DownloadCategoriesJokeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let vc = DownloadJokesViewController(
            jokes: StorageService.shared.getJokes(from: category),
            state: .single,
            category: category
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}
