//
//  ViewController.swift
//  Hangman
//
//  Created by macbook on 1/8/20.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

extension String {
    func numberOfChar(_ char: Character) -> Int {
        let count = self.count
        var string = self
        var amount = 0
        
        for _ in 1...count {
            let index = string.firstIndex(of: char)
            if let index = index {
                string.remove(at: index)
                amount += 1
            }
        }
        return amount
    }
}

class ViewController: UIViewController {
    
    var letterAnswer: UITextField!
    var wordAnswer: UITextField!
    var guessedLetters = [Character]()
    var guessedWords = [String]()
    var answers = [String]()
    var answersCorrect = [String]()
    var submitLetter: UIButton!
    var clearLetter: UIButton!
    var submitWord: UIButton!
    var clearWord: UIButton!
    var guessedLabel: UILabel!
    var wordLabel: UILabel!
    var headLabel: UILabel!
    var upperBodyLabel: UILabel!
    var leftArmLabel: UILabel!
    var rightArmLabel: UILabel!
    var lowerBodyLabel: UILabel!
    var leftLegLabel: UILabel!
    var rightLegLabel: UILabel!
    var level = 1 {
        didSet {
            levelLabel.text = "LEVEL: \(level)"
        }
    }
    var screenHeight: CGFloat!
    var index = 0
    var currentWord = ""
    var bodyParts = [UILabel]()
    var bodyIndex = 0
    var levelLabel: UILabel!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .darkGray
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textColor = .white
        wordLabel.text = ""
        wordLabel.font = UIFont.systemFont(ofSize: 24)
        wordLabel.sizeToFit()
        wordLabel.textAlignment = .center
        view.addSubview(wordLabel)
        
