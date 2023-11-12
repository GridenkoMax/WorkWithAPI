//
//  ViewController.swift
//  WorkWithAPI
//
//  Created by Maxim Gridenko on 11.11.2023.
//

import UIKit


enum Link {
    case dogsURL
    
    var url: URL{
        URL(string: "https://dog.ceo/api/breeds/image/random")!
    }
}
// MARK: - виды ответов алертов
enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    var message: String {
        switch self {
        case .success:
            return "You can see the results in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}

final class ViewController: UIViewController {
    
    // MARK: - создание UIAlertController
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
    }
    @IBAction func dogsButtonAction() {
        fetchDogs()
    }
}
extension ViewController {
    private func fetchDogs() { //ответ от сервера заменим нижним подчеркиванием
        URLSession.shared.dataTask(with: Link.dogsURL.url) { data, _ , error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let jsonDecoder = JSONDecoder()
            do { // декодировка
                let dogs = try jsonDecoder.decode(Dogs.self, from: data)
                print(dogs)
                DispatchQueue.main.async { [unowned self] in
                    self.showAlert(withStatus: .success)
                }
            } catch let error { // отлавливаем возможную ошибку
                print(error.localizedDescription)
                self.showAlert(withStatus: .failed)
            }
        }.resume() // обязательно нужно вызвать что бы сетевой запрос осуществился
    }
}



