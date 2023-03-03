import UIKit

final class MovieQuizViewController: UIViewController {
    
    private struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    // для состояния "Вопрос задан"
    private struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }

    // для состояния "Результат квиза"
    private struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    


    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        print("Я нажата: ДА")
        
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        print("Я нажата: НЕТ")
        
        let currentQuestion = questions[currentQuestionIndex]
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
      // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText,
                                   style: .default) {_ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func makeButtonsInactive() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func makeButtonsActive() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
      }
    
    private func showAnswerResult(isCorrect: Bool) {
        correctAnswers += isCorrect ? 1 : 0
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        makeButtonsInactive()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.imageView.layer.masksToBounds = false
            self.imageView.layer.borderWidth = 0
            self.makeButtonsActive()
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
        // показать результат квиза
          self.show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат: \(self.correctAnswers) из \(self.questions.count)", buttonText: "Сыграть еще раз"))
      } else {
        currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
        // показать следующий вопрос
          let nextQuestion = self.questions[self.currentQuestionIndex]
          let viewModel = self.convert(model: nextQuestion)
          self.show(quiz: viewModel)
      }
    }
    

    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
           Тут имеет смысл наполнить наше view данными.
        */
        show(quiz: convert(model: questions[currentQuestionIndex]))
        
        
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
