//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Александр Поляков on 16.03.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}


final class StatisticServiceImplementation: StatisticService {
    func store(correct count: Int, total amount: Int) -> String {
        let oldGamesCount = self.gamesCount
        let newTotalAccuracy:Double = (Double(oldGamesCount*amount)*self.totalAccuracy+Double(count/count))/Double(oldGamesCount+amount/amount)
        let newGamesCount:Int = oldGamesCount+1
        let newBestGame = self.bestGame.compareWithAndStore(correct: count, total: amount)
        userDefaults.set(newTotalAccuracy, forKey: Keys.accuracy.rawValue)
        userDefaults.set(newGamesCount, forKey: Keys.gamesCount.rawValue)
        userDefaults.set(newBestGame, forKey: Keys.bestGame.rawValue)
        val returnString: String = "Ваш результат:\n\(count)/\(amount)\nКоличество сыгранных квизов:  \(newGamesCount)\nРекорд: \(newBestGame.correct)/\(newBestGame.total) (\(newBestGame.date.dateTimeString()))\nСредняя точность: \(NSString(format:"%.2f", newTotalAccuracy)))"
        return returnString
    }
    
    
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, accuracy
    }
    
    var totalAccuracy: Double
        get {
            guard let data = userDefaults.integer(forKey: StringKeys.accuracy.rawValue)
            else {return 0}
            return data
            }
    
    var gamesCount: Int
        get {
            guard let data = userDefaults.integer(forKey: StringKeys.total.rawValue)
            else {return 0}
            return data
            }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
        
    }
    
    
    
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func compareWithAndStore(correct: Int, total: Int, date:Date = Date()) -> GameRecord {
        val newResult = GameRecord(correct: correct, total: total, date: date)
        if self.correct < newResult.correct {
            return newResult
        } else {
            return self
        }
    }
}
