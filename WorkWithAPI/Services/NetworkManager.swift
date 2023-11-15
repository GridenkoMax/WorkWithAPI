//
//  NetworkManager.swift
//  WorkWithAPI
//
//  Created by Maxim Gridenko on 14.11.2023.
//

import Foundation

enum Link {
    case dogsURL
    
    var url: URL{
        URL(string: "https://dog.ceo/api/breeds/image/random")!
    }
}
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}
final class NetworkManager {
    

    static let shared = NetworkManager()
    private init() {}
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data,NetworkError>) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetchDog(url: URL, completion: @escaping(URL) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let jsonDecoder = JSONDecoder()
            
            do{
                let dogImageData = try jsonDecoder.decode(Dogs.self, from: data)
                DispatchQueue.main.async {
                    completion(dogImageData.message)
                }
            } catch let error {
                print(error.localizedDescription)
            }
            print(response)
        }.resume()
    }
}
