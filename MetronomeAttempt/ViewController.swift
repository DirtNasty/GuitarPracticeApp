//
//  ViewController.swift
//  MetronomeAttempt
//
//  Created by Kian Salem on 5/12/17.
//  Copyright © 2017 Kian Salem. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var theTimerLabel: UILabel!
    @IBOutlet weak var theBarLabel: UILabel!
    @IBOutlet weak var currentScale: UILabel!
    @IBOutlet weak var nextScale: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var barSegmentedControl: UISegmentedControl!
    @IBOutlet weak var metronomeSpeedLabel: UILabel!
    @IBOutlet weak var tempoRangeLabel: UILabel!
    
    
    // Useless outlets, just to call an isHidden method on.
    @IBOutlet weak var beatLabel: UILabel!
    @IBOutlet weak var barLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var startPracticing: UIButton!
    @IBOutlet weak var stopPracticing: UIButton!
    @IBOutlet weak var metronomeSpeed: UILabel!
    @IBOutlet weak var barsAmount: UILabel!
    
    // Array of every single scale to be used:
    let scales = ["A Blues", "A#/B♭ Blues", "B Blues", "C Blues", "C#/D♭ Blues", "D Blues", "D#/E♭ Blues", "E Blues", "F Blues", "F#/G♭ Blues", "G Blues", "G#/A♭ Blues", "A Major", "A#/B♭ Major", "B Major", "C Major", "C#/D♭ Major", "D Major", "D#/E♭ Major", "E Major", "F Major", "F#/G♭ Major", "G Major", "G#/A♭ Major", "A Minor Pentatonic", "A#/B♭ Minor Pentatonic", "B Minor Pentatonic", "C Minor Pentatonic", "C#/D♭ Minor Pentatonic", "D Minor Pentatonic", "D#/E♭ Minor Pentatonic", "E Minor Pentatonic", "F Minor Pentatonic", "F#/G♭ Minor Pentatonic", "G Minor Pentatonic", "G#/A♭ Minor Pentatonic", "A Minor", "A#/B♭ Minor", "B Minor", "C Minor", "C#/D♭ Minor", "D Minor", "D#/E♭ Minor", "E Minor", "F Minor", "F#/G♭ Minor", "G Minor", "G#/A♭ Minor"]
    
    // Number variables
    var metronomeBeat = 1
    var metronomeBar = 1
    var metronomeSpeedVariable = UserDefaults.standard.integer(forKey: "METRONOMESPEED")
    var timeInterval = UserDefaults.standard.double(forKey: "TIMEINTERVAL")
    var barNumber = UserDefaults.standard.integer(forKey: "NUMBEROFBARS")
    
    // Item variables
    var theTimer = Timer()
    var firstBeatSnap: AVAudioPlayer!
    var otherBeatSnap: AVAudioPlayer!
    
    // Boolean variable to ensure a metronome speed is selected.
    var barsAreSelected = false
    
    // Function called whenever the view is loaded but nothing is displayed on the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable swipe back action to prevent players from going back when adjusting metronome
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // Set up labels
        theTimerLabel.text = String(metronomeBeat)
        theBarLabel.text = String(metronomeBar)
        
        let randomIndex = Int(arc4random_uniform(UInt32(scales.count)))
        nextScale.text = scales[randomIndex]
        barSegmentedControl.selectedSegmentIndex = barNumber - 2
        
        metronomeSpeedLabel.text = String(metronomeSpeedVariable)
        speedSlider.value = Float(metronomeSpeedVariable)
        
        if barSegmentedControl.selectedSegmentIndex == -2 || barNumber == 0 {
            barsAreSelected = false
        }
        
        // Ensures that metronome slider is in correct position upon first time startup
        if metronomeSpeedVariable == 0 {
            UserDefaults.standard.set(60, forKey: "METRONOMESPEED")
            metronomeSpeedVariable = 60
            speedSlider.value = 60
            metronomeSpeedLabel.text = "60"
        }
        
        // If statement that allows the 'barsAreSelected' variable to equate to true if a valid number is selected.
        if barSegmentedControl.selectedSegmentIndex == 0 || barSegmentedControl.selectedSegmentIndex == 1 || barSegmentedControl.selectedSegmentIndex == 2 || barSegmentedControl.selectedSegmentIndex == 3 {
            barsAreSelected = true
        }
     
        // MATH FOR BPM SLIDER:
        // 60 / BpM Variable = Time Interval
        
    }
    
    // Function called when the "Start Practicing" button is pressed
    @IBAction func startTimerPressed(_ sender: Any) {
        
        if barsAreSelected == true {
            
            // isHidden methods
            beatLabel.isHidden = false
            barLabel.isHidden = false
            nextLabel.isHidden = false
            theTimerLabel.isHidden = false
            theBarLabel.isHidden = false
            currentScale.isHidden = false
            nextScale.isHidden = false
            stopPracticing.isHidden = false
            metronomeSpeed.isHidden = true
            speedSlider.isHidden = true
            startPracticing.isHidden = true
            barsAmount.isHidden = true
            barSegmentedControl.isHidden = true
            
            // Implementing timer and metronome
            theTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            let path = Bundle.main.path(forResource: "snap1", ofType: "wav")
            let path2 = Bundle.main.path(forResource: "snap2", ofType: "wav")
            let soundURL = URL(fileURLWithPath: path!)
            let soundURL2 = URL(fileURLWithPath: path2!)
            
            // Error handling and assignment of the first beat's snap.
            do {
                try firstBeatSnap = AVAudioPlayer(contentsOf: soundURL)
                firstBeatSnap.prepareToPlay()
            } catch let err as NSError {
                print("ERROR: \(err.debugDescription)")
            }
            
            // Error handling and assignment of every other beat's snap.
            do {
                try otherBeatSnap = AVAudioPlayer(contentsOf: soundURL2)
                otherBeatSnap.prepareToPlay()
            } catch let err as NSError {
                print("ERROR: \(err.debugDescription)")
            }
            
            firstBeatSnap.play()
            
            // Else statement to perform the appropriate alert popup if necessary things are unselected.
        } else {
            
            let title = UIAlertAction(title: "OK", style: .default, handler: nil)
            let barsAlert = UIAlertController(title: "Error", message: "You must choose a number of bars before starting.", preferredStyle: .alert)
            
            if barsAreSelected == false {
                barsAlert.addAction(title)
                self.present(barsAlert, animated: true, completion: nil)
            }
        }
    }
    
    // Function called when the "Stop Timer" button is pressed
    @IBAction func stopTimerPressed(_ sender: Any) {
        stopTimer()
    }
    
    // All the things that need to be changed when you are finished practicing, "Stop Practicing" button.
    func stopTimer() {
        
        // Stops timer
        theTimer.invalidate()
        
        // Resets beat & bar to 1.
        metronomeBeat = 1
        metronomeBar = 1
        theTimerLabel.text = "\(metronomeBeat)"
        theBarLabel.text = "\(metronomeBar)"
        currentScale.text = "Get Ready!"
        
        // Hide and unhide the appropriate items.
        beatLabel.isHidden = true
        barLabel.isHidden = true
        nextLabel.isHidden = true
        theTimerLabel.isHidden = true
        theBarLabel.isHidden = true
        currentScale.isHidden = false
        nextScale.isHidden = true
        stopPracticing.isHidden = true
        metronomeSpeed.isHidden = false
        speedSlider.isHidden = false
        startPracticing.isHidden = false
        barsAmount.isHidden = false
        barSegmentedControl.isHidden = false
    }
    
    // Safety function to stop timer; is called everytime the view is about to disappear.
    override func viewWillDisappear(_ animated: Bool) {
        theTimer.invalidate()
    }
    
    // Function called when the UIPicker for the amount of bars before a scale change is switched
    @IBAction func barPickerAction(_ sender: Any) {
        if barSegmentedControl.selectedSegmentIndex == 0 {
            UserDefaults.standard.set(2, forKey: "NUMBEROFBARS")
            barsAreSelected = true
        } else if barSegmentedControl.selectedSegmentIndex == 1 {
            UserDefaults.standard.set(3, forKey: "NUMBEROFBARS")
            barsAreSelected = true
        } else if barSegmentedControl.selectedSegmentIndex == 2 {
            UserDefaults.standard.set(4, forKey: "NUMBEROFBARS")
            barsAreSelected = true
        } else if barSegmentedControl.selectedSegmentIndex == 3 {
            UserDefaults.standard.set(5, forKey: "NUMBEROFBARS")
            barsAreSelected = true
        }
    }
    
    // Function called when the UISlider for the metronome's speed is moved.
    @IBAction func speedSliderMoved(_ sender: Any) {
        
        // Set value into core data
        UserDefaults.standard.set(Int(speedSlider.value), forKey: "METRONOMESPEED")
        // Updates metronome speed variable as slider is moved.
        metronomeSpeedVariable = Int(speedSlider.value)
        // Updates the metronome speed label's text
        metronomeSpeedLabel.text = String(metronomeSpeedVariable)
        
        // Switch statement to determine the tempo range
        switch metronomeSpeedVariable {
        case 40...49:
            tempoRangeLabel.text = "Grave"
        case 50...54:
            tempoRangeLabel.text = "Largo"
        case 55...59:
            tempoRangeLabel.text = "Larghetto"
        case 60...69:
            tempoRangeLabel.text = "Adagio"
        case 70...84:
            tempoRangeLabel.text = "Andante"
        case 85...99:
            tempoRangeLabel.text = "Moderato"
        case 100...114:
            tempoRangeLabel.text = "Allegretto"
        case 115...139:
            tempoRangeLabel.text = "Allegro"
        case 140...149:
            tempoRangeLabel.text = "Vivace"
        case 150...169:
            tempoRangeLabel.text = "Presto"
        case 170...200:
            tempoRangeLabel.text = "Prestissimo"
        default:
            tempoRangeLabel.text = "Adagio"
        }
        
        // Set the timeInterval variable's value
        //var convertedInterval = 60 / timeInterval
        //UserDefaults.standard.set(convertedInterval, forKey: "TIMEINTERVAL")
        
    }
    
    // Function called every time interval that happens within the "theTimer: Timer" variable
    @objc func timerAction() {
        metronomeBeat += 1
        theTimerLabel.text = "\(metronomeBeat)"
        
        // Resets the metronome back to its first beat after the last beat has been reached.
        if metronomeBeat == 5 {
            metronomeBeat = 1
            firstBeatSnap.play()
            metronomeBar += 1
            theBarLabel.text = "\(metronomeBar)"
            // Called everytime the bar is reset it 1 and the new scale is displayed.
            if metronomeBar == UserDefaults.standard.integer(forKey: "NUMBEROFBARS") {
                metronomeBar = 1
                theBarLabel.text = "\(metronomeBar)"
                let randomIndex = Int(arc4random_uniform(UInt32(scales.count)))
                currentScale.text = nextScale.text
                nextScale.text = scales[randomIndex]
            }
            theTimerLabel.text = "\(metronomeBeat)"
        } else {
            otherBeatSnap.play()
        }
        
    }
}
