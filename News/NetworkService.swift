//
//  NetworkService.swift
//  News
//
//  Created by Александр Белый on 15.11.2024.
//

import Foundation
import Combine

class NetworkService {
    func fetchArticles(query: String, apiKey: String) -> AnyPublisher<[Article], Error> {
        let urlString = "https://newsapi.org/v2/everything?q=\(query)&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data) // Извлечение данных из ответа
            .decode(type: NewsResponse.self, decoder: JSONDecoder()) // Декодируем JSON
            .map(\.articles) // Извлекаем массив статей
            .receive(on: DispatchQueue.main) // Возвращаем результат на главный поток
            .eraseToAnyPublisher()
    }
}

struct NewsResponse: Decodable {
    let articles: [Article]
}
