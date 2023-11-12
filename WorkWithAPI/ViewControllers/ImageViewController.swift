//
//  ImageViewController.swift
//  WorkWithAPI
//
//  Created by Maxim Gridenko on 12.11.2023.
//

import UIKit
// MARK: - на доработку для следующей домашки

class ImageViewController: UIViewController {

    @IBOutlet weak var dogsImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImageDogs()
    }
    private func fetchImageDogs() {
        URLSession.shared.dataTask(with: Link.dogsURL.url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async { // класс отвечает за работу с потоком, main основное поток
                self.dogsImageView.image = image
            }
            print(response)
        }.resume() // обязательно нужно вызвать что бы сетевой запрос осуществился
    }
}
  


