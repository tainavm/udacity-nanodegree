//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Taina Viriato on 10/12/21.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var btStartRecording: UIButton!
    @IBOutlet weak var lbRecording: UILabel!
    @IBOutlet weak var btStopRecording: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialState()
    }
    
    private func initialState() {
        btStartRecording.isEnabled = true
        btStopRecording.isEnabled = false
        lbRecording.text = "Tap to record"
    }
    
    private func isRecording(value: Bool) {
        if value {
            lbRecording.text = "Recording in progress"
            btStartRecording.isEnabled = false
            btStopRecording.isEnabled = true
        } else {
            lbRecording.text = "Record stoped"
            btStartRecording.isEnabled = true
            btStopRecording.isEnabled = false
        }
    }
    
    @IBAction func starRecord(_ sender: Any) {
        isRecording(value: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options:AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        // Record the audio
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecord(_ sender: Any) {
        isRecording(value: false)
        
        // Stop the audio recorder
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @objc func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not succesful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let effectViewController = segue.destination as! EffectsViewController
            let recordedAudioURL = sender as! URL
            effectViewController.recordedAudioUrl = recordedAudioURL
        }
    }
}
