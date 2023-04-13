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
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    
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
    
    func resetGame() {
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
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
        viewController?.hideLoadingIndicator()
    }
    
    
    func showNextQuestionOrResults() {
        let statisticService = self.viewController?.statisticService
        
        if self.isLastQuestion() {
            statisticService!.store(correct: correctAnswers, total: self.questionsAmount)
            
            let text = "Ваш результат:\(correctAnswers)/\(self.questionsAmount)\nКоличество сыгранных квизов:\(statisticService!.gamesCount)\nРекорд: \(statisticService!.bestGame.correct)/\(statisticService!.bestGame.total) (\(statisticService!.bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f%%", 100*statisticService!.totalAccuracy))"
            
//            let text = StatisticServiceImplementation().store(correct: correctAnswers, total: questionsAmount)
//            correctAnswers == questionsAmount ?
//                    "Поздравляем, Вы ответили на 10 из 10!" :
//                    "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            self.show(quiz: QuizResultsViewModel(title: "Результаты", text: text, buttonText: "Сыграть ещё раз"))
      } else {
          self.switchToNextQuestion() // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
          
        // показать следующий вопрос
          questionFactory?.requestNextQuestion()
      }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let action =  {
            self.resetGame()
            self.correctAnswers = 0
            self.viewController?.imageView.layer.borderWidth = 0
            self.questionFactory?.requestNextQuestion()
            }
        
      // здесь мы показываем результат прохождения квиза
        let alert: AlertPresenter = AlertPresenter(title: result.title, message: result.text,
                                                   buttonText: result.buttonText, completion: action)
        alert.show(viewController: viewController!)
    }
    
}
