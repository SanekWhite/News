//
//  ViewController.swift
//  News
//
//  Created by Александр Белый on 15.11.2024.
//
import UIKit
import Combine

class ViewController: UIViewController {
    
    private let viewModel = ViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var searchTextPublisher = PassthroughSubject<String, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        setupSearchBar()
        setupTableView()
        bindSearchBar()
        // Подписка на обновления статей
        viewModel.$articles
            .receive(on: DispatchQueue.main) // Обновляем UI на главном потоке
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Подписка на ошибки
        viewModel.$errorMessage
            .compactMap { $0 } // Пропускаем nil
            .sink { error in
                print("Ошибка: \(error)")
            }
            .store(in: &cancellables)
        
        // Загрузка статей
        viewModel.loadArticles(query: "apple")
    }
    
    private func setupSearchBar() {
        // Настраиваем UISearchBar
        searchBar.delegate = self
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем UISearchBar на экран
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        
        let article = viewModel.articles[indexPath.row]
        cell.textLabel?.text = article.title
        cell.textLabel?.font = .boldSystemFont(ofSize: 12)
        cell.detailTextLabel?.text = formatDate(article.publishedAt)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.articles[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.article = article
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextPublisher.send(searchText)
    }
    
    private func bindSearchBar() {
        searchTextPublisher
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .filter { $0.count >= 3 }
            .sink { [weak self] query in
                self?.viewModel.loadArticles(query: query)
            }
            .store(in: &cancellables)
    }
}


private func formatDate(_ dateString: String?) -> String {
    guard let dateString = dateString else { return "Неизвестная дата" }
    let formatter = ISO8601DateFormatter()
    if let date = formatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .none
        return outputFormatter.string(from: date)
    }
    return "Неизвестная дата"
}


