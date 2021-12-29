//
//  ViewController.swift
//  AVFoundation Relaxation Audio
//
//  Created by Safa Falaqi on 28/12/2021.
//

import UIKit
import Foundation
import AVFoundation
import SpriteKit
import SCLAlertView
import BAFluidView


class ViewController: UIViewController {
    
    var player:AVPlayer?
    var playerOceanSound:AVPlayer?
   
    var active =  false
    var doubleTabActive =  false
    var updater : CADisplayLink! = nil
    @IBOutlet weak var startPauseButton: UIButton!

    @IBOutlet weak var audioSlider: UISlider!
    
    @IBOutlet weak var waveView: UIView!
    
    let skView = SKView()
    
 
    @IBOutlet weak var background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        let url = URL(string: "https://mp3soundstream.com/wp-content/uploads/2020/09/Flute-Of-Joy-60.mp3")
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            
        
              audioSlider.minimumValue = 0
               
               
               let duration : CMTime = playerItem.asset.duration
               let seconds : Float64 = CMTimeGetSeconds(duration)
               
        audioSlider.maximumValue = Float(seconds)
        audioSlider.isContinuous = true
        
    
        // Show the wave on the page:
        waveView.addSubview(bottomFluidView)
        waveView.addSubview(middleFluidView)
        waveView.addSubview(topFluidView)
        
        //to update progress bar
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
             if self.player!.currentItem?.status == .readyToPlay {
                 let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                 self.audioSlider!.value = Float ( time );
             }
         }
        
        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)

        
//        setupSnowView()
//        initSKScene()
    }
    
//    func setupSnowView(){
//        background.addSubview(skView)
//        skView.translatesAutoresizingMaskIntoConstraints = false
//
//        let top = skView.topAnchor.constraint(equalTo: view.topAnchor , constant: 0)
//        let leading = skView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 0)
//        let trailing = skView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: 0)
//        let bottom = skView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: 0)
//
//        NSLayoutConstraint.activate([top,leading,trailing,bottom])
//
//    }
//    func initSKScene(){
//        let particleScene = ParticleScene(size: CGSize(width: 1080, height: 1920))
//        particleScene.scaleMode = .aspectFill
//        particleScene.backgroundColor = .clear
//        skView.presentScene(particleScene)
//    }
    
    @objc func handleDoubleTap() {
        if doubleTabActive == false {
            doubleTabActive = true
        let url = URL(string: "https://music.wixstatic.com/preview/e7f4d3_381a97b2ac0a479183bcee9c9f237eef.mp3")
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            playerOceanSound = AVPlayer(playerItem: playerItem)
            playerOceanSound!.play()
        }else {
            doubleTabActive = false
            playerOceanSound?.pause()
        }
    }
 
    @IBAction func startPauseMusic(_ sender: UIButton) {
      
        if active == false  {
            player!.volume = 1.0
            player!.play()
            active = true
            startWave()
            waveHasStarted = true
        }else {
            player!.pause()
            active = false
            stopWave()
            waveHasStarted = false
        }
        
      
    }
    
    @IBAction func showInstructions(_ sender: UIBarButtonItem) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        

        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Got it") {
            print("Got it tapped")
        }
    
        alert.showInfo("Tap Screen", subTitle: "double tap or triple tap on the screen for more!\n\n (double tab): \n relaxing ocean sound ",
                          colorStyle: 0xfda800)
        
    }
    @IBAction func changeAudioTime(_ sender: UISlider) {
        
        let seconds : Int64 = Int64(audioSlider.value)
               let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
               
               player!.seek(to: targetTime)
        
        
    }
    

    func startWave() {
        // Start moving the wave.
        print("The waves have started.")
        bottomFluidView.startAnimation()
        middleFluidView.startAnimation()
        topFluidView.startAnimation()
    }
    
    
    func stopWave() {
        // Stop moving the wave.
        print("The waves have stopped.")
        bottomFluidView.stopAnimation()
        middleFluidView.stopAnimation()
        topFluidView.stopAnimation()
    }
    
    
    
    //https://github.com/christopherdavis1/WaveDemo/blob/master/flowing1/ViewController.swift
    var waveHasStarted = false
    var waveHasBeenStopped = true
    
    // Bottom wave locations:
    var bottomWaveFillToHopeful: NSNumber = 0.96
    var bottomWaveFillToStopped: NSNumber = 0.00
    
    // Middle wave locations:
    var middleWaveFillToHopeful: NSNumber = 0.96
    var middleWaveFillToStopped: NSNumber = 0.00
    
    // Top wave locations:
    var topWaveFillToHopeful: NSNumber = 0.95
    var topWaveFillToStopped: NSNumber = 0.00
    
    
    lazy var bottomFluidView: BAFluidView = {
        let wave = BAFluidView(frame: self.view.frame, startElevation: 0.02)
        
        wave.strokeColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        wave.fillColor = UIColor.orange
        wave.maxAmplitude = 4
        wave.minAmplitude = 0
        wave.amplitudeIncrement = 4
        wave.fillDuration = 10.0
        wave.fillAutoReverse = false
        wave.fillRepeatCount = 1
        wave.fill(to: bottomWaveFillToHopeful)
        
        return wave
    }()
    
    lazy var middleFluidView: BAFluidView = {
        let wave = BAFluidView(frame: self.view.frame, startElevation: 0.025)
        
        wave.strokeColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        wave.fillColor = UIColor.orange
        wave.maxAmplitude = 12
        wave.minAmplitude = 2
        wave.amplitudeIncrement = 10
        wave.fillDuration = 10.0
        wave.fillAutoReverse = false
        wave.fillRepeatCount = 1
        wave.fill(to: middleWaveFillToHopeful)
        
        return wave
    }()
    
    lazy var topFluidView: BAFluidView = {
        let wave = BAFluidView(frame: self.view.frame, startElevation: 0.018)

        wave.strokeColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        wave.fillColor = UIColor.orange
        wave.maxAmplitude = 16
        wave.minAmplitude = 4
        wave.amplitudeIncrement = 18
        wave.fillDuration = 10.0
        wave.fillAutoReverse = false
        wave.fillRepeatCount = 1
        wave.fill(to: topWaveFillToHopeful)
        
        return wave
    }()
    
    
    
    
}