        letterAnswer = UITextField()
        letterAnswer.translatesAutoresizingMaskIntoConstraints = false
        letterAnswer.text = nil
        letterAnswer.textAlignment = .center
        letterAnswer.font = UIFont.systemFont(ofSize: 30)
        letterAnswer.attributedPlaceholder = NSAttributedString(string: "Guess a letter", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        view.addSubview(letterAnswer)
        
        submitLetter = UIButton(type: .system)
        submitLetter.translatesAutoresizingMaskIntoConstraints = false
        submitLetter.addTarget(self, action: #selector(submittedLetter), for: .touchUpInside)
        submitLetter.setTitle("Submit", for: .normal)
        submitLetter.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        submitLetter.layer.cornerRadius = 15
        submitLetter.layer.borderColor = UIColor.lightGray.cgColor
        submitLetter.layer.borderWidth = 3
        view.addSubview(submitLetter)
        
        clearLetter = UIButton(type: .system)
        clearLetter.translatesAutoresizingMaskIntoConstraints = false
        clearLetter.addTarget(self, action: #selector(clearedLetter), for: .touchUpInside)
        clearLetter.setTitle("Clear", for: .normal)
        clearLetter.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        clearLetter.layer.cornerRadius = 15
        clearLetter.layer.borderColor = UIColor.lightGray.cgColor
        clearLetter.layer.borderWidth = 3
        view.addSubview(clearLetter)
        
        wordAnswer = UITextField()
        wordAnswer.translatesAutoresizingMaskIntoConstraints = false
        wordAnswer.attributedPlaceholder = NSAttributedString(string: "Guess a word", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        wordAnswer.textAlignment = .center
        wordAnswer.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(wordAnswer)
        
        submitWord = UIButton(type: .system)
        submitWord.translatesAutoresizingMaskIntoConstraints = false
        submitWord.addTarget(self, action: #selector(submittedWord), for: .touchUpInside)
        submitWord.setTitle("Submit", for: .normal)
        submitWord.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        submitWord.layer.borderWidth = 3
        submitWord.layer.borderColor = UIColor.lightGray.cgColor
        submitWord.layer.cornerRadius = 15
        view.addSubview(submitWord)
        
        clearWord = UIButton(type: .system)
        clearWord.translatesAutoresizingMaskIntoConstraints = false
        clearWord.addTarget(self, action: #selector(clearedWord), for: .touchUpInside)
        clearWord.setTitle("Clear", for: .normal)
        clearWord.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        clearWord.layer.borderWidth = 3
        clearWord.layer.borderColor = UIColor.lightGray.cgColor
        clearWord.layer.cornerRadius = 15
        view.addSubview(clearWord)
        
        guessedLabel = UILabel()
        guessedLabel.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)
        guessedLabel.translatesAutoresizingMaskIntoConstraints = false
        guessedLabel.text = ""
        guessedLabel.textColor = .white
        guessedLabel.layer.borderWidth = 3
        guessedLabel.layer.borderColor = UIColor.lightGray.cgColor
        guessedLabel.numberOfLines = 0
        view.addSubview(guessedLabel)
        
        headLabel = UILabel()
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        headLabel.text = "O"
        headLabel.textColor = .white
        headLabel.font = UIFont.systemFont(ofSize: 88)
        headLabel.textAlignment = .center
        headLabel.isHidden = true
        view.addSubview(headLabel)
        
        upperBodyLabel = UILabel()
        upperBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        upperBodyLabel.text = "|"
        upperBodyLabel.textColor = .white
        upperBodyLabel.font = UIFont.systemFont(ofSize: 88)
        upperBodyLabel.textAlignment = .center
        upperBodyLabel.isHidden = true
        view.addSubview(upperBodyLabel)
        
        lowerBodyLabel = UILabel()
        lowerBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        lowerBodyLabel.text = "|"
        lowerBodyLabel.textColor = .white
        lowerBodyLabel.font = UIFont.systemFont(ofSize: 88)
        lowerBodyLabel.textAlignment = .center
        lowerBodyLabel.isHidden = true
        view.addSubview(lowerBodyLabel)
        
        rightArmLabel = UILabel()
        rightArmLabel.translatesAutoresizingMaskIntoConstraints = false
        rightArmLabel.text = "/"
        rightArmLabel.textColor = .white
        rightArmLabel.font = UIFont.systemFont(ofSize: 88)
        rightArmLabel.textAlignment = .center
        rightArmLabel.isHidden = true
        view.addSubview(rightArmLabel)
        
        leftArmLabel = UILabel()
        leftArmLabel.translatesAutoresizingMaskIntoConstraints = false
        leftArmLabel.text = "\\"
        leftArmLabel.textColor = .white
        leftArmLabel.font = UIFont.systemFont(ofSize: 88)
        leftArmLabel.textAlignment = .center
        leftArmLabel.isHidden = true
        view.addSubview(leftArmLabel)
        
        rightLegLabel = UILabel()
        rightLegLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLegLabel.text = "\\"
        rightLegLabel.textColor = .white
        rightLegLabel.font = UIFont.systemFont(ofSize: 88)
        rightLegLabel.textAlignment = .center
        rightLegLabel.isHidden = true
        view.addSubview(rightLegLabel)
        
        leftLegLabel = UILabel()
        leftLegLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLegLabel.text = "/"
        leftLegLabel.textColor = .white
        leftLegLabel.font = UIFont.systemFont(ofSize: 88)
        leftLegLabel.textAlignment = .center
        leftLegLabel.isHidden = true
        view.addSubview(leftLegLabel)
        
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "LEVEL: \(level)"
        levelLabel.textColor = .white
        levelLabel.textAlignment = .center
        levelLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(levelLabel)
        
        bodyParts = [headLabel, upperBodyLabel, rightArmLabel, leftArmLabel, lowerBodyLabel, rightLegLabel, leftLegLabel]
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadLevel()
    }
    override func viewDidLayoutSubviews() {
        if view.frame.height >= 667 {
            
            NSLayoutConstraint.activate([
            
                wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                letterAnswer.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 10),
                letterAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                letterAnswer.widthAnchor.constraint(equalToConstant: 250),
                letterAnswer.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.06),
                
                submitLetter.topAnchor.constraint(equalTo: letterAnswer.bottomAnchor, constant: 20),
                submitLetter.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
                submitLetter.widthAnchor.constraint(equalToConstant: 80),
                
                clearLetter.topAnchor.constraint(equalTo: submitLetter.topAnchor),
                clearLetter.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
                clearLetter.widthAnchor.constraint(equalTo: submitLetter.widthAnchor),
                
                wordAnswer.topAnchor.constraint(equalTo: submitLetter.bottomAnchor, constant: 20),
                wordAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                wordAnswer.widthAnchor.constraint(equalTo: letterAnswer.widthAnchor),
                wordAnswer.heightAnchor.constraint(equalTo: letterAnswer.heightAnchor),
                
                submitWord.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
                submitWord.topAnchor.constraint(equalTo: wordAnswer.bottomAnchor, constant: 20),
                submitWord.widthAnchor.constraint(equalToConstant: 80),
                
                clearWord.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
                clearWord.topAnchor.constraint(equalTo: submitWord.topAnchor),
                clearWord.widthAnchor.constraint(equalTo: submitWord.widthAnchor),
                
                guessedLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                guessedLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                guessedLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
                guessedLabel.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.4),
                
                headLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                headLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
                headLabel.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.1),
                headLabel.widthAnchor.constraint(equalToConstant: 65),
                
                upperBodyLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor),
                upperBodyLabel.centerXAnchor.constraint(equalTo: headLabel.centerXAnchor),
                upperBodyLabel.heightAnchor.constraint(equalTo: headLabel.heightAnchor),
                
                lowerBodyLabel.topAnchor.constraint(equalTo: upperBodyLabel.bottomAnchor),
                lowerBodyLabel.centerXAnchor.constraint(equalTo: upperBodyLabel.centerXAnchor),
                lowerBodyLabel.heightAnchor.constraint(equalTo: upperBodyLabel.heightAnchor),
                
                rightArmLabel.leadingAnchor.constraint(equalTo: upperBodyLabel.trailingAnchor),
                rightArmLabel.heightAnchor.constraint(equalTo: upperBodyLabel.heightAnchor),
                rightArmLabel.centerYAnchor.constraint(equalTo: upperBodyLabel.centerYAnchor),
                rightArmLabel.widthAnchor.constraint(equalToConstant: 30),
                
                leftArmLabel.trailingAnchor.constraint(equalTo: upperBodyLabel.leadingAnchor),
                leftArmLabel.centerYAnchor.constraint(equalTo: upperBodyLabel.centerYAnchor),
                leftArmLabel.heightAnchor.constraint(equalTo: upperBodyLabel.heightAnchor),
                
                rightLegLabel.topAnchor.constraint(equalTo: lowerBodyLabel.bottomAnchor),
                rightLegLabel.leadingAnchor.constraint(equalTo: lowerBodyLabel.trailingAnchor),
                rightLegLabel.heightAnchor.constraint(equalTo: lowerBodyLabel.heightAnchor),
                
                leftLegLabel.topAnchor.constraint(equalTo: lowerBodyLabel.bottomAnchor),
                leftLegLabel.trailingAnchor.constraint(equalTo: lowerBodyLabel.leadingAnchor),
                leftLegLabel.heightAnchor.constraint(equalTo: lowerBodyLabel.heightAnchor),
                
                levelLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
                levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                
            ])
        } else {
            
            //Create UI for landscape mode here
            
        }
    }
    
    func loadLevel() {
        
            if let url = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
                if let wordString = try? String(contentsOf: url) {
                    let messedUpAnswers = wordString.components(separatedBy: "\n")
                    let answersCombined = messedUpAnswers.joined()
                    answers = answersCombined.components(separatedBy: "\r")
                }
            }
        
        for label in bodyParts {
            label.isHidden = true
        }
        
        answers.shuffle()
        
        loadWord(nil)
        
    }
    
    func loadWord(_ action: UIAlertAction!) {
        
        view.backgroundColor = .darkGray
        let word = answers.first
        wordLabel.text = ""
        guessedLabel.text = ""
        wordAnswer.text = nil
        letterAnswer.text = nil
        guessedLetters.removeAll()
        guessedWords.removeAll()
        bodyIndex = 0
        
        for label in bodyParts {
            label.isHidden = true
        }
        
        if let word = word {
            currentWord = word
            for _ in 1...word.count {
                wordLabel.text! += "?"
            }
        }
    }
    
    func levelUp(_ action: UIAlertAction!) {
        level += 1
        loadLevel()
    }
    
    func restartLevel(_ action: UIAlertAction!) {
        answers.removeAll()
        guessedLetters.removeAll()
        guessedWords.removeAll()
        guessedLabel.text = ""
        bodyIndex = 0
        currentWord = ""
        letterAnswer.text = ""
        wordAnswer.text = ""
        
        loadLevel()
    }

    
    @objc func submittedLetter(_ sender: UIButton!) {
        guard let count = letterAnswer.text?.count else {return}
        
        if count == 1 {
            let answer = letterAnswer.text?.first?.uppercased()
            if let answer = answer {
                let char = Character(answer)
                if currentWord.contains(char) {
                    guessedLetters.append(char)
                    let count = currentWord.numberOfChar(char)
                    for _ in 0..<count {
                        let indexString = currentWord.firstIndex(of: char)
                        if let indexString = indexString {
                            currentWord.remove(at: indexString)
                            currentWord.insert("?", at: indexString)
                            wordLabel.text?.remove(at: indexString)
                            wordLabel.text?.insert(char, at: indexString)
                        }
                    }
                    letterAnswer.text = nil
                    if answers.first == wordLabel.text {
                        answers.removeFirst()
                        if answers == [] {
                            view.backgroundColor = .green
                            let alert = UIAlertController(title: "Congratulations!", message: "You've completed level \(level)! Move to next level?", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Level up!", style: .default, handler: levelUp))
                            present(alert, animated: true)
                        } else {
                            let alert = UIAlertController(title: "You got it!", message: "Next word" , preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: loadWord))
                            present(alert, animated: true)
                        }
                    }
                } else {
                    let char = Character(answer)
                    letterAnswer.text = nil
                    if guessedLetters.contains(char) {
                        let alert = UIAlertController(title: "Woops!", message: "You've already guessed that letter!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        present(alert, animated: true)
                    } else {
                        guessedLetters.append(char)
                        guessedLabel.text! += " \(answer) "
                        bodyParts[bodyIndex].isHidden = false
                        bodyIndex += 1
                        
                        if bodyIndex == 7 {
                            view.backgroundColor = .red
                            let alert = UIAlertController(title: "Game Over!", message: "You've lost the game! Restart level?", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Restart", style: .cancel, handler: restartLevel))
                            present(alert, animated: true)
                        }
                    }
                }
            }
        } else if count > 1 {
            let alert = UIAlertController(title: "Woops!", message: "Enter a word below!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Woops!", message: "Type in a letter!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }

    
    @objc func clearedLetter(_ sender: UIButton!) {
        letterAnswer.text = nil
    }
    
    @objc func submittedWord(_ sender: UIButton!) {
        guard let text = wordAnswer.text?.uppercased() else {return}
        
        if text.count > 1 {
            if text == answers.first {
                wordLabel.text = text
                answers.removeFirst()
                if answers == [] {
                    view.backgroundColor = .green
                    let alert = UIAlertController(title: "Congratulations!", message: "You've completed level \(level)! Move to next level?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Level up!", style: .default, handler: levelUp))
                    present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "You got it!", message: "Next word" , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: loadWord))
                    present(alert, animated: true)
                }
            } else {
                if guessedWords.contains(text) {
                    let alert = UIAlertController(title: "Woops!", message: "You've already guessed that word!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    present(alert, animated: true)
                } else {
                    guessedWords.append(text)
                    guessedLabel.text! += " \(text) "
                    bodyParts[bodyIndex].isHidden = false
                    bodyIndex += 1
                    wordAnswer.text = nil
                    
                    if bodyIndex == 7 {
                        view.backgroundColor = .red
                        let alert = UIAlertController(title: "Game Over!", message: "You've lost the game! Restart level?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Restart", style: .cancel, handler: restartLevel))
                        present(alert, animated: true)
                    }
                }
            }
        } else if text.count == 1 {
            let alert = UIAlertController(title: "Woops!", message: "Enter a letter above!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Woops!", message: "Type in a word!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    @objc func clearedWord(_ sender: UIButton!) {
        wordAnswer.text = nil
    }

}
