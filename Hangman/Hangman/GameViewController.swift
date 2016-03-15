//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var phraseLabel: UILabel!
    
    @IBOutlet var incorrectLettersLabel: UILabel!
    
    @IBOutlet var hangmanImageView: UIImageView!
    
    var guessedIncorrectLettersArray: [String]!
    
    var phraseCharacterArray : [Character]!
    
    var guessedCharacterArray : [Character]!
    
    var gameOverAlertController : UIAlertController!
    
    var gameWonAlertController : UIAlertController!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createString(phrase: String) {
        phraseCharacterArray = [Character](phrase.characters)
        guessedCharacterArray = [Character]()
        for c in phraseCharacterArray {
            if (c == " ") {
                guessedCharacterArray.append(" ")
            } else {
                guessedCharacterArray.append("-")
            }
        }
    }
    
    func updateLabelsAndPicture() {
        phraseLabel.numberOfLines = 0
        
        phraseLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        phraseLabel.text = String([Character](guessedCharacterArray))
        incorrectLettersLabel.text = guessedIncorrectLettersArray.joinWithSeparator(", ")
        if (guessedIncorrectLettersArray.count >= 6) {
            gameOverAlertController = UIAlertController(title: "Game Over", message: "The phrase was: \(String([Character](phraseCharacterArray)))", preferredStyle: UIAlertControllerStyle.Alert)
            gameOverAlertController.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.Default,handler: {action in
                self.newGame()
                
            }))
            self.presentViewController(gameOverAlertController, animated: true, completion: nil)
        }
        
        if (guessedCharacterArray == phraseCharacterArray) {
            gameWonAlertController = UIAlertController(title: "Congrats! You won!", message: "The phrase was: \(String([Character](phraseCharacterArray)))", preferredStyle: UIAlertControllerStyle.Alert)
            
            gameWonAlertController.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.Default,handler: {action in
                    self.newGame()
                    
                }))
            self.presentViewController(gameWonAlertController, animated: true, completion: nil)
        }
        
        hangmanImageView.image = UIImage(named: "Pinata\(guessedIncorrectLettersArray.count).png")
        // Images from https://dribbble.com/shots/2534817-Pinata-Fun
        
    }
    
    @IBAction func guessLetter(sender: UIButton) {
        let guessedLetter = sender.titleLabel?.text?.characters.first as Character!
        //        print(guessedLetter)
        var guessedLetterIsCorrectLetter = false
        for index in 0...(phraseCharacterArray.count - 1) {
            if (guessedLetter == phraseCharacterArray[index]) {
                guessedLetterIsCorrectLetter = true
                guessedCharacterArray[index] = guessedLetter
            }
        }
        
        if (!guessedLetterIsCorrectLetter) {
            guessedIncorrectLettersArray.append(String(guessedLetter))
        }
        
        updateLabelsAndPicture()
        
        sender.enabled = false
        sender.alpha = 0
    }
    
    func newGame() {
        for view in self.view.subviews as [UIView] {
            if let stackView = view as? UIStackView {
                for buttons in stackView.subviews as [UIView] {
                    if let btn = buttons as? UIButton {
                        btn.enabled = true
                        btn.alpha = 1
                    }
                }
            }
        }
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        guessedIncorrectLettersArray = [String]()
        createString(phrase)
        updateLabelsAndPicture()
        
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
