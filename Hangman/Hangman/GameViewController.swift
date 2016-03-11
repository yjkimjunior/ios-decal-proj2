//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var wrongGuesses:[String] = []
    var correctGuesses:[String] = []
    var blanksOfAnswerArray:[String] = []
    var globalPhrase:[String] = []
    var counter = 1
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blanksOfAnswer: UILabel!
    @IBOutlet weak var userGuess: UITextField!
   
    @IBOutlet weak var wrongGuess: UIButton!
    @IBOutlet weak var correctGuess: UIButton!
    
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
            correctGuesses.append(userGuess.text!)
            correctGuess.hidden = false
        } else {
            wrongGuesses.append(String(userGuess.text!))
            wrongGuess.hidden = false
        }
        userGuess.text = ""
    }
    
    //pressed wrong! button
    @IBAction func wrongGuess(sender: AnyObject) {
        counter++
        if counter <= 7 {
            imageView.image = UIImage(named: "hangman\(counter).gif")
        }
        else {
            imageView.image = UIImage(named: "you-lose.gif")
        }
        
        
        listOfWrongGuesses.text = String(wrongGuesses)
        wrongGuess.hidden = true
    }

    @IBAction func correctGuess(sender: AnyObject) {
        //For Now: Just remove one blank
        if blanksOfAnswerArray.count == 0 {
            imageView.image = UIImage(named: "you-win.gif")
        } else {
            blanksOfAnswerArray.removeAtIndex(0)
        }
        blanksOfAnswer.text = blanksOfAnswerArray.joinWithSeparator("  ")
        correctGuess.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wrongGuess.hidden = true
        correctGuess.hidden = true
        
//        if userGuess.text!.characters.count != 1 {
//            print("wtf man")
//        }
        listOfWrongGuesses.text = wrongGuesses.joinWithSeparator(", ")
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
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
