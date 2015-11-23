//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mohammed Shaikh on 2015-11-18.
//  Copyright © 2015 Zaytun Lab. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var stopPlaybackButton: UIButton!
    
    var receivedAudio: RecordedAudio!
    
    var audioPlayer: AVAudioPlayer!
    
    var audioEngine: AVAudioEngine!
    
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize AVAudioPlayer, make our class delegate of AVAudioPlayerDelegate and enable rate property
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.delegate = self
        audioPlayer.enableRate = true
        
        // intialize AVAudioEngine and AVAudioFile object
        audioEngine = AVAudioEngine()
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        // hide the stop button when the view is first loaded
        changeStopButtonVisiblity(false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        /* We reset the audio when the view is about to disappear due to a bug
            where the audio continues playing in background even after leaving PlaySoundsVC
            in case of AudioEngine */
        resetAudio()
    }

    /* This function is invoked when slow audio button is clicked and slows down the playback rate */
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableSpeed(0.5)
    }

    /* This function is invoked when fast audio button is clicked and increases the playback rate */
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableSpeed(1.5)
    }
    
    
    /* This function sets the playback rate of AVAudioPlayer to a value and plays the audio */
    func playAudioWithVariableSpeed(speed : Float){
        // reset the audio player
        resetAudio()
        
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        // show the stop button 
        changeStopButtonVisiblity(true)
    }
    
    /* This function is invoked when chipmunk audio button is clicked and changes the pitch of audio */
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    /* This function is invoked when dark vader audio button is clicked and changes the pitch of audio */
    @IBAction func playDarkVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    /* This function initialize a AVAudioUnitTimePitch object and sets the pitch value. It calls
        configureAudioEngine function to configure audio engine settings */
    
    func playAudioWithVariablePitch(pitch: Float){
        let pitchNode = AVAudioUnitTimePitch()
        pitchNode.pitch = pitch

        configureAudioEngine(pitchNode)
    }
    
    
    /* This function is invoked when reverb audio button is clicked. It initializes a AVAudioUnitTimePitch 
        object and sets the properties for a reverb effect. It calls configureAudioEngine function to configure
        audio engine settings */
    
    @IBAction func playReverbAudio(sender: UIButton) {
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbNode.wetDryMix = 60
        
        configureAudioEngine(reverbNode)
    }
    
    
    /* This function is invoked when echo audio button is clicked. It initializes a AVAudioUnitDelay
        object and sets the properties for a echo effect. It calls configureAudioEngine function to configure
        audio engine settings */
    
    @IBAction func playEchoAudio(sender: UIButton) {
        let echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(0.3)
        
        configureAudioEngine(echoNode)
    }
    
    
    /* This function takes an AVAudioNode. It configures the audioEngine by initializing an AVAudioPlayerNode object.
        It attaches the AVAudioPlayerNode and AVAudioNode to the engine. It connects both nodes and playbacks the
        audio file */
    
    func configureAudioEngine(effectNode: AVAudioNode){
        resetAudio()
        changeStopButtonVisiblity(true)
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effectNode)
        
        audioEngine.connect(audioPlayerNode, to: effectNode, format: nil)
        audioEngine.connect(effectNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
            
                /* This block of code is invoked when the file has completely played or the audioPlayerNode 
                    is stopped We use this callback handler to disable the visibility of our stop button*/
                self.changeStopButtonVisiblity(false)
        })
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    
    /* This function is inherited from AVAudioPlayerDelegate. We use the sucessfully flag to hide
        the visibility of the stopButton */
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if (flag){
            changeStopButtonVisiblity(false)
        }
    }
    
    
    /* This function is invoked when stopButton is clicked. It stops audio playback and hides
        the visibility of the stopButton */
    @IBAction func stopButton(sender: UIButton) {
        resetAudio()
        changeStopButtonVisiblity(false)
    }

    /* This function stops both audioPlayer and audioEngine */
    func resetAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }

    /* This function changes the stopButton visibility. True value means button is enabled while false means disabled */
    func changeStopButtonVisiblity(flag: Bool){
        stopPlaybackButton.enabled = flag
    }
}
