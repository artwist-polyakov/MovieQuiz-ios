//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Александр Поляков on 13.04.2023.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {

    func show(quiz step: QuizStepViewModel)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func makeButtonsActive()
    func makeButtonsInactive()
    func highlightImageBorder(isCorrectAnswer:Bool)
    func turnOffHighlighting()
    
    func showAlert(model:AlertModel)
    func showNetworkError(message: String)
    
}
