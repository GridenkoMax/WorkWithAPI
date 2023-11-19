//
//  ImageViewController.swift
//  WorkWithAPI
//
//  Created by Maxim Gridenko on 12.11.2023.
//

import UIKit


final class ImageViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    
    @IBOutlet weak var dogsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImageDogs()
        
    }
    private func fetchImageDogs() {
        //вызываем fetchDog в который передаем ссылку на наш url
      // когда Alamofire успешно преобразует JSON-ответ в словарь, вызываетсяы замыкание completion, которое получает URL, с изображением собаки
        networkManager.fetchDog(url: Link.dogsURL.url) { url in
            self.networkManager.fetchImage(from: url) { result in // метод для загрузки и отображения изображения
                switch result { // в зависимости от результата загрузки,либо устанавливаем в dogsImageView изображение, либо в failure выводим ошибку
                case .success(let data):
                    self.dogsImageView.image = UIImage(data: data)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
