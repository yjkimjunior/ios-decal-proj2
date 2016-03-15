//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var globalPhrase:[String] = []
    var blanksOfAnswerArray:[String] = []
    
    var wrongGuesses:[String] = []
    var counter = 1
    
    @IBOutlet var gameView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blanksOfAnswer: UILabel!
    @IBOutlet weak var userGuess: UITextField!
    
    @IBOutlet weak var listOfWrongGuesses: UILabel!
    
    func isGuessInPhrase(guess: String, phrase: [String]) -> Bool {
        for letter in phrase {
            if letter.lowercaseString == guess.lowercaseString {
                return true
            }
        }
        return false
    }
    
    @IBAction func guessButton(sender: AnyObject) {
        if isGuessInPhrase(userGuess.text!, phrase: globalPhrase) {
            correctGuess()
        } else {
            wrongGuess()
        }
        userGuess.text = ""
    }
    

    func correctGuess() {
        var indexToChange = 0
        if blanksOfAnswerArray.count == 1 {
            imageView.image = UIImage(named: "you-win.gif")
        } else {
            for var i = 0; i < globalPhrase.count; i++ {
                if globalPhrase[i].lowercaseString == userGuess.text?.lowercaseString {
                    globalPhrase[i] = "_"
                    indexToChange = i
                    break
                }
            }
            //Insert that userGuess at that index into blanksOfAnswer
            blanksOfAnswerArray.removeAtIndex(indexToChange)
            blanksOfAnswerArray.insert(userGuess.text!, atIndex: indexToChange)
        }
        blanksOfAnswer.text = blanksOfAnswerArray.joinWithSeparator("  ")
        
    }
    
    func wrongGuess() {
        counter++
        if counter < 7 {
            imageView.image = UIImage(named: "hangman\(counter).gif")
        }
        else {
            imageView.image = UIImage(named: "you-lose.gif")
        }
        listOfWrongGuesses.text = String(wrongGuesses)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        listOfWrongGuesses.text = wrongGuesses.joinWithSeparator(", ")
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        imageView.image = UIImage(named: "hangman1.gif")
        for char in phrase.characters {
            let ch = String(char)
            globalPhrase.append(ch)
        }
        for var i = 0; i <= phrase.characters.count; i++ {
            blanksOfAnswerArray.append("_")
        }
        blanksOfAnswer.text = blanksOfAnswerArray.joinWithSeparator("  ")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
