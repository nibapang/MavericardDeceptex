//
//  ViewController.swift
//  MavericardDeceptex
//
//  Created by Mavericard Deceptex on 2025/3/8.
//

import UIKit

class MavericardSingleCardController: UIViewController {
    // UI Elements
    @IBOutlet weak var diceImage: UIImageView!
    @IBOutlet weak var rollDiceButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    
    // Beetle Parts for Player 1
    @IBOutlet weak var bodyPartP1: UIImageView!
    @IBOutlet weak var headPartP1: UIImageView!
    @IBOutlet weak var tailPartP1: UIImageView!
    @IBOutlet var legsP1: [UIImageView]! // 4 legs
    @IBOutlet var antennasP1: [UIImageView]! // 2 antennas
    @IBOutlet var eyesP1: [UIImageView]! // 2 eyes

    // Beetle Parts for Player 2
    @IBOutlet weak var bodyPartP2: UIImageView!
    @IBOutlet weak var headPartP2: UIImageView!
    @IBOutlet weak var tailPartP2: UIImageView!
    @IBOutlet var legsP2: [UIImageView]! // 4 legs
    @IBOutlet var antennasP2: [UIImageView]! // 2 antennas
    @IBOutlet var eyesP2: [UIImageView]! // 2 eyes

    // Game State for Player 1
    var hasBodyP1 = false
    var hasHeadP1 = false
    var hasTailP1 = false
    var drawnLegsP1 = 0
    var drawnAntennasP1 = 0
    var drawnEyesP1 = 0

    // Game State for Player 2
    var hasBodyP2 = false
    var hasHeadP2 = false
    var hasTailP2 = false
    var drawnLegsP2 = 0
    var drawnAntennasP2 = 0
    var drawnEyesP2 = 0

