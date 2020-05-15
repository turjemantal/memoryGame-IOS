//
//  GameViewController.swift
//  memory_game
//
//  Created by Liel Titelbaum on 13/05/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //vars
    @IBOutlet var game_BTN_cards: [UIButton]!//collection of all the card buttons
    @IBOutlet weak var game_LBL_timer: UILabel!
    @IBOutlet weak var game_LBL_moves: UILabel!
    @IBOutlet weak var game_LBL_score: UILabel!
    @IBOutlet weak var game_BTN_play: UIButton!
    
    private var previousButton: UIButton!
    
    private var pairedSuccessfully: Int = 0//how many cards are paired
    private var score = 0
    private var isPlaying = false
    //    private var isUserWon: Bool
    private var imagesCounter = Array(repeating: 0, count: 8)
    private var imageInPlace: [(image: UIImage, isOpen: Bool)] = []//array of tuple of image and if the card is open -> the index represent the card tag(simulate its' location)
    private var cards: [UIButton] = []
    private var counter: Int = 0//pressing cards counter
    private var timer = Timer()
    private var numOfMoves: Int = 20
    
    private let images = [#imageLiteral(resourceName: "ic_chicken") ,#imageLiteral(resourceName: "ic_burger") ,#imageLiteral(resourceName: "ic_fries") ,#imageLiteral(resourceName: "ic_broccoli") ,#imageLiteral(resourceName: "ic_chocolate") ,#imageLiteral(resourceName: "ic_sushi") ,#imageLiteral(resourceName: "ic_cake") ,#imageLiteral(resourceName: "ic_pizza")]
    private let back_card = #imageLiteral(resourceName: "icon_square")
    private let cardMatrixSize = 16 //4*4
    private let numOfImageDuplicate = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGameLabels()
        //        for card in game_BTN_cards {
        ////           closeCard(card: card)
        //        }
    }
    //functions/actions...
    func resetCards() {
        for i in 0..<imagesCounter.count {
            imagesCounter[i] = 0
        }
    }
    
    func setGameLabels() {
        game_LBL_moves.text = String(numOfMoves)
        game_LBL_timer.text = String(0) + " S"
        game_LBL_score.text = "Score: 0"
    }
    
    func initGame() {
        resetCards()
        shuffleCards()
        score = 0
        pairedSuccessfully = 0
        numOfMoves = 2
        //        isUserWon = false
        setGameLabels()
        setTimer(on: true)
        for card in game_BTN_cards {
            card.isEnabled = true
            closeCard(card: card)
        }
    }
    
    func shuffleCards() {
        var rndCardImg: Int = Int.random(in: 0 ..< images.count)
        //tag is the index i in the imageInPlace array
        for _ in 0..<cardMatrixSize {
            //TODO: each time rand new places for images
            //            var rndCardImg = Int.random(in: 0 ..< images.count)
            //            print(rndCardImg)
            //checking if the image is presented twice
            repeat{
                rndCardImg = Int.random(in: 0 ..< images.count)
                print("random num= \(rndCardImg)")
                print(images[rndCardImg].description)
            } while (imagesCounter[rndCardImg] >= numOfImageDuplicate) //if the image already been place twice-> rand different image
            //                            rndCardImg = Int.random(in: 0 ..< images.count)
            //            while (imagesCounter[rndCardImg] >= numOfImageDuplicate){
            //                rndCardImg = Int.random(in: 0 ..< images.count)
            //            }
            
            imageInPlace.append((image: images[rndCardImg], isOpen: false))
            imagesCounter[rndCardImg] += 1
        }
    }
    
    func checkMatch(previous: UIButton, current: UIButton){
        if(imageInPlace[previous.tag].image == imageInPlace[current.tag].image && previous.tag != current.tag && imageInPlace[previous.tag].isOpen && imageInPlace[current.tag].isOpen) {
            
            print(imageInPlace[previous.tag].image.description)//delete
            print(imageInPlace[current.tag].image.description)//delete
            
            pairedSuccessfully += 1
            previous.isEnabled = false
            current.isEnabled = false
            
            //            print(pairedSuccessfully)//TODO: delete
            //            print("MATCH!! ")//TODO: delte
            score += 10 //add 10 points when cards are being paired successfully
            game_LBL_score.text = "Score: " + String(score)
        }
        else {
            if(previous.tag != current.tag){ //if user press on two cards that are not a pair and not on the same card twice
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.closeCard(card: previous)
                    self.closeCard(card: current)
                }
            }
        }
    }
    
    func openCard(card: UIButton){
        card.setImage(imageInPlace[card.tag].image, for: .normal)
        imageInPlace[card.tag].isOpen = true
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromLeft,
                          animations: nil, completion: nil)
    }
    
    func closeCard(card: UIButton) {
        card.setImage(back_card, for: .normal)
        imageInPlace[card.tag].isOpen = false
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromRight,
                          animations: nil, completion: nil)
    }
    
    func setTimer(on: Bool) {
        var duration = 0
        if(on) {//run timer each second
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.game_LBL_timer.text = String(duration) + " S"
                duration += 1
            }
        }
        else {
            timer.invalidate()//pause
        }
    }
    
    @IBAction func clickPlayGame(_ sender: UIButton) {
        if(!isPlaying) {
            initGame()
            game_BTN_play.isHidden = true
            isPlaying = true
        }
        else {
            isPlaying = false
            game_BTN_play.isHidden = false
        }
    }
    
    func checkIfWinner() {
        if(pairedSuccessfully == cardMatrixSize/numOfImageDuplicate) {//if the user matched all of the cards-> he wons
            setTimer(on: false)
            game_BTN_play.setTitle("YOU WON!\nPlay again", for: .normal)
            game_BTN_play.isHidden = false
            //            isUserWon = true
            isPlaying = false
        }
        else if(numOfMoves == 0){//if he lost -> ran out of moves
            setTimer(on: false)
            isPlaying = false
            game_BTN_play.setTitle("YOU LOST\nPlay again", for: .normal)
            game_BTN_play.isHidden = false
        }
    }
    
    @IBAction func button_clicked(_ sender: UIButton) {
        if(isPlaying) {
            counter += 1 //amount of button clicks
            
            openCard(card: sender)
            
            if(counter % 2 == 0){
                if(sender != previousButton) {
                    numOfMoves -= 1
                    game_LBL_moves.text = String(numOfMoves)
                    checkMatch(previous: previousButton, current: sender)
                }
                else{
                    counter = 1
                }
            }
            previousButton = sender
        }
        checkIfWinner()
    }
    
}
