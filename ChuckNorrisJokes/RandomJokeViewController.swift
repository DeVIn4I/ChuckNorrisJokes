//
//  RandomJokeViewController.swift
//  ChuckNorrisJokes
//
//  Created by Razumov Pavel on 30.07.2025.
//

import UIKit
import SnapKit

final class RandomJokeViewController: UIViewController {
    
    private let networkService = NetworkService.shared
    private let storageService = StorageService.shared
    
    private lazy var jokeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var downloadJokeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download joke", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(didTapDownloadJokeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        [jokeLabel, activityIndicator,
         downloadJokeButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        
        jokeLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        downloadJokeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(46)
            $0.height.equalTo(46)
        }
    }

    
    @objc
    private func didTapDownloadJokeButton() {
        activityIndicator.startAnimating()
        jokeLabel.isHidden = true
        downloadJokeButton.isEnabled = false
        
        Task {
            do {
                let joke = try await networkService.fetchRandomJoke()
                jokeLabel.text = joke.value
                jokeLabel.isHidden = false
                downloadJokeButton.isEnabled = true
                activityIndicator.stopAnimating()
                storageService.saveToRealm(joke)
            } catch {
                print(error)
            }
        }
    }
}
