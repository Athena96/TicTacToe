//
//  TicTacToeGameViewController.swift
//  TicTacToe
//
//  Created by Jared Franzone on 12/19/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import UIKit

/// This class is responsible for being the middle man between the model and view.
class TicTacToeGameViewController: UIViewController {

    /// UI Buttons, reference each of the possible button locations
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!

    
    /// maps a button to its coordinates
    var buttonCoordMap = [UIButton:(row:Int,col:Int)]()
    
    /// the tic tac toe game for this view
    var game: TicTacToeGame?
    
    /**
     Called once when view first loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the button/coordinate hash map
        buttonCoordMap[ button1 ] = (0,0)
        buttonCoordMap[ button2 ] = (0,1)
        buttonCoordMap[ button3 ] = (0,2)
        buttonCoordMap[ button4 ] = (1,0)
        buttonCoordMap[ button5 ] = (1,1)
        buttonCoordMap[ button6 ] = (1,2)
        buttonCoordMap[ button7 ] = (2,0)
        buttonCoordMap[ button8 ] = (2,1)
        buttonCoordMap[ button9 ] = (2,2)
        
    }
    
    /**
     Called everytime the view appears
     
     - Parameter animated: animated or not
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)

        // init new game
        game = TicTacToeGame(players: ["X","O"], boardSize: 3)
        
    }
    
    
    /**
     IBAction method; called when a user taps on ANY of the buttons on screen
     
     - Parameters:
     - sender: the button that was tapped
     */
    @IBAction func playerMoved(_ sender: UIButton) {
        
        // check if a game exists, then get the location of the button that was tapped
        if game != nil {
            if let location = buttonCoordMap[sender] {
                
                // 1) try to place the piece at location
                do {
                    try game!.placePieceAt(location: location)
                } catch MoveError.outOfBounds {
                    alert(title: "Out of Bounds",
                          message: "This move is not allowed, because it is of the bounds of the board.")
                    return
                } catch MoveError.placeTaken {
                    alert(title: "Cannot Move Here",
                          message: "You cannot move here because the place is taken by the other player.")
                    return
                } catch {
                    print("some error")
                    return
                }
                
                // 2) place the piece on the view
                sender.setBackgroundImage( (game!.currPlayerIdx == 0) ? #imageLiteral(resourceName: "Nought") : #imageLiteral(resourceName: "Cross"), for: .normal)
                
                // 3) check state, see if a draw occored or someone won
                let state = game!.checkStatus()

                func restartHandler(action: UIAlertAction) -> Void {
                    self.game?.reset()
                    for button in self.buttonCoordMap {
                        button.key.setBackgroundImage(nil, for: .normal)
                    }
                }
                
                switch state {
                    
                case .draw:
                    alert(title: "Draw" , message: "The game is ends in a draw.", restartHandler: restartHandler)
                    break
                    
                case .win:
                    alert(title: "\(game!.winner!) Wins!" , message:  "\(game!.winner!) has won the game!", restartHandler: restartHandler)
                    break
                    
                case .noChange:
                    break
                }
                
            }
        }
        
    }
    
    /**
     Helper function to display a basic alert to the user
     
     - Parameters:
     - title: the title of the message
     - message: the body of the message
     */
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    /**
     Helper function to display a advanced alert to the user
     
     - Parameters:
     - title: the title of the message
     - message: the body of the message
     - restartHandler: a function that takes care of restarting the game
     */
    func alert(title: String, message: String, restartHandler: (((UIAlertAction)) -> Void)? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: restartHandler ?? nil))
        alert.addAction(UIAlertAction(title: "restart", style: .default, handler: restartHandler ?? nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    

}
