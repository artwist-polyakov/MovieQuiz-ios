//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр Поляков on 12.04.2023.
//

import UIKit

final class MovieQuizPresenter{
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    // В Presenter вместо того, чтобы открыть доступ к свойству
    // currentQuestionIndex (то есть заменить private на internal),
    // мы добавили методы isLastQuestion(), resetQuestionIndex() и
    // switchToNextQuestion().
    // Зачем? Чтобы абстрагировать ViewController от конкретных деталей реализации.
    
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func didAnswer(isYes:Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func yesButtonClicked() {
//        print("Я нажата: ДА")
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
//        print("Я нажата: НЕТ")
        didAnswer(isYes: false)
    }
    
}
