//
//  ViewController.swift
//  eggTimer
//
//  Created by F1xTeoNtTsS on 23.08.2021.
//

import UIKit

class ViewController: UIViewController {
    
   private let typesOfEggsArray = ["soft","medium","hard"]
   private let hardness = ["soft":10, "medium":480, "hard":720]
   private var counter = 0
   private var timer = Timer()
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
    
    private let topView = UIView()
    private let bottomView = UIView()
    private let centerView = UIStackView()
    
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
        bottomView.backgroundColor = .cyan
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalTo: self.view.heightAnchor,
                                           multiplier: Constants.multiply).isActive = true
        
        let shadowView = UIView()
        bottomView.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        shadowView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        shadowView.backgroundColor = .white
        
        let shapeLayer = CAShapeLayer()
        let center = CGPoint(x: shadowView.frame.size.width, y: shadowView.frame.size.height)
        let circularPath = UIBezierPath(arcCenter: center, radius: 50, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        print(center)
        shapeLayer.path = circularPath.cgPath
        
        shadowView.layer.addSublayer(shapeLayer)
    }
    
    func addEggButtons(){
        for i in 0...typesOfEggsArray.count - 1 {
            let eggImage = UIImageView(image: UIImage(named: typesOfEggsArray[i]))
            eggImage.translatesAutoresizingMaskIntoConstraints = false
            eggImage.contentMode = .scaleAspectFit
            let button = UIButton()
            button.setTitle(typesOfEggsArray[i], for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitleColor(.systemGray, for: .normal)
            button.addTarget(self, action: #selector(eggButtonPressed), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            let eggView = UIView()
            self.view.addSubview(eggView)
            eggView.addSubview(eggImage)
            eggView.addSubview(button)
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
    }

    @objc func updateCounter(){
        if counter > 0 {
            print("\(counter) seconds")
                    counter -= 1
        } else {
            timer.invalidate()
            titleLabel.text = "DONE"
        }
    }
}

private enum Constants {
    static let multiply: CGFloat = 0.3
}
