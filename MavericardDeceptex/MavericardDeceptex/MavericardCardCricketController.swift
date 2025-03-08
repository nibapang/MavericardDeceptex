//
//  CardCricketGameVC.swift
//  MavericardDeceptex
//
//  Created by Mavericard Deceptex on 2025/3/8.
//


import UIKit

class MavericardCardCricketController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var battingDieImage: UIImageView!
    @IBOutlet weak var umpireDieImage: UIImageView!
    @IBOutlet weak var gameStatusTextView: UITextView!
    @IBOutlet weak var rollBattingDieButton: UIButton!
    @IBOutlet weak var rollUmpireDieButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var scoresTableView: UITableView!
    @IBOutlet weak var lblbattingresult: UILabel!
    @IBOutlet weak var lblumpireResult
    : UILabel!
    
    // Game Variables
    var currentScore: Int = 0
    var batsmenOut: Int = 0
    var battingTeam: [Int] = [] // Player scores
    var computerTeam: [Int] = [] // Computer scores
    let battingDieSides = ["1 Run", "2 Run", "3 Run", "4 Run", "owzthat", "6 Run"]
    let umpireDieSides = ["bowled", "stumped", "caught", "not out", "no ball", "LBW"]
    var isPlayerTurn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
        
        // Setup TableView
        scoresTableView.delegate = self
        scoresTableView.dataSource = self
        scoresTableView.register(UINib(nibName: "ScoreCell", bundle: nil), forCellReuseIdentifier: "ScoreCell")
        scoresTableView.layer.borderColor = UIColor(named: "Color 1")?.cgColor
        scoresTableView.layer.cornerRadius = 16
        scoresTableView.layer.borderWidth = 3
        scoresTableView.clipsToBounds = true
    }
    
    // Actions
    @IBAction func rollBattingDie(_ sender: UIButton) {
        let playerTotal = battingTeam.reduce(0, +)
        let computerTotal = computerTeam.reduce(0, +)

        if computerTotal > playerTotal {
            declareWinner()
            return
        }
        
        guard batsmenOut < 10 else { return }

        let result = battingDieSides.randomElement()!
        lblbattingresult.text = "\(result)"
        if result == "owzthat" {
            gameStatusTextView.text = "Owzthat! Roll the Umpire Die to check the batsman's fate."
            rollBattingDieButton.isEnabled = false
            rollBattingDieButton.alpha = 0.5
            rollUmpireDieButton.isEnabled = true
            rollUmpireDieButton.alpha = 1
        } else {
            // Extract numeric value from "X Run"
            let runValue = Int(result.split(separator: " ")[0]) ?? 0
            currentScore += runValue
            gameStatusTextView.text = "You scored \(currentScore) so far. Keep rolling!"

            // Set image based on score
            if currentScore >= 100 {
                battingDieImage.image = UIImage(named: "hundred")
            } else if currentScore >= 50 {
                battingDieImage.image = UIImage(named: "fifty")
            } else {
                print(result)
                battingDieImage.image = UIImage(named: result) // Use direct string for image name
            }
        }
    }


    
    @IBAction func rollUmpireDie(_ sender: UIButton) {
        guard batsmenOut < 10 else { return }
        
        let result = umpireDieSides.randomElement()!
        umpireDieImage.image = UIImage(named: result)
        lblumpireResult.text = "\(result)"
        switch result {
        case "not out":
            gameStatusTextView.text = "The batsman is not out. Keep playing!"
            rollBattingDieButton.isEnabled = true
            rollBattingDieButton.alpha = 1
            rollUmpireDieButton.isEnabled = false
            rollUmpireDieButton.alpha = 0.5
        case "no ball":
            gameStatusTextView.text = "No ball! Extra run awarded. Roll the batting die again!"
            currentScore += 1
            rollBattingDieButton.isEnabled = true
            rollBattingDieButton.alpha = 1
            rollUmpireDieButton.isEnabled = false
            rollUmpireDieButton.alpha = 0.5
        default:
            batsmenOut += 1
            if isPlayerTurn {
                battingTeam.append(currentScore)
            } else {
                computerTeam.append(currentScore)
            }
            scoresTableView.reloadData()
            gameStatusTextView.text = "The batsman is \(result). \(batsmenOut) batsmen are out. Next batsman is in."
            currentScore = 0
            rollBattingDieButton.isEnabled = true
            rollBattingDieButton.alpha = 1
            rollUmpireDieButton.isEnabled = false
            rollUmpireDieButton.alpha = 0.5
        }
        
        if batsmenOut == 10 {
            if isPlayerTurn {
                gameStatusTextView.text = "Player's turn is over. Total score: \(battingTeam.reduce(0, +)). Now it's the computer's turn."
                isPlayerTurn = false
                batsmenOut = 0
                rollBattingDieButton.isEnabled = true
                rollBattingDieButton.alpha = 1
                rollUmpireDieButton.isEnabled = false
                rollUmpireDieButton.alpha = 0.5
            } else {
                gameStatusTextView.text = "Computer's turn is over. Total score: \(computerTeam.reduce(0, +)). Game Over!"
                rollBattingDieButton.isEnabled = false
                rollBattingDieButton.alpha = 0.5
                rollUmpireDieButton.isEnabled = false
                rollUmpireDieButton.alpha = 0.5
                declareWinner()
            }
        }
    }
    
    private func declareWinner() {
        let playerTotal = battingTeam.reduce(0, +)
        let computerTotal = computerTeam.reduce(0, +)
        
        let winner: String
        if playerTotal > computerTotal {
            winner = "Team 1 Wins!"
        } else if computerTotal > playerTotal {
            winner = "Team 2 Wins!"
        } else {
            winner = "It's a Draw!"
        }
        
        let alert = UIAlertController(title: "Game Over", message: winner, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.resetGame()
        })
        present(alert, animated: true)
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        resetGame()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    // Helper Functions
    private func resetGame() {
        currentScore = 0
        batsmenOut = 0
        battingTeam = []
        computerTeam = []
        isPlayerTurn = true
        battingDieImage.image = UIImage(named: "")
        umpireDieImage.image = UIImage(named: "")
        gameStatusTextView.text = "Game reset. Start rolling the batting die!"
        rollBattingDieButton.isEnabled = true
        rollBattingDieButton.alpha = 1
        rollUmpireDieButton.isEnabled = false
        rollUmpireDieButton.alpha = 0.5
        scoresTableView.reloadData()
    }
    
    
    // TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(battingTeam.count, computerTeam.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as? ScoreCell else { return UITableViewCell() }
        let playerScore = indexPath.row < battingTeam.count ? "\(battingTeam[indexPath.row])" : "-"
        let computerScore = indexPath.row < computerTeam.count ? "\(computerTeam[indexPath.row])" : "-"
        cell.LBLPLAYER.text = "Player \(indexPath.row + 1) : \(playerScore)"
        cell.LBLCOMPUTER.text = "Player \(indexPath.row + 1) : \(computerScore)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
