//
//  Dogs.swift
//  WorkWithAPI
//
//  Created by Maxim Gridenko on 12.11.2023.
//

import Foundation
//Decodable протокол декодировки, что бы можно было работать в методе decode
struct Dogs: Decodable {
    let message: String?
    let status: String?
}
