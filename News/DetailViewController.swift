//
//  DetailViewController.swift
//  News
//
//  Created by Александр Белый on 16.11.2024.
//
import SnapKit
import UIKit

class DetailViewController: UIViewController {
    var article: Article?
    
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        
        setupScrollView()
        setupConstraintLabel()
        configure(with: article)
    }
    
    private func setupScrollView() {
        scrollView.backgroundColor = .systemMint
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .cyan
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            
            
        ])
        
    }
    
    private func setupConstraintLabel() {
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.textColor = .gray
        dateLabel.font = .boldSystemFont(ofSize: 12)
        dateLabel.numberOfLines = 0
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        authorLabel.textColor = .black
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.numberOfLines = 0
        contentView.addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        descriptionLabel.textColor = .black
        descriptionLabel.font = .boldSystemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            authorLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            authorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            
        ])
        
    }
    
    
    private func configure(with article: Article?) {
        titleLabel.text = article?.title
        dateLabel.text = formatDate(article?.publishedAt)
        authorLabel.text = "Автор: \(article?.author ?? "Неизвестно")"
        descriptionLabel.text = article?.description ?? "Описание отсутствует"
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
}



