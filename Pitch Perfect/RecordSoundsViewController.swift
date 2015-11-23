//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mohammed Shaikh on 2015-11-17.
//  Copyright © 2015 Zaytun Lab. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UILabel!

    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var toggleRecordingButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    var recordedAudio: RecordedAudio!
    
    var audioRecorder:AVAudioRecorder!
    
    // variables to hold pause and resume images for toggle button
    var pauseImage, resumeImage: UIImage!
    
    // flag used to track recording state
    var isRecording = false
    
    // constant strings for record label
    let tapToRecordText = "Tap to Record"
    let recordingText = "Recording.."
    let recordingPausedText = "Recording Paused"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize UIImage object with pause and resume images
        pauseImage = UIImage(named: "pause_button")
        resumeImage = UIImage(named: "resume_button")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // reset label text to "Tap to Record" and change toggleButton image back to paused state
        resetUI(tapToRecordText, buttonImage: pauseImage)
        
        // change mic image visibility to enabled and hide stop and toggle button
        changeVisibility(true, stopButtonFlag: true, toggleButtonFlag: true)
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
        // change mic image visibility to disabled and show stop and toggle button
        changeVisibility(false, stopButtonFlag: false, toggleButtonFlag: false)
        
        // set label text to "recording"
        resetUI(recordingText, buttonImage: nil)
        
        // Get the path to the Document directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // Set a static name for our recorded audio file and create NSURL with path and name
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Get a AVAudioSession instance and set the category to AVAudioSessionCategoryPlayAndRecord
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // Initialize AVAudioRecorder, make our class delagate to AVAudioRecorder and configure options to start recording
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        // set the flag to true to indicate we entered recording state
        isRecording = true
    }
    
    
    /* This function is called when toggleRecordingButton is clicked.
        It checks the current recording state and pauses or resume the
        audioRecorder accordingly */
    
    @IBAction func toggleRecording(sender: AnyObject) {
        if isRecording {
            audioRecorder.pause()
            isRecording = false
            
            /* If the recording is paused we change record label to "Recording paused" and
                change toggleImageButton to resume state */
            resetUI(recordingPausedText, buttonImage: resumeImage)
        }
        else {
            audioRecorder.record()
            isRecording = true
            
            /* If the recording is resume we change record label to "Recording.." and
                change toggleImageButton to pause state */
            resetUI(recordingText, buttonImage: pauseImage)
        }
    }
    
    
    /* This function is inherited from AVAudioRecorderDelegate. We use the sucessfully flag to
        set our isRecording flag to indicate we finished recording. We perform segue to PlaySoundsViewController
        once the recording is finished */
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            isRecording = false

            // we call our initializer in RecordedAudio class to initialize our object
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            // Something went wrong so change the visiblity and UI back to default
            changeVisibility(true, stopButtonFlag: true, toggleButtonFlag: true)
            resetUI(tapToRecordText, buttonImage: nil)
        }
    }
    
    
    /* This fucntion is called just before we segue and we send our recording data to PlaySoundsViewController */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    /* When the stop button is clicked we invoke this function to stop recording and deactivate the AVAudioSession object */

    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    /* This function changes the visibility of our buttons  */
    
    func changeVisibility(recordButtonFlag: Bool, stopButtonFlag: Bool, toggleButtonFlag: Bool){
        recordButton.enabled = recordButtonFlag
        stopButton.hidden = stopButtonFlag
        toggleRecordingButton.hidden = toggleButtonFlag
    }


    /* This function sets our recordLabel and toggleRecordingButton image which is optional */
    
    func resetUI(recordLabelText: String, buttonImage: UIImage?){
        recordLabel.text = recordLabelText
        if let image = buttonImage{
            // Image is not nil so set toggle button image
            toggleRecordingButton.setImage(image, forState: .Normal)
        }
    }
}

