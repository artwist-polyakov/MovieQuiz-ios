//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр Поляков on 12.04.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let statisticService: StatisticService!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private let alertPresenter = AlertPresenter()
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegete
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion() 
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didFailToLoadImage() {
        let model = AlertModel(title: "Ошибка", message:  "Картинка не загружена", buttonText: "Попробовать еще раз") {[weak self] in
            guard let self = self else { return }
            self.questionFactory?.requestNextQuestion()
            
        }
        self.viewController?.showAlert(model: model)
//
//
//        let alert = UIAlertController(title: "Ошибка",
//                                        message: "Картинка не загружена",
//                                      preferredStyle: .alert)
//        let action = UIAlertAction(title: "Попробовать еще раз",
//                                   style: .default) {[weak self] _ in
//            guard let self = self else { return }
//            self.questionFactory?.requestNextQuestion()
//        }
        
//        let alert: AlertPresenter = AlertPresenter(title: "Ошибка", message: "Картинка не загружена",
//                                                   buttonText: "Попробовать ещё раз") {[weak self] in
//            self?.questionFactory?.requestNextQuestion()
//        }
//        alert.show(viewController: viewController! as! UIViewController)
    }
    
    func showLoadingIndicator() {
        viewController?.activityIndicator.isHidden = false
    }
    
    func hideLoadingIndicator() {
        viewController?.activityIndicator.isHidden = true
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
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // В Presenter вместо того, чтобы открыть доступ к свойству
    // currentQuestionIndex (то есть заменить private на internal),
    // мы добавили методы isLastQuestion(), resetGame() и
    // switchToNextQuestion().
    // Зачем? Чтобы абстрагировать ViewController от конкретных деталей реализации.
    

    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func didAnswer(isYes:Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func yesButtonClicked() {
//        print("Я нажата: ДА")
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
//        print("Я нажата: НЕТ")
        didAnswer(isYes: false)
    }
    
    
    func makeResultsMessage() -> String {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            
            let totalPlaysCountLine = "Количество сыгранных квизов:\(statisticService.gamesCount)"
            let currentGameResultLine = "Ваш результат:\(correctAnswers)/\(questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f%%", 100*statisticService!.totalAccuracy))"
            
            let resultMessage = [
                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")
            
            return resultMessage
        }
    
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            let text = self.makeResultsMessage()
            
            self.show(quiz: QuizResultsViewModel(title: "Результаты", text: text, buttonText: "Сыграть ещё раз"))
      } else {
          self.switchToNextQuestion()
          
          questionFactory?.requestNextQuestion()
          viewController?.turnOffHighlighting()
          viewController?.makeButtonsActive()
      }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
//        let action =  {
//            self.resetGame()
//            self.correctAnswers = 0
//            self.viewController?.imageView.layer.borderWidth = 0
//            self.questionFactory?.requestNextQuestion()
//            self.viewController?.makeButtonsActive()
//            }
        
      // здесь мы показываем результат прохождения квиза
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) {[weak self] in
            guard let self = self else { return }
            self.resetGame()
            self.correctAnswers = 0
            self.viewController?.imageView.layer.borderWidth = 0
            self.questionFactory?.requestNextQuestion()
            self.viewController?.makeButtonsActive()
            
        }
        self.viewController?.showAlert(model: model)
//        let alert = UIAlertController(title: result.title,
//                                      message: result.text,
//                                              preferredStyle: .alert)
//        let action = UIAlertAction(title: result.buttonText,
//                                           style: .default ) {[weak self] _ in
//                    guard let self = self else { return }
//                    self.resetGame()
//                    self.correctAnswers = 0
//                    self.viewController?.imageView.layer.borderWidth = 0
//                    self.questionFactory?.requestNextQuestion()
//                    self.viewController?.makeButtonsActive()
//                        }
        
        
        
        
//        let alert: AlertPresenter = AlertPresenter(title: result.title, message: result.text,
//                                                   buttonText: result.buttonText, completion: action)
//        alert.show(viewController: viewController! as! UIViewController)
    }
    
    
    private func proceedWithAnswer(isCorrect: Bool) {
        correctAnswers += isCorrect ? 1 : 0
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
//            self.imageView.layer.masksToBounds = false
//            self.imageView.layer.borderWidth = 0
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }

    
}
