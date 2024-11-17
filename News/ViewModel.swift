//
//  ViewModel.swift
//  News
//
//  Created by Александр Белый on 15.11.2024.
//

import Foundation
import Combine

class ViewModel {
    @Published var articles: [Article] = []
    @Published var errorMessage: String?
    
    private let networkService = NetworkService()
    private var cancellables = Set<AnyCancellable>()
    
    
    func loadArticles(query: String) {
        let apiKey = "5b379ad7649d4f86b3d85fbbf886e336"
        
        networkService.fetchArticles(query: query, apiKey: apiKey)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] articles in
                self?.articles = articles
            })
            .store(in: &cancellables)
    }
}
