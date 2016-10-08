//
//  ViewController.swift
//  FinalMockup
//
//  Created by Colin Mackenzie on 07/10/2016.
//  Copyright © 2016 cdmackenzie. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var mainStackView        = UIStackView()
    var mapView              = MKMapView()
    var bottomStackView      = UIStackView()
    var bottomRightStackView = UIStackView()
    var bottomLeftStackView  = UIStackView()
    
    var mapSegment           = UISegmentedControl()
    var plusButton           = UIButton(type: .roundedRect)
    var minusButton          = UIButton(type: .roundedRect)
    var questionLabel        = UILabel()
    var flagButton           = UIButton(type: .roundedRect)
    var answerLabel          = UILabel()
    var countdownLabel       = UILabel()
    var scoreLabel           = UILabel()
    var playButton           = UIButton(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupStackViews()
    }

    func setupStackViews()
    {
        /*
         The vertical stackview for our viewcontroller consists of:
         1. The mapView ( i.e. Top part of screen)
         2. The bottom stackview
         */
        setupTopView()
        setupBottomView()
        
        mainStackView.axis         = .vertical
        mainStackView.alignment    = .fill
        mainStackView.distribution = .fill
        mainStackView.spacing      = 10.0
        
        mainStackView.addArrangedSubview(mapView)
        mainStackView.addArrangedSubview(bottomStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mainStackView)
        
        //autolayout the stack view
        let viewsDictionary = ["stackView":mainStackView]
        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat:
            "H:|-20-[stackView]-20-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(withVisualFormat:
            "V:|-20-[stackView]-20-|", //vertical constraint 20 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        self.view.addConstraints(stackView_H)
        self.view.addConstraints(stackView_V)
    }
    
    func setupTopView()
    {
        /*
         The Top View is a MapView also containing:
         1. Segment Control for mapView
         2. Zoom  in button
         3. Zoom out button
         */
        let title0 = NSLocalizedString("Stand",  comment: "Abbreviation for Standard map")
        let title1 = NSLocalizedString("Hybrid", comment: "Abbreviation for Hybrid map")
        let title2 = NSLocalizedString("Sat",    comment: "Abbreviation for Satellite map")
        mapSegment.insertSegment(withTitle: title0, at: 0, animated: true)
        mapSegment.insertSegment(withTitle: title1, at: 1, animated: true)
        mapSegment.insertSegment(withTitle: title2, at: 2, animated: true)
        mapSegment.addTarget(self, action: #selector(mapSegmentChanged), for: .valueChanged)
        mapSegment.frame = CGRect(x: 20, y: 20, width: 200, height: 20)
        
        plusButton.backgroundColor = UIColor.clear
        let plusString = NSLocalizedString("+",comment:"map zoom in")
        plusButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        plusButton.setTitle(plusString, for: .normal)
        plusButton.setTitleColor(UIColor.black, for: .normal)
        plusButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        plusButton.frame = CGRect(x: 20, y: 60, width: 40, height: 40)
        
        minusButton.backgroundColor = UIColor.clear
        let minusString = NSLocalizedString("-",comment:"map zoom out")
        minusButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        minusButton.setTitle(minusString, for: .normal)
        minusButton.setTitleColor(UIColor.black, for: .normal)
        minusButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        minusButton.frame = CGRect(x: 20, y: 90, width: 40, height: 40)
        
        mapView.addSubview(mapSegment)
        mapView.addSubview(plusButton)
        mapView.addSubview(minusButton)
    }
    func setupBottomView()
    {
        /*
         The bottom horizontal stackview consists of:
         1. The bottom left stackview
         2. The bottom right stackview
         */
        setupBottomLeftView()
        setupBottomRightView()
        
        bottomStackView.axis         = .horizontal
        bottomStackView.alignment    = .fill
        bottomStackView.distribution = .fillProportionally
        bottomStackView.spacing      = 40.0
        
        bottomStackView.addArrangedSubview(bottomLeftStackView)
        bottomStackView.addArrangedSubview(bottomRightStackView)
    }
    func setupBottomLeftView() {
        /*
         Bottom left vertical stackview consists of
         1. Label asking you to find a city.
         2. Flag of the country.
         3. Label congratulating you when you find city.
         */
        questionLabel.backgroundColor = UIColor.clear
        questionLabel.textColor       = UIColor.black
        questionLabel.textAlignment   = .center
        questionLabel.text            = NSLocalizedString("Find the capital of the UK", comment: "label top")
        questionLabel.numberOfLines   = 2
        questionLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 60)
        
        flagButton.backgroundColor = UIColor.lightGray
        let image = UIImage(named: "uk.png")
        flagButton.setBackgroundImage(image, for: .normal)
        flagButton.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        flagButton.frame = CGRect(x: 0, y: 0, width: 120, height: 60)
        
        answerLabel.backgroundColor = UIColor.clear
        answerLabel.textColor       = UIColor.black
        answerLabel.textAlignment   = .center
        answerLabel.text            = NSLocalizedString("Congrats you found London, the Capital of UK", comment: "label bottom")
        answerLabel.numberOfLines   = 2
        answerLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 60)
        
        bottomLeftStackView.axis         = .vertical
        bottomLeftStackView.alignment    = .leading
        bottomLeftStackView.distribution = .fillProportionally
        bottomLeftStackView.spacing      = 5.0
        
        bottomLeftStackView.addArrangedSubview(questionLabel)
        bottomLeftStackView.addArrangedSubview(flagButton)
        bottomLeftStackView.addArrangedSubview(answerLabel)
    }
    func setupBottomRightView() {
        /*
         Bottom right vertical stackview consists of:
         1. Game countdown timer label
         2. Score label
         3. Start button
         */
        countdownLabel.backgroundColor = UIColor.clear
        countdownLabel.textColor       = UIColor.black
        countdownLabel.textAlignment   = .center
        countdownLabel.text            = NSLocalizedString("4:59", comment: "game countdown")
        
        scoreLabel.backgroundColor = UIColor.clear
        scoreLabel.textColor       = UIColor.black
        scoreLabel.textAlignment   = .center
        scoreLabel.text            = NSLocalizedString("score:  10", comment: "game score")
        
        playButton.backgroundColor = UIColor.lightGray
        let buttonString = NSLocalizedString("Start",comment:"Play the game")
        playButton.setTitle(buttonString, for: .normal)
        playButton.setTitleColor(UIColor.black, for: .normal)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        playButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        playButton.tintColor = UIColor.white
        
        bottomRightStackView.axis         = .vertical
        bottomRightStackView.alignment    = .trailing
        bottomRightStackView.distribution = .fillProportionally
        bottomRightStackView.spacing      = 10.0
        
        bottomRightStackView.addArrangedSubview(countdownLabel)
        bottomRightStackView.addArrangedSubview(scoreLabel)
        bottomRightStackView.addArrangedSubview(playButton)
    }
    /*
     Actions for buttons etc.
     */
    func playTapped(sender: UIButton!)
    {
        // Start the Game
        print("playTapped")
    }
    
    func flagTapped(sender: UIButton!)
    {
        // switch to another country
        print("flagTapped")
    }
    
    func mapSegmentChanged(sender: UISegmentedControl!)
    {
        // change the type of mapView
        print("segmentControl")
    }
    
    func zoomIn(sender: UIButton!)
    {
        print("zoomIn")
    }
    
    func zoomOut(sender: UIButton!)
    {
        print("zoomOut")
    }


}

