//
//  ViewController.swift
//  SoundMemory
//
//  Created by Training on 14/05/16.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet var soundButton: [UIButton]!
    @IBOutlet weak var levelLabel: UILabel!
    
    
    var sound1Player:AVAudioPlayer!
    var sound2Player:AVAudioPlayer!
    var sound3Player:AVAudioPlayer!
    var sound4Player:AVAudioPlayer!
    
    var playlist = [Int]()
    var currentItem = 0
    var numberOfTaps = 0
    var readyForUser = false
    
    var level = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioFiles()
    }
    
    func setupAudioFiles (){
        
        let soundFilePath = NSBundle.mainBundle().pathForResource("1", ofType: "wav")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath!)
        
        let soundFilePath2 = NSBundle.mainBundle().pathForResource("2", ofType: "wav")
        let soundFileURL2 = NSURL(fileURLWithPath: soundFilePath2!)
        
        let soundFilePath3 = NSBundle.mainBundle().pathForResource("3", ofType: "wav")
        let soundFileURL3 = NSURL(fileURLWithPath: soundFilePath3!)
        
        let soundFilePath4 = NSBundle.mainBundle().pathForResource("4", ofType: "wav")
        let soundFileURL4 = NSURL(fileURLWithPath: soundFilePath4!)
        
        do {
            try sound1Player = AVAudioPlayer(contentsOfURL: soundFileURL)
            try sound2Player = AVAudioPlayer(contentsOfURL: soundFileURL2)
            try sound3Player = AVAudioPlayer(contentsOfURL: soundFileURL3)
            try sound4Player = AVAudioPlayer(contentsOfURL: soundFileURL4)
        }catch {
            print(error)
        }
        
        sound1Player.delegate = self
        sound2Player.delegate = self
        sound3Player.delegate = self
        sound4Player.delegate = self
        
        sound1Player.numberOfLoops = 0
        sound2Player.numberOfLoops = 0
        sound3Player.numberOfLoops = 0
        sound4Player.numberOfLoops = 0
        
        
    
    }

    
    @IBAction func soundButtonPressed(sender: AnyObject) {
       
        if readyForUser {
            let button = sender as! UIButton
            
            switch button.tag {
            case 1:
                sound1Player.play()
                checkIfCorrect(1)
                break
            case 2:
                sound2Player.play()
                checkIfCorrect(2)
                break
            case 3:
                sound3Player.play()
                checkIfCorrect(3)
                break
            case 4:
                sound4Player.play()
                checkIfCorrect(4)
                break
            default:
                break
            }

        }
        
        
        
        
    }
    
    
    func checkIfCorrect (buttonPressed:Int) {
        if buttonPressed == playlist[numberOfTaps] {
            if numberOfTaps == playlist.count - 1 { // we have arrived at the last item of the playlist
                
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(NSEC_PER_SEC))
                
                dispatch_after(time, dispatch_get_main_queue(), { 
                        self.nextRound()
                })
                
                return
            }
            
            numberOfTaps += 1
        }else{ // GAME OVER
            resetGame()
        }
    }
    
 
    func resetGame() {
        level = 1
        readyForUser = false
        numberOfTaps = 0
        currentItem = 0
        playlist = []
        levelLabel.text = "GAME OVER"
        startGameButton.hidden = false
        disableButtons()
    }
    
    func nextRound() {
    
        level += 1
        levelLabel.text = "Level \(level)"
        readyForUser = false
        numberOfTaps = 0
        currentItem = 0
        disableButtons()
        
        
        let randomNumber = Int(arc4random_uniform(4) + 1)
        playlist.append(randomNumber)
        
        playNextItem()
        
      
        
    }
    
    @IBAction func startGame(sender: AnyObject) {
        levelLabel.text = "Level 1"
        disableButtons()
        let randomNumber = Int(arc4random_uniform(4) + 1)
        playlist.append(randomNumber)
        startGameButton.hidden = true
        playNextItem()
        
        
    }
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        
        if currentItem <= playlist.count - 1 {
            playNextItem()
        }else{
            readyForUser = true
            resetButtonHighlights()
            enableButtons()
        }
        
        
    }
    
    
    func playNextItem () {
        let selectedItem = playlist[currentItem]
        
        switch selectedItem {
        case 1:
            highlightButtonWithTag(1)
            sound1Player.play()
            break
        case 2:
            highlightButtonWithTag(2)
            sound2Player.play()
            break
        case 3:
            highlightButtonWithTag(3)
            sound3Player.play()
            break
        case 4:
            highlightButtonWithTag(4)
            sound4Player.play()
            break
        default:
            break;
        }
        
        currentItem += 1
        
    }
    
    func highlightButtonWithTag (tag:Int) {
        switch tag {
        case 1:
            resetButtonHighlights()
            soundButton[tag - 1].setImage(UIImage(named:"redPressed"), forState: .Normal)
        case 2:
            resetButtonHighlights()
            soundButton[tag - 1].setImage(UIImage(named:"yellowPressed"), forState: .Normal)
        case 3:
            resetButtonHighlights()
            soundButton[tag - 1].setImage(UIImage(named:"bluePressed"), forState: .Normal)
        case 4:
            resetButtonHighlights()
            soundButton[tag - 1].setImage(UIImage(named:"greenPressed"), forState: .Normal)
        default:
            break
        }
    }
    
    func resetButtonHighlights () {
        soundButton[0].setImage(UIImage(named: "red"), forState: .Normal)
        soundButton[1].setImage(UIImage(named: "yellow"), forState: .Normal)
        soundButton[2].setImage(UIImage(named: "blue"), forState: .Normal)
        soundButton[3].setImage(UIImage(named: "green"), forState: .Normal)
    }
    
    
    func disableButtons () {
        for button in soundButton {
            button.userInteractionEnabled = false
        }
    }
    
    func enableButtons () {
        for button in soundButton {
            button.userInteractionEnabled = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

