

import UIKit
import AudioToolbox
enum timerState {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var timerView: UILabel!
    @IBOutlet var datePickerView: UIDatePicker!
    @IBOutlet var okBtn: UIButton!
    @IBOutlet var tomatoImage: UIImageView!
    @IBOutlet var cancelBtn: UIButton!
   // var timer: Timer!
    var timer: DispatchSourceTimer?
    var state: timerState = .end
    var duration = 60
    var currentSeconds = 0
   // var time: timeValue = .init(totalSecond: 0, hour: 0, min: 0, second: 0)
    //var pause = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButtno()

    }
    
    func configureToggleButtno() {
        self.okBtn.setTitle("시작", for: .normal)
        self.okBtn.setTitle("일시정지", for: .selected)
    }
   
    
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else {return}
                self.currentSeconds -= 1
                let hour = self.currentSeconds / 3600
                let min = (self.currentSeconds % 3600) / 60
                let second = (self.currentSeconds % 3600) % 60
                self.timerView.text = String(format: "%02d:%02d:%02d", hour,min,second)
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                debugPrint(self.progressView.progress)
                UIImageView.animate(withDuration: 0.5,delay: 0 ,animations: {
                    self.tomatoImage.transform = CGAffineTransform(rotationAngle: .pi)
                })
                UIImageView.animate(withDuration: 0.5,delay: 0.5 ,animations: {
                    self.tomatoImage.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                if self.currentSeconds <= 0 {
                    //타이머 종료
                    AudioServicesPlaySystemSound(1005)
                    self.stopTimer()
                    
                }
            })
            self.timer?.resume()
        }
    }
    func stopTimer() {
        if self.state == .pause {
            self.timer?.resume()
        }
        self.state = .end
        //self.okBtn.setTitle("확인", for: .normal)
        UIView.animate(withDuration: 0.5, animations: {
            self.timerView.alpha = 0
            self.progressView.alpha = 0
            self.datePickerView.alpha = 1
            self.tomatoImage.transform = .identity
        })
        self.cancelBtn.isEnabled = false
        self.datePickerView.isHidden = false
        self.okBtn.isSelected = false
        //  timer.invalidate()
        //  timer = nil
        self.timer?.cancel()
        self.timer = nil
       
    }
    
    @IBAction func tapCancelBtn(_ sender: UIButton) {
        switch self.state {
        case .start, .pause:
            self.stopTimer()
        default:
            break
        }
      
        
    }
    
    @IBAction func tapOkBtn(_ sender: UIButton) {
        self.duration = Int(self.datePickerView.countDownDuration)
        switch self.state {
        case .end:
            self.currentSeconds = self.duration
            self.state = .start
            //self.time.totalSecond = Int(self.datePickerView.countDownDuration)
          
            UIView.animate(withDuration: 0.5, animations: {
                self.timerView.alpha = 1
                self.progressView.alpha = 1
                self.datePickerView.alpha = 0
            })
            self.cancelBtn.isEnabled = true
            //self.datePickerView.isHidden = true
            self.okBtn.isSelected = true
            self.startTimer()
            // self.okBtn.setTitle("일시정지", for: .normal)
            // self.generateTimer()
        case .start:
            self.state = .pause
            self.okBtn.isSelected = false
            self.tomatoImage.transform = .identity
            self.timer?.suspend()
           // self.timer.invalidate()
           // self.okBtn.setTitle("재개", for: .normal)
        default:
            self.state = .start
            self.okBtn.isSelected = true
            self.timer?.resume()
           // self.generateTimer()
            //self.okBtn.setTitle("일시정지", for: .normal)
        }
      
    }
//    @objc func startTimer() {
//        self.time.totalSecond -= 1
//        var timeStr = "00:00:00"
//        print("\(self.time.totalSecond)")
//        self.timerView.text = String(timeStr)
//    }
    
    func viewState() {
    }
//    private func generateTimer() {
//        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
//    }
}

