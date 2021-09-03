//
//  ViewController.swift
//  eggTimer
//
//  Created by F1xTeoNtTsS on 23.08.2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private let typesOfEggsArray = ["soft","medium","hard"]
    private let hardness = ["soft":300, "medium":480, "hard":720]
    private var counter = 0
    private var player = AVAudioPlayer()
    private var timer = Timer()
    private let timerLabel = UILabel()
    private let shapeLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    
    private let topView = UIView()
    private let centerView = UIStackView()
    private let bottomView = UIView()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "How do you like your eggs?"
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = .systemGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5655800104, green: 0.8488342762, blue: 0.9164006114, alpha: 1)
        addSubViewsOnViewController()
        setViews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    // add circle in center of bottomView
        self.animationCircle()
    }
    
    func addSubViewsOnViewController(){
        self.view.addSubview(topView)
        self.view.addSubview(centerView)
        self.view.addSubview(bottomView)
    }
    
    func setViews(){
        configureTopView()
        configureCenterView()
        configureBottomView()
    }
    
    func configureTopView(){
        topView.addSubview(titleLabel)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        topView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: Constants.multiply).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
    }
    
    func configureCenterView(){
        centerView.axis = .horizontal
        centerView.spacing = 3
        centerView.distribution = .fillEqually
        
        centerView.translatesAutoresizingMaskIntoConstraints = false
        centerView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        centerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        centerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        centerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        
        addEggButtons()
    }
    
    func configureBottomView(){
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalTo: self.view.heightAnchor,
                                           multiplier: Constants.multiply).isActive = true
        
        timerLabel.text = ""
        timerLabel.font = UIFont.systemFont(ofSize: 30)
        timerLabel.textColor = .systemGray
        timerLabel.textAlignment = .center
        timerLabel.numberOfLines = 0
        bottomView.addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        timerLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
    }
    
    func addEggButtons(){
        for i in 0...typesOfEggsArray.count - 1 {
// create egg images
            let eggImage = UIImageView(image: UIImage(named: typesOfEggsArray[i]))
            eggImage.translatesAutoresizingMaskIntoConstraints = false
            eggImage.contentMode = .scaleAspectFit
// create buttons for images
            let button = UIButton()
            button.setTitle(typesOfEggsArray[i], for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitleColor(.systemGray, for: .normal)
            button.addTarget(self, action: #selector(eggButtonPressed), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
// create subviews for images and buttons
            let eggView = UIView()
            self.view.addSubview(eggView)
            eggView.addSubview(eggImage)
            eggView.addSubview(button)
// set constraints
            eggView.translatesAutoresizingMaskIntoConstraints = false
            eggImage.centerXAnchor.constraint(equalTo: eggView.centerXAnchor).isActive = true
            eggImage.centerYAnchor.constraint(equalTo: eggView.centerYAnchor).isActive = true
            eggImage.heightAnchor.constraint(equalTo: eggView.heightAnchor, multiplier: 0.4).isActive = true
            
            button.centerXAnchor.constraint(equalTo: eggImage.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: eggImage.centerYAnchor).isActive = true
            centerView.addArrangedSubview(eggView)
        }
    }
    
    @objc func eggButtonPressed(_ sender: UIButton){
        timer.invalidate()
        guard let senderTitle = sender.currentTitle else { return }
        guard let secondsForCooking = hardness[senderTitle] else { return }
        counter = secondsForCooking
        timerLabel.text = "\(counter)"
        animationTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter(){
        if counter > 1 {
            counter -= 1
            timerLabel.text = "\(counter)"
        } else if counter == 1 {
            timer.invalidate()
            timerLabel.text = "DONE"
            titleLabel.text = "Enjoy your meal!"
            alarmSound()
        }
    }
    
    private func alarmSound(){
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func animationTimer(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(counter)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    private func animationCircle(){
        let center = CGPoint(x: bottomView.frame.width / 2, y: bottomView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(arcCenter: center, radius: 50,
                                        startAngle: startAngle, endAngle: endAngle, clockwise: false)
        trackLayer.path = circularPath.cgPath
        shapeLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 1
        
        bottomView.layer.addSublayer(trackLayer)
        bottomView.layer.addSublayer(shapeLayer)
    }
}

private enum Constants {
    static let multiply: CGFloat = 0.3
}