    // Turn Management
    var currentPlayer = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
    }

    @IBAction func rollDice(_ sender: UIButton) {
        let diceRoll = Int.random(in: 1...6)
        diceImage.image = UIImage(named: "\(diceRoll)")
        processDiceRoll(diceRoll, forPlayer: currentPlayer)
    }

    func processDiceRoll(_ roll: Int, forPlayer player: Int) {
        switch player {
        case 1:
            processRollForPlayer1(roll)
        case 2:
            processRollForPlayer2(roll)
        default:
            break
        }

        // Check if the game is won
        if checkWinCondition(forPlayer: player) {
            messageLabel.text = "Player \(player) wins!"
            rollDiceButton.isEnabled = false
            return
        }

        // Switch Turn
        currentPlayer = currentPlayer == 1 ? 2 : 1
        turnLabel.text = "Player \(currentPlayer)'s Turn"
    }

    func processRollForPlayer1(_ roll: Int) {
        switch roll {
        case 6: // Body
            if !hasBodyP1 {
                hasBodyP1 = true
                bodyPartP1.isHidden = false
                messageLabel.text = "Player 1 drew the body!"
            } else {
                messageLabel.text = "Body already drawn!"
            }
        case 5: // Head
            if hasBodyP1 && !hasHeadP1 {
                hasHeadP1 = true
                headPartP1.isHidden = false
                messageLabel.text = "Player 1 drew the head!"
            } else if !hasBodyP1 {
                messageLabel.text = "You need the body first!"
            } else {
                messageLabel.text = "Head already drawn!"
            }
        case 4: // Tail
            if hasBodyP1 && !hasTailP1 {
                hasTailP1 = true
                tailPartP1.isHidden = false
                messageLabel.text = "Player 1 drew the tail!"
            } else if !hasBodyP1 {
                messageLabel.text = "You need the body first!"
            } else {
                messageLabel.text = "Tail already drawn!"
            }
        case 3: // Legs
            if hasBodyP1 && drawnLegsP1 < 4 {
                legsP1[drawnLegsP1].isHidden = false
                drawnLegsP1 += 1
                messageLabel.text = "Player 1 drew a leg! (\(drawnLegsP1)/4)"
            } else if !hasBodyP1 {
                messageLabel.text = "You need the body first!"
            } else {
                messageLabel.text = "All legs drawn!"
            }
        case 2: // Antennas
            if hasHeadP1 && drawnAntennasP1 < 2 {
                antennasP1[drawnAntennasP1].isHidden = false
                drawnAntennasP1 += 1
                messageLabel.text = "Player 1 drew an antenna! (\(drawnAntennasP1)/2)"
            } else if !hasHeadP1 {
                messageLabel.text = "You need the head first!"
            } else {
                messageLabel.text = "All antennas drawn!"
            }
        case 1: // Eyes
            if hasHeadP1 && drawnEyesP1 < 2 {
                eyesP1[drawnEyesP1].isHidden = false
                drawnEyesP1 += 1
                messageLabel.text = "Player 1 drew an eye! (\(drawnEyesP1)/2)"
            } else if !hasHeadP1 {
                messageLabel.text = "You need the head first!"
            } else {
                messageLabel.text = "All eyes drawn!"
            }
        default:
            break
        }
    }

    func processRollForPlayer2(_ roll: Int) {
        switch roll {
        case 6: // Body
            if !hasBodyP2 {
                hasBodyP2 = true
                bodyPartP2.isHidden = false
                messageLabel.text = "Player 2 drew the body!"
            } else {
                messageLabel.text = "Body already drawn!"
            }
        case 5: // Head
            if hasBodyP2 && !hasHeadP2 {
                hasHeadP2 = true
                headPartP2.isHidden = false
                messageLabel.text = "Player 2 drew the head!"
            } else if !hasBodyP2 {
                messageLabel.text = "You need the body first!"
            } else {
                messageLabel.text = "Head already drawn!"
            }
        case 4: // Tail
            if hasBodyP2 && !hasTailP2 {
                hasTailP2 = true
                tailPartP2.isHidden = false
                messageLabel.text = "Player 2 drew the tail!"
            } else if !hasBodyP2 {
                messageLabel.text = "You need the body first!"
            } else {
                messageLabel.text = "Tail already drawn!"
            }
        case 3: // Legs
            if hasBodyP2 && drawnLegsP2 < 4 {
                legsP2[drawnLegsP2].isHidden = false
                drawnLegsP2 += 1
                messageLabel.text = "Player 2 drew a leg! (\(drawnLegsP2)/4)"
            } else if !hasBodyP2 {
                messageLabel.text = "You need the body first!"
            } else {
                messageLabel.text = "All legs drawn!"
            }
        case 2: // Antennas
            if hasHeadP2 && drawnAntennasP2 < 2 {
                antennasP2[drawnAntennasP2].isHidden = false
                drawnAntennasP2 += 1
                messageLabel.text = "Player 2 drew an antenna! (\(drawnAntennasP2)/2)"
            } else if !hasHeadP2 {
                messageLabel.text = "You need the head first!"
            } else {
                messageLabel.text = "All antennas drawn!"
            }
        case 1: // Eyes
            if hasHeadP2 && drawnEyesP2 < 2 {
                eyesP2[drawnEyesP2].isHidden = false
                drawnEyesP2 += 1
                messageLabel.text = "Player 2 drew an eye! (\(drawnEyesP2)/2)"
            } else if !hasHeadP2 {
                messageLabel.text = "You need the head first!"
            } else {
                messageLabel.text = "All eyes drawn!"
            }
        default:
            break
        }
    }

    func checkWinCondition(forPlayer player: Int) -> Bool {
        if player == 1 {
            return hasBodyP1 && hasHeadP1 && hasTailP1 && drawnLegsP1 == 4 && drawnAntennasP1 == 2 && drawnEyesP1 == 2
        } else {
            return hasBodyP2 && hasHeadP2 && hasTailP2 && drawnLegsP2 == 4 && drawnAntennasP2 == 2 && drawnEyesP2 == 2
        }
    }

    func resetGame() {
        // Reset Player 1 State
        hasBodyP1 = false
        hasHeadP1 = false
        hasTailP1 = false
        drawnLegsP1 = 0
        drawnAntennasP1 = 0
        drawnEyesP1 = 0
        bodyPartP1.isHidden = true
        headPartP1.isHidden = true
        tailPartP1.isHidden = true
        legsP1.forEach { $0.isHidden = true }
        antennasP1.forEach { $0.isHidden = true }
        eyesP1.forEach { $0.isHidden = true }

        // Reset Player 2 State
        hasBodyP2 = false
        hasHeadP2 = false
        hasTailP2 = false
        drawnLegsP2 = 0
        drawnAntennasP2 = 0
        drawnEyesP2 = 0
        bodyPartP2.isHidden = true
        headPartP2.isHidden = true
        tailPartP2.isHidden = true
        legsP2.forEach { $0.isHidden = true }
        antennasP2.forEach { $0.isHidden = true }
        eyesP2.forEach { $0.isHidden = true }

        // Reset Game
        currentPlayer = 1
        diceImage.image = UIImage(named: "Back")
        messageLabel.text = "Player 1's turn to start!"
        turnLabel.text = "Player 1's Turn"
        rollDiceButton.isEnabled = true
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func resetGameTapped(_ sender: UIButton) {
        resetGame()
    }
}

