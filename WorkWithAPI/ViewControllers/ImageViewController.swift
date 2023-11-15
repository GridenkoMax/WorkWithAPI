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
        networkManager.fetchDog(url: Link.dogsURL.url) { url in
            self.networkManager.fetchImage(from: url) { result in
                switch result {
                case .success(let data):
                    self.dogsImageView.image = UIImage(data: data)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
