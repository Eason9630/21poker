//
//  PokerViewController.swift
//  21poker
//
//  Created by 林祔利 on 2023/4/1.
//

import UIKit

class PokerViewController: UIViewController {


    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var playerBetLabel: UILabel!
    @IBOutlet weak var gameBetLabel: UILabel!
    @IBOutlet var dealer: [UIImageView]!
    
    @IBOutlet weak var choiceSegment: UISegmentedControl!
    @IBOutlet weak var plusBut: UIButton!
    @IBOutlet weak var minusBut: UIButton!
    @IBOutlet weak var dealerLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet var player: [UIImageView]!
    var usedIndexes = Set<Int>()
    var suits = ["c","d","h","s"]
    var ranks = [1,2,3,4,5,6,7,8,9,10,11,12,13]
    var cards = [Poker]()
    var dealerIndex = 0
    var playerIndex = 0
    var playerBet = 1000
    var betTotal = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        player[2].isHidden = true
        player[3].isHidden = true
        player[4].isHidden = true
        
        dealer[2].isHidden = true
        dealer[3].isHidden = true
        dealer[4].isHidden = true

        playerBetLabel.text = "\(playerBet)"

    }
    func setCard (){
            for suit in suits {
                for rank in ranks {
                    var poker = Poker(name: suit, num: rank)
                    cards.append(poker)
                }
            }
        dealerIndex = 0
        playerIndex = 0
        i = 2
        for i in 0...1 {
            var index = Int.random(in: 0...51)
            while usedIndexes.contains(index) {
                index = Int.random(in: 0...51)
            }
            usedIndexes.insert(index)
            dealer[i].image = UIImage(named: "poker-\(cards[index].name)\(cards[index].num)")
            
                dealerIndex += addScore(index)
                dealerLabel.text = "\(dealerIndex)"
            
        }
        for i in 0...1{
            var index = Int.random(in: 0...51)
            while usedIndexes.contains(index) {
                index = Int.random(in: 0...51)
            }
            player[i].image = UIImage(named: "poker-\(cards[index].name)\(cards[index].num)")
            
                playerIndex += addScore(index)
                playerLabel.text = "\(playerIndex)"
            
        }
    }
    
    func addScore(_ index: Int) -> Int {
        var number = cards[index].num
        switch number {
        case 11...14 :
            number = 10
        case 1 :
            if playerIndex < 12 && dealerIndex < 12 {
                number = 1
            }else {
                number = 10
            }
        default:
            break
        }
        return number
    }
    
    @IBAction func start(_ sender: Any) {
        setCard()
        minusBut.isHidden = true
        plusBut.isHidden = true
        gameBetLabel.text = "\(betTotal)"

    }
    
    var i = 2
    @IBAction func getCard(_ sender: Any) {
        player[i].isHidden = false
        if i == 5 {
            return
        }
        var index = Int.random(in: 0...51)
        while usedIndexes.contains(index) {
            index = Int.random(in: 0...51)
        }
        player[i].image = UIImage(named: "poker-\(cards[index].name)\(cards[index].num)")
        playerIndex += addScore(index)
        playerLabel.text = "\(playerIndex)"
        
        if playerIndex > 21 {
            playerLostAlert()
        }
        
        i += 1
        
    }
    
    @IBAction func overGame(_ sender: Any) {
        while true {
            while dealerIndex < 17 {
                    var j = 2
                    var index = Int.random(in: 0...51)
                    while usedIndexes.contains(index) {
                        index = Int.random(in: 0...51)
                    }
                    dealer[j].image = UIImage(named: "poker-\(cards[index].name)\(cards[index].num)")
                    dealerIndex += addScore(index)
                    dealerLabel.text = "\(dealerIndex)"
                    dealer[j].isHidden = false
                    j += 1
                }
            
            if dealerIndex > 21 {
                playerBet = playerBet + betTotal
                playerBetLabel.text = "\(playerBet)"
                dealerLostAlert()
                break
                
            }else if playerIndex > 21 {
                playerBet = playerBet - betTotal
                playerBetLabel.text = "\(playerBet)"
                playerLostAlert()
                break
            }else if dealerIndex >= playerIndex {
                playerBet = playerBet - betTotal
                playerBetLabel.text = "\(playerBet)"
                playerLostAlert()
                break
                
            }else if dealerIndex < playerIndex{
                playerBet = playerBet + betTotal
                playerBetLabel.text = "\(playerBet)"
                dealerLostAlert()
                break
            }
        }
        
    }
    func betZeroAlert (){
        let controller = UIAlertController(title: "You don't have Money", message: "沒錢了要重來嗎？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "重來", style: .default) { _ in
            self.player[2].isHidden = true
            self.player[3].isHidden = true
            self.player[4].isHidden = true
            self.dealer[2].isHidden = true
            self.dealer[3].isHidden = true
            self.dealer[4].isHidden = true
            self.playerIndex = 0
            self.dealerIndex = 0
            self.i = 2
            self.betTotal = 0
            self.betLabel.text = "\(0)"
            self.gameBetLabel.text = "\(0)"
            self.dealerLabel.text = "\(0)"
            self.playerLabel.text = "\(0)"
            self.minusBut.isHidden = false
            self.plusBut.isHidden = false
            self.playerBet = 1000
            self.playerBetLabel.text = "\(self.playerBet)"
            self.player[0].image = UIImage(named: "back")
            self.player[1].image = UIImage(named: "back")
            self.dealer[0].image = UIImage(named: "back")
            self.dealer[1].image = UIImage(named: "back")
            
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }

    
    func playerLostAlert (){
        let controller = UIAlertController(title: "You Lost", message: "下一局", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "再來", style: .default) { _ in
            self.player[2].isHidden = true
            self.player[3].isHidden = true
            self.player[4].isHidden = true
            self.dealer[2].isHidden = true
            self.dealer[3].isHidden = true
            self.dealer[4].isHidden = true
            self.playerIndex = 0
            self.dealerIndex = 0
            self.i = 2
            self.betTotal = 0
            self.betLabel.text = "\(0)"
            self.gameBetLabel.text = "\(0)"
            self.dealerLabel.text = "\(0)"
            self.playerLabel.text = "\(0)"
            self.minusBut.isHidden = false
            self.plusBut.isHidden = false
            self.player[0].image = UIImage(named: "back")
            self.player[1].image = UIImage(named: "back")
            self.dealer[0].image = UIImage(named: "back")
            self.dealer[1].image = UIImage(named: "back")
            if self.playerBet == 0 {
                self.betZeroAlert()
            }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    
    func dealerLostAlert () {
        let controller = UIAlertController(title: "You Win", message: "下一局", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "再來", style: .default) { _ in
            self.player[2].isHidden = true
            self.player[3].isHidden = true
            self.player[4].isHidden = true
            self.dealer[2].isHidden = true
            self.dealer[3].isHidden = true
            self.dealer[4].isHidden = true
            self.playerIndex = 0
            self.dealerIndex = 0
            self.i = 2
            self.betTotal = 0
            self.betLabel.text = "\(0)"
            self.gameBetLabel.text = "\(0)"
            self.dealerLabel.text = "\(0)"
            self.playerLabel.text = "\(0)"
            self.minusBut.isHidden = false
            self.plusBut.isHidden = false
            self.player[0].image = UIImage(named: "back")
            self.player[1].image = UIImage(named: "back")
            self.dealer[0].image = UIImage(named: "back")
            self.dealer[1].image = UIImage(named: "back")
            if self.playerBet == 0 {
                self.betZeroAlert()
            }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    
    
    @IBAction func calculate(_ sender: UIButton) {
        if choiceSegment.selectedSegmentIndex == 0 {
            if sender == plusBut {
                betTotal = betTotal + 10
                betLabel.text = "\(betTotal)"
            }else{
                betTotal = betTotal - 10
                betLabel.text = "\(betTotal)"
            }
        }
        if choiceSegment.selectedSegmentIndex == 1 {
            if sender == plusBut {
                betTotal = betTotal + 50
                betLabel.text = "\(betTotal)"
            }else{
                betTotal = betTotal - 50
                betLabel.text = "\(betTotal)"
            }
        }
        if choiceSegment.selectedSegmentIndex == 2 {
            if sender == plusBut {
                betTotal = betTotal + 100
                betLabel.text = "\(betTotal)"
            }else{
                betTotal = betTotal - 100
                betLabel.text = "\(betTotal)"
            }
        }
        if betTotal >= playerBet{
            betTotal = playerBet
            betLabel.text = "\(betTotal)"
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
