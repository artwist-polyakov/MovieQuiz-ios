//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Поляков on 14.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func didFailToLoadImage()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
