import UIKit

final class MovieQuizViewController: UIViewController   {
    private var presenter: MovieQuizPresenter!
    
    //MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    //MARK: - Outlets
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
    
    func makeButtonsActive() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        yesButton.setTitleColor(UIColor.black, for: .normal)
        noButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    func highlightImageBorder(isCorrectAnswer:Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        makeButtonsInactive()
    }
    
    func turnOffHighlighting() {
        imageView.layer.borderWidth = 0
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
    

    // MARK: - Screen
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
}

