//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александр Поляков on 14.03.2023.
//


import UIKit
final class AlertPresenter {
    
    
    func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) {_ in
            model.completion()
        }
        
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
    
//
//    init(title: String, message:String,buttonText:String,completion: @escaping (()->())) {
//
//        self.alert = AlertModel (title: title, message: message,buttonText: buttonText, completion: completion)
//    }
//
//    func show(viewController:UIViewController){
//        let alert = UIAlertController(title: self.alert.title,
//                                      message: self.alert.message,
//                                      preferredStyle: .alert)
//        let action = UIAlertAction(title: self.alert.buttonText,
//                                   style: .default) {  _ in
////            guard let self=self else {return}
//            self.alert.completion()
//        }
//        alert.addAction(action)
//        viewController.present(alert, animated: true, completion: nil)
//    }
}
