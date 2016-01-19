//
//  ViewController.swift
//  My Little Pet
//
//  Created by Gregory DeNinno on 1/17/16.
//  Copyright © 2016 SCDE. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heartImage: DragImg!
    @IBOutlet weak var foodImage: DragImg!
    
    @IBOutlet var lifeOneImage: UIImageView!
    @IBOutlet var lifeTwoImage: UIImageView!
    @IBOutlet var lifeThreeImage: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1
    let MAX_LIFE = 3
    
    var penalties = 0
    var timer: NSTimer!
    
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImage.dropTarget = monsterImg
        heartImage.dropTarget = monsterImg
        
        lifeOneImage.alpha = DIM_ALPHA
        lifeTwoImage.alpha = DIM_ALPHA
        lifeThreeImage.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            sfxHeart.prepareToPlay()
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState () {
        
        if !monsterHappy {
            
            penalties++
            
            sfxSkull.play()
            
            if penalties == 1 {
                lifeOneImage.alpha = OPAQUE
            }else if penalties == 2 {
                lifeTwoImage.alpha = OPAQUE
            }else if penalties >= 3 {
                lifeThreeImage.alpha = OPAQUE
            }else {
                lifeOneImage.alpha = DIM_ALPHA
                lifeTwoImage.alpha = DIM_ALPHA
                lifeThreeImage.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_LIFE {
                gameOver()
            }
        }
        
        let rand  = arc4random_uniform(2)
        
        if rand == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
        } else {
            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
            
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
    }
    
}

