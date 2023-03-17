//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Александр Поляков on 16.03.2023.
//

import Foundation
protocol StatisticService {
    func store(correct count: Int, total amount: Int) -> String
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func compareWithAndReturn(correct: Int, total: Int, date:Date = Date()) -> GameRecord {
        
        let newResult = GameRecord(correct: correct, total: total, date: date)
        
        if (self.correct < newResult.correct) {
            return newResult
        } else {
            return self
        }
    }
}

final class StatisticServiceImplementation: StatisticService {
        func store(correct count: Int, total amount: Int) -> String {
        let oldGamesCount = self.gamesCount
        let newTotalAccuracy:Double = (Double(oldGamesCount*amount)*self.totalAccuracy+Double(count))/Double(amount*(oldGamesCount+1))
        let newGamesCount:Int = oldGamesCount+1
        let newBestGame = self.bestGame.compareWithAndReturn(correct: count, total: amount)
        
        userDefaults.set(newTotalAccuracy, forKey: Keys.accuracy.rawValue)
        userDefaults.set(newGamesCount, forKey: Keys.gamesCount.rawValue)
        userDefaults.set(try! JSONEncoder().encode(newBestGame), forKey: Keys.bestGame.rawValue)
        
        let returnString:String = "Ваш результат:\(count)/\(amount)\nКоличество сыгранных квизов:\(newGamesCount)\nРекорд: \(newBestGame.correct)/\(newBestGame.total) (\(newBestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f%%", 100*newTotalAccuracy))"
        
        return returnString
    }
    
    private let userDefaults = UserDefaults.standard
    
     enum Keys: String {
            case correct, total, bestGame, gamesCount, accuracy
        }
    
    var totalAccuracy: Double {
        get {
            print("Получаю текущую точность")
            let value = userDefaults.double(forKey:  Keys.accuracy.rawValue)
            print(value)
            return value
        }
    }
    
    var gamesCount: Int {
        get {
            print("Получаю gamesCount")
            let data = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            print (data)
            return data
        }
    }
    
    var bestGame: GameRecord {
        get {
            print("Получаю рекорды")
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            print(record)
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



