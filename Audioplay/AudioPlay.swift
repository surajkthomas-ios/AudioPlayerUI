//
//  AudioPlay.swift
//  scribeRyte
//
//  Created by suraj thomas on 22/06/21.
//

import UIKit
import AVFoundation // Import the AVFoundation






final
class AudioPlay: UIView {

    @IBOutlet weak var backgroundview: UIView!
    
    private static let NIB_NAME = "AudioPlay"

    // Formatting time for display
    let timeFormatter = NumberFormatter()
    
    var audioPlayer: AVAudioPlayer?     // holds an audio player instance. This is an optional!
    var audioTimer: Timer?            // holds a timer instance
    var isDraggingTimeSlider = false    // Keep track of when the time slide is being dragged
    
    var isPlaying = false {             // keep track of when the player is playing
      didSet {                        // This is a computed property. Changing the value
        setButtonState()            // invokes the didSet block
        playPauseAudio()
      }
    }
    
    
    // MARK: IBOutlets
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var timeSlider: UISlider!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet private var view: UIView!

    
    // MARK: IBActions
    
    @IBAction func playButtonTapped(sender: UIButton) {
      // Set the didSet block above! Setting thi[]
        isPlaying = !isPlaying
    }
    
    // Update time when dragging the slider
    @IBAction func timeSliderChanged(sender: UISlider) {
      // Working on this
      // TODO: Implement Time Slider
      guard let audioPlayer = audioPlayer else {
        return
      }
      
      audioPlayer.currentTime = audioPlayer.duration * Double(sender.value)
    }
    
    // The time slider is tricky since we want it to update while the player is playing
    // but it can't be updated while we dragging it!
    @IBAction func timeSliderTouchDown(sender: UISlider) {
      isDraggingTimeSlider = true
    }
    
    @IBAction func timeSliderTouchUp(sender: UISlider) {
      isDraggingTimeSlider = false
    }
    
    @IBAction func timeSliderTouchUpOutside(sender: UISlider) {
      isDraggingTimeSlider = false
    }
    
    
    
    
    
    
    
    
    func setButtonState() {
      // When the play button is tapped the text changes
      // TODO: Use the enum below for button and player states
      if isPlaying {
//        playButton.setTitle("Pause", for: .normal)
        playButton.setImage(UIImage(named: "pauseBlack"), for: .normal)

      } else {
//        playButton.setTitle("Play", for: .normal)
        
        playButton.setImage(UIImage(named: "PlayBlack"), for: .normal)

      }
    }
    
    func playPauseAudio() {
      // audioPlayer is optional use guard to check it before using it.
      guard let audioPlayer = audioPlayer else {
        return
      }
      
      // Check is playing then play or pause
      if isPlaying {
        audioPlayer.play()
        
      } else {
        audioPlayer.pause()
      }
    }
    
    
    
    func queueSound() {
      // Use this methid to load up the sound.
      let contentURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "sweet", ofType: "mp3")!)
      // TODO: Use catch here and check for errors.
      audioPlayer = try! AVAudioPlayer(contentsOf: contentURL as URL)
    }
    
    
    func makeTimer() {
      // This function sets up the timer.
      if audioTimer != nil {
        audioTimer!.invalidate()
      }
      
      // audioTimer = Timer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.onTimer(_:)), userInfo: nil, repeats: true)
      
      audioTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func onTimer(timer: Timer) {
      // Check the audioPlayer, it's optinal remember. Get the current time and duration
      guard let currentTime = audioPlayer?.currentTime, let duration = audioPlayer?.duration else {
        return
      }
      
      // Calculate minutes, seconds, and percent completed
      let mins = currentTime / 60
      // let secs = currentTime % 60
      let secs = currentTime.truncatingRemainder(dividingBy: 60)
      let percentCompleted = currentTime / duration
      
      // Use the number formatter, it might return nil so guard
      //    guard let minsStr = timeFormatter.stringFromNumber(NSNumber(mins)), let secsStr = timeFormatter.stringFromNumber(NSNumber(secs)) else {
      //      return
      //    }
      
      guard let minsStr = timeFormatter.string(from: NSNumber(value: mins)), let secsStr = timeFormatter.string(from: NSNumber(value: secs)) else {
        return
      }
      
      
      // Everything is cool so update the timeLabel and progress bar
      timeLabel.text = "\(minsStr):\(secsStr)"
      // Check that we aren't dragging the time slider before updating it
      if !isDraggingTimeSlider {
        timeSlider.value = Float(percentCompleted)
      }
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    // TODO: Use Enum to manage play state
    enum PlayState: String {
      case Play = "Play"
      case Puase = "Pause"
    }
    
    
    override func awakeFromNib() {
        initWithNib()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(AudioPlay.NIB_NAME, owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        setupLayout()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        
        // Load the sound and set up the timer.
        queueSound()
        makeTimer()
    }
    
    private func setupLayout() {
       // self.view.backgroundColor = UIColor.clear
        self.backgroundview.layer.cornerRadius = 10.0
        self.backgroundview.layer.masksToBounds = true
        self.backgroundview.layer.borderColor = UIColor.purple.cgColor
        self.backgroundview.layer.borderWidth = 2.0
        
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
    
    
    
}
