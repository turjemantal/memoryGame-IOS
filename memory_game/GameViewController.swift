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
    @IBOutlet weak var game_IMG_card0: UIButton!
    @IBOutlet weak var game_IMG_card1: UIButton!
    @IBOutlet weak var game_IMG_card2: UIButton!
    @IBOutlet weak var game_IMG_card3: UIButton!
    @IBOutlet weak var game_IMG_card4: UIButton!
    @IBOutlet weak var game_IMG_card5: UIButton!
    @IBOutlet weak var game_IMG_card6: UIButton!
    @IBOutlet weak var game_IMG_card7: UIButton!
    @IBOutlet weak var game_IMG_card8: UIButton!
    @IBOutlet weak var game_IMG_card9: UIButton!
    @IBOutlet weak var game_IMG_card10: UIButton!
    @IBOutlet weak var game_IMG_card11: UIButton!
    @IBOutlet weak var game_IMG_card12: UIButton!
    @IBOutlet weak var game_IMG_card13: UIButton!
    @IBOutlet weak var game_IMG_card14: UIButton!
    @IBOutlet weak var game_IMG_card15: UIButton!
    @IBOutlet weak var game_LBL_timer: UILabel!
    @IBOutlet weak var game_LBL_moves: UILabel!
    @IBOutlet weak var game_LBL_score: UILabel!
    @IBOutlet weak var game_BTN_play: UIButton!
    
    private var previousButton: UIButton!
    
    private var pairedSuccessfully: Int = 0//how many cards are paired
    private var score = 0
    private var isPlaying = false
    private var imagesCounter = Array(repeating: 0, count: 8)
    private var imageInPlace: [(image: UIImage,isOpen: Bool)] = []
    private var cards: [UIButton] = []
    private var counter: Int = 0
    
    private let images = [#imageLiteral(resourceName: "ic_chicken") ,#imageLiteral(resourceName: "ic_burger") ,#imageLiteral(resourceName: "ic_fries") ,#imageLiteral(resourceName: "ic_broccoli") ,#imageLiteral(resourceName: "ic_chocolate") ,#imageLiteral(resourceName: "ic_sushi") ,#imageLiteral(resourceName: "ic_cake") ,#imageLiteral(resourceName: "ic_pizza")]
    private let numOfMoves: Int = 25
    private let back_card = #imageLiteral(resourceName: "icon_square")
    private let cardMatrixSize = 16 //4*4
    private let numOfImageDuplicate = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game_LBL_moves.text = String(numOfMoves)
        
        //        cards = [game_IMG_card0, game_IMG_card1, game_IMG_card2,
        //                 game_IMG_card3, game_IMG_card4, game_IMG_card5, game_IMG_card6,
        //                 game_IMG_card7, game_IMG_card8, game_IMG_card9, game_IMG_card10,
        //                 game_IMG_card11, game_IMG_card12, game_IMG_card13, game_IMG_card14,
        //                 game_IMG_card15]
        
        initCards()
        
        
    }
    //functions/actions...
    
    func initCards() {
        let images = [#imageLiteral(resourceName: "ic_chicken") ,#imageLiteral(resourceName: "ic_burger") ,#imageLiteral(resourceName: "ic_fries") ,#imageLiteral(resourceName: "ic_broccoli") ,#imageLiteral(resourceName: "ic_chocolate") ,#imageLiteral(resourceName: "ic_sushi") ,#imageLiteral(resourceName: "ic_cake") ,#imageLiteral(resourceName: "ic_pizza")]
        
        //tag is the index i
        for i in 0..<cardMatrixSize {
            var rndCardImg = Int.random(in: 0 ..< images.count)
            //            print(rndCardImg)
            //checking if the image is presented twice
            while (imagesCounter[rndCardImg] >= numOfImageDuplicate) {
                rndCardImg = Int.random(in: 0 ..< images.count)
            }
            imageInPlace.append((image: images[rndCardImg], isOpen: false))
            print("----- i ")
            print(i)
            print(images[rndCardImg].description)
            imagesCounter[rndCardImg] += 1
            //               print("----- image counter ")
            //            print( imagesCounter[rndCardImg])
            
            
        }
    }
    
    func checkMatch(previous: UIButton, current: UIButton){
        if(imageInPlace[previous.tag].image == imageInPlace[current.tag].image && previous.tag != current.tag && imageInPlace[previous.tag].isOpen && imageInPlace[current.tag].isOpen) {
            print(imageInPlace[previous.tag].image.description)
            print(imageInPlace[current.tag].image.description)
            
            pairedSuccessfully += 1
            previous.isEnabled = false
            current.isEnabled = false
            
            print(pairedSuccessfully)
            print("MATCH!! ")
            //TODO: add score later
            score += 10
            game_LBL_score.text = "Score: " + String(score)
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.closeCard(card: previous)
                self.closeCard(card: current)
            }
            //TODO: need to count num of moves
        }
    }
    
    func openCard(card: UIButton){
        card.setImage(imageInPlace[card.tag].image, for: .normal)
        imageInPlace[card.tag].isOpen = true
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromLeft,
                          animations: nil, completion: nil)
    }
    
    func closeCard(card: UIButton){
        card.setImage(back_card, for: .normal)
        imageInPlace[card.tag].isOpen = false
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromRight,
                          animations: nil, completion: nil)
    }
    
    func gameOver() -> Bool{
        if(pairedSuccessfully == (cardMatrixSize/numOfImageDuplicate)){
            isPlaying = false
            return true
        }
        return false
    }
    
    @IBAction func clickPlayGame(_ sender: UIButton) {
        isPlaying = true
    }
    @IBAction func button_clicked(_ sender: UIButton) {
    
        counter += 1 //amount of button clicks
        print(counter)
        openCard(card: sender)
        
        if(counter % 2 == 0){
            //TODO: need to handle moves
            //TODO: handle with other cards open -> while 2 cards are open -> cant open new cards...
            checkMatch(previous: previousButton, current: sender)
        }
        previousButton = sender
    }
    
}
