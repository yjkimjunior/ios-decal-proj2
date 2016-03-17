//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {

    var globalPhrase:[String] = []
    var blanksOfAnswerArray:[String] = []
    
    var wrongGuesses:[String] = []
    var counter = 1
    
    var userGuessText = ""
    
    @IBOutlet var gameView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blanksOfAnswer: UILabel!
    @IBOutlet weak var userGuess: UIPickerView!
    @IBOutlet weak var listOfWrongGuesses: UILabel!
    @IBOutlet weak var guessesRemaining: UILabel!

    
    var wrongAlertController = UIAlertController(
        title: "You Seriously Didn't Know This?!?",
        message: "Gosh",
        preferredStyle: .Alert)
    
    var correctAlertController = UIAlertController(
        title: "Congratulations!",
        message: "Congratulations! Congratulations! Congratulations! Congratulations!",
        preferredStyle: .Alert)
    
    var repeatWrongGuessAlertController = UIAlertController(
        title: "You Already Guessed This",
        message: "You ALREADY Got This Wrong",
        preferredStyle: .Alert)
    
    func isGuessInPhrase(guess: String, phrase: [String]) -> Bool {
        for letter in phrase {
            if letter.lowercaseString == guess.lowercaseString {
                return true
            }
        }
        return false
    }
    
//    func countSpaces(globalPhrase: String) -> Int {
//        var spaces = 0
//        for letter in globalPhrase.characters {
//            if letter == " " {
//                spaces++
//            }
//        }
//        return spaces
//    }
//    

    
    @IBAction func guessButton(sender: AnyObject) {
        if isGuessInPhrase(userGuessText, phrase: globalPhrase) {
            correctGuess()
        } else {
            if userGuessText == "" || userGuessText == " " {
                blanksOfAnswer.text = "Pick a Letter"
            } else {
                var alreadyGuessed = false
                for var i = 0; i < wrongGuesses.count; i++ {
                    if wrongGuesses[i] == userGuessText {
                        self.presentViewController(repeatWrongGuessAlertController, animated: true, completion: nil)
                        alreadyGuessed = true
                        break
                    }
                }
                if alreadyGuessed == false {
                    wrongGuess()
                }
            }
        }
        
        if userGuessText == " " || userGuessText == "" {
            blanksOfAnswer.text = "Pick A Letter"
        }
        
        userGuessText = ""
    }
    
    func correctGuess() {
        var indexToChange = 0
        
        func isComplete() -> Bool {
            for var i = 0; i < globalPhrase.count; i++ {
                if globalPhrase[i] != " " && globalPhrase[i] != "*" {
                    return false
                }
            }
            return true
        }

        for var i = 0; i < globalPhrase.count; i++ {
            if globalPhrase[i].lowercaseString == userGuessText.lowercaseString {
                globalPhrase[i] = "*"
                indexToChange = i
                blanksOfAnswerArray.removeAtIndex(indexToChange)
                blanksOfAnswerArray.insert(userGuessText, atIndex: indexToChange)
            }
        }
        
        if isComplete() == true {
            self.presentViewController(correctAlertController, animated: true, completion: nil)
        }
        
        blanksOfAnswer.text = blanksOfAnswerArray.joinWithSeparator("  ")
        
        print(globalPhrase)
        print(blanksOfAnswerArray)
    }
    
    func wrongGuess() {
        counter++
        if counter <= 7 {
            imageView.image = UIImage(named: "hangman\(counter).gif")
        }
        if counter == 7 {
            blanksOfAnswerArray = globalPhrase
            blanksOfAnswer.text = String(blanksOfAnswerArray)
            self.presentViewController(wrongAlertController, animated: true, completion: nil)
        }
        wrongGuesses.append(userGuessText)
        listOfWrongGuesses.text = String(wrongGuesses)
        guessesRemaining.text = String(Int(guessesRemaining.text!)! - 1)
    }
    
    @IBAction func startOverButton(sender: AnyObject) {
        resetProgress()
    }
    
    func resetProgress() {
        globalPhrase = []
        blanksOfAnswerArray = []
        wrongGuesses = []
        counter = 1
        
        wrongAlertController = UIAlertController(
            title:
            "You Seriously Didn't Know This?!?",
            message: "Gosh",
            preferredStyle: .Alert)
        
        correctAlertController = UIAlertController(
            title: "Congratulations!",
            message: "Congratulations! Congratulations! Congratulations! Congratulations!",
            preferredStyle: .Alert)
        
        repeatWrongGuessAlertController = UIAlertController(
            title: "You Already Guessed This",
            message: "You ALREADY Got This Wrong",
            preferredStyle: .Alert)
        
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        listOfWrongGuesses.text = wrongGuesses.joinWithSeparator(", ")
        guessesRemaining.text = "7"
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        imageView.image = UIImage(named: "hangman1.gif")
        for char in phrase.characters {
            let ch = String(char)
            globalPhrase.append(ch)        }
        for var i = 0; i < phrase.characters.count; i++ {
            if globalPhrase[i] == " " {
                blanksOfAnswerArray.append(" ")
            }
            else {
                blanksOfAnswerArray.append("_")
            }
        }
        blanksOfAnswer.text = blanksOfAnswerArray.joinWithSeparator("  ")
        
        wrongAlertController.addAction(UIAlertAction(title: "New Game", style:
            .Default) { (action) in
                self.resetProgress()
            }
        )
        
        correctAlertController.addAction(UIAlertAction(title: "New Game", style:
            .Default) { (action) in
                self.resetProgress()
            }
        )
        
        repeatWrongGuessAlertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil)
        )

        userGuess.dataSource = self
        userGuess.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let pickerData = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userGuessText = pickerData[row]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
