import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate   {
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
//        print("Я нажата: ДА")
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
//        print("Я нажата: НЕТ")
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
      // здесь мы заполняем нашу картинку, текст и счётчик данными
    }

    private func show(quiz result: QuizResultsViewModel) {
//        let action = {
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0
//            self.questionFactory?.requestNextQuestion()
//        }
        
        let action =  {
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.imageView.layer.borderWidth = 0
            self.questionFactory?.requestNextQuestion()
            }
        
      // здесь мы показываем результат прохождения квиза
        let alert: AlertPresenter = AlertPresenter(title: result.title, message: result.text,
                                                   buttonText: result.buttonText, completion: action)
        alert.show(viewController: self)
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
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
      }
    
    private func showAnswerResult(isCorrect: Bool) {
        correctAnswers += isCorrect ? 1 : 0
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
            self.makeButtonsActive()
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
                    "Поздравляем, Вы ответили на 10 из 10!" :
                    "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            self.show(quiz: QuizResultsViewModel(title: "Результаты", text: text, buttonText: "Сыграть еще раз"))
      } else {
        currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
          
        // показать следующий вопрос
          self.questionFactory?.requestNextQuestion()
      }
    }
    

    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "inception.json"
        documentsURL.appendPathComponent(fileName)
        let jsonString = try? String(contentsOf: documentsURL)
        print(jsonString ?? "Нет данных")
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
