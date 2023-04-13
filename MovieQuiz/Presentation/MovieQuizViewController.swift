import UIKit

final class MovieQuizViewController: UIViewController   {
    var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
//        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
//        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        activityIndicator.startAnimating()
        imageView.layer.cornerRadius = 20
        statisticService = StatisticServiceImplementation()
        
    }
    
    // MARK: - UI
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки не скрыт
    }
    
    private func makeButtonsInactive() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        yesButton.setTitleColor(UIColor.ypGray, for: .normal)
        noButton.setTitleColor(UIColor.ypGray, for: .normal)
    }
    
    private func makeButtonsActive() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        yesButton.setTitleColor(UIColor.black, for: .normal)
        noButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    
    // MARK: - Alerts and Errors
    func showNetworkError(message: String) {
        let model = AlertPresenter(title: "Ошибка",
                                   message: message,
                                   buttonText: "Попробовать ещё раз") {[weak self] in
            guard let self = self else { return }
            self.presenter.resetGame()
            self.presenter.correctAnswers = 0
        }
        model.show(viewController: self)
    }
    

    // MARK: - Views
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
      // здесь мы заполняем нашу картинку, текст и счётчик данными
    }

//    private func show(quiz result: QuizResultsViewModel) {
//        let action =  {
//            self.presenter.resetQuestionIndex()
//            self.correctAnswers = 0
//            self.imageView.layer.borderWidth = 0
//            self.questionFactory?.requestNextQuestion()
//            }
//
//      // здесь мы показываем результат прохождения квиза
//        let alert: AlertPresenter = AlertPresenter(title: result.title, message: result.text,
//                                                   buttonText: result.buttonText, completion: action)
//        alert.show(viewController: self)
//    }
//

//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//    }
    
    
    func showAnswerResult(isCorrect: Bool) {
        self.presenter.correctAnswers += isCorrect ? 1 : 0
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        makeButtonsInactive()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
//            self.imageView.layer.masksToBounds = false
//            self.imageView.layer.borderWidth = 0
            guard let self = self else { return }
            self.imageView.layer.borderColor = UIColor.clear.cgColor
//            self.presenter.questionFactory = self.questionFactory
            self.makeButtonsActive()
            self.presenter.showNextQuestionOrResults()
        }
    }
    
//    private func showNextQuestionOrResults() {
//        if presenter.isLastQuestion() {
//            statisticService!.store(correct: correctAnswers, total: presenter.questionsAmount)
//
//            let text = "Ваш результат:\(correctAnswers)/\(presenter.questionsAmount)\nКоличество сыгранных квизов:\(statisticService!.gamesCount)\nРекорд: \(statisticService!.bestGame.correct)/\(statisticService!.bestGame.total) (\(statisticService!.bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f%%", 100*statisticService!.totalAccuracy))"
//
////            let text = StatisticServiceImplementation().store(correct: correctAnswers, total: questionsAmount)
////            correctAnswers == questionsAmount ?
////                    "Поздравляем, Вы ответили на 10 из 10!" :
////                    "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
//            self.show(quiz: QuizResultsViewModel(title: "Результаты", text: text, buttonText: "Сыграть ещё раз"))
//      } else {
//          presenter.switchToNextQuestion() // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
//
//        // показать следующий вопрос
//          self.questionFactory?.requestNextQuestion()
//      }
//    }
    

    
    

    
//    // MARK: - QuestionFactoryDelegate
//    func didRecieveNextQuestion(question: QuizQuestion?) {
//        presenter.didRecieveNextQuestion(question: question)
//    }
//
//    func didLoadDataFromServer() {
//        questionFactory?.requestNextQuestion()
//    }
//
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
//
//    func didFailToLoadImage() {
//        let alert: AlertPresenter = AlertPresenter(title: "Ошибка", message: "Картинка не загружена",
//                                                   buttonText: "Попробовать ещё раз") {[weak self] in
//            self?.questionFactory?.requestNextQuestion()
//        }
//        alert.show(viewController: self)
//    }
    
    
}

