//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Александр Поляков on 14.03.2023.
//

import Foundation
struct AlertModel{
    var title:String
    var message: String
    var buttonText: String
    var completion: (()->())
    
}
