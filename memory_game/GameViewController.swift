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
    private var imagesCounter = Array(repeating: 0, count: 8)
    private var imageInPlace: [(image: UIImage, isOpen: Bool)] = []//array of tuple of image and if the card is open -> the index represent the card tag(simulate its' location)
    private var cards: [UIButton] = []
    private var counter: Int = 0//pressing cards counter
    private var timer = Timer()
    private var numOfMoves: Int = 20
    //Const
    private let images = [#imageLiteral(resourceName: "ic_chicken") ,#imageLiteral(resourceName: "ic_burger") ,#imageLiteral(resourceName: "ic_fries") ,#imageLiteral(resourceName: "ic_broccoli") ,#imageLiteral(resourceName: "ic_chocolate") ,#imageLiteral(resourceName: "ic_sushi") ,#imageLiteral(resourceName: "ic_cake") ,#imageLiteral(resourceName: "ic_pizza")]
    private let backCard = #imageLiteral(resourceName: "ic_back_card")
    private let cardMatrixSize = 16 //4*4
    private let numOfImageDuplicate = 2
    private let gameMoves = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGameLabels()
    }
    
    func resetCards() {
        for i in 0..<imagesCounter.count {
            imagesCounter[i] = 0
        }
        imageInPlace.removeAll()//remove all current card to image randomly allocations
    }
    
    func setGameLabels() {
        game_LBL_moves.text = String(numOfMoves)
        game_LBL_timer.text = String(0) + " S"
        game_LBL_score.text = "Score: 0"
    }
    
    func initGame() {
        score = 0
        pairedSuccessfully = 0
        numOfMoves = gameMoves
        
        setGameLabels()
        resetCards()
        shuffleCards()
        setTimer(on: true)
        
        for card in game_BTN_cards {
            card.isEnabled = true
            closeCard(card: card)
        }
    }
    
    func shuffleCards() {
        var rndCardImg: Int
        //tag is the index i in the imageInPlace array
        //image counter represent how many times image is being assign -> need only twice
        for _ in 0..<cardMatrixSize {
            //checking if the image is presented twice
            repeat{
                rndCardImg = Int.random(in: 0 ..< images.count)
            } while (imagesCounter[rndCardImg] >= numOfImageDuplicate); //if the image already been place twice-> rand different image
            //puts in imageInPlace in index (=button tag) the image that has been selected randomly
            imageInPlace.append((image: images[rndCardImg], isOpen: false))
            imagesCounter[rndCardImg] += 1
        }
    }
    
    func checkMatch(previous: UIButton, current: UIButton){
        if(imageInPlace[previous.tag].image == imageInPlace[current.tag].image && previous.tag != current.tag && imageInPlace[previous.tag].isOpen && imageInPlace[current.tag].isOpen){
            //if the images are the same and the tag(=index) of the card is different and the cards are open
            pairedSuccessfully += 1
            previous.isEnabled = false
            current.isEnabled = false
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
    
    func closeCard(card: UIButton){
        card.setImage(backCard, for: .normal)
        imageInPlace[card.tag].isOpen = false
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromRight,
                          animations: nil, completion: nil)
    }
    
    func setTimer(on: Bool){
        if(on) {//run timer each second
            var duration = 0
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                duration += 1
                self.game_LBL_timer.text = String(duration) + " S"
            }
        }
        else {
            timer.invalidate()//pause
        }
    }
    
    @IBAction func clickPlayGame(_ sender: UIButton){//when play is being clicked
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
    
    func checkIfWinner(){//check if the user lost or won
        if(pairedSuccessfully == cardMatrixSize/numOfImageDuplicate) {//if the user matched all of the cards-> he wons
            setGameWhenStop(isUserWon: true)
        }
        else if(numOfMoves == 0){//if he lost -> ran out of moves
            setGameWhenStop(isUserWon: false)
        }
    }
    
    func setGameWhenStop(isUserWon: Bool){//if the game is ended
        setTimer(on: false)//pause timer
        game_BTN_play.isHidden = false
        isPlaying = false
        if(isUserWon) {
            game_BTN_play.setTitle("YOU WON!\nPlay again", for: .normal)
        }
        else {
            game_BTN_play.setTitle("YOU LOST\nPlay again", for: .normal)
        }
    }
    
    @IBAction func button_clicked(_ sender: UIButton){
        if(isPlaying) {
            counter += 1 //amount of button clicks
            
            openCard(card: sender)
            
            if(counter % 2 == 0){
                if(sender != previousButton){
                    numOfMoves -= 1
                    game_LBL_moves.text = String(numOfMoves)
                    checkMatch(previous: previousButton, current: sender)
                }
                else{//if the user click on the same card- don't count the number of moves
                    counter = 1
                }
            }
            previousButton = sender
            checkIfWinner()
        }
    }
    
}
