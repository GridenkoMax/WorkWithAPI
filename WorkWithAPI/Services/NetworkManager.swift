//
//  NetworkManager.swift
//  WorkWithAPI
//
//  Created by Maxim Gridenko on 14.11.2023.
//

import Foundation
import Alamofire

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
    //  метод по загрузке картинки
    //метод загружает данные по предоставленному URL, если загрузка проходит успешно то вызывается completion,в котором приходит либо данные изображения либо ошибка
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
    // метод для выполнения запроса по указанному URL и обработки Json ответа
    //принимает в качестве пораметра URL для выполнения запроса и замыкание completion которое будет вызвано после завершения запроса
    func fetchDog(url: URL, completion: @escaping(URL) -> Void) {
        AF.request(url) //метод для создания запроса
            .validate()
            .responseJSON { response in // используем для обработки отета в формате JSON
                switch response.result{ //проверяем результат выполнения запроса
                case .success(let value): // если запрос успешный, мы получаем value который является JSON ответом
                    if let json = value as? [String: Any], // проверяем удалось ли преобразовать наш value в словарь JSON-объекта,
                       let messageString = json["message"] as? String, //если преобразование удалось,мы извлекаем из JSON объекта значение нужного нам поля,в моем случае это message так как там хранится нужный мне адрес картинки
                       let messageURL = URL(string: messageString) { // преобразовываем строку messageString в объект типа URL
                        DispatchQueue.main.async { // в основном потоке потому что работа с UI производится только в нем
                            completion(messageURL) //передаем в замыкание полученный URL
                        }
                    }
                case.failure(let error): // если запрос не удается,выдаем сообщение об ошибке
                    print("\(error)")
                    
                }
            }
    }
}


// метод для загрузки нашей модели
//from url- это url нашего json ,completion - захватывает url адрес
//    func fetchDog(url: URL, completion: @escaping(URL) -> Void) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, let response = response else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//            let jsonDecoder = JSONDecoder()
//
//            do{
//                let dogImageData = try jsonDecoder.decode(Dogs.self, from: data) // распарсили до модели
//                DispatchQueue.main.async {
//                    completion(dogImageData.message)
//                }
//            } catch let error {
//                print(error.localizedDescription)
//            }
//            print(response)
//        }.resume()
