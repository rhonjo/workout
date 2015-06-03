//
//  ViewController.swift
//  workout
//
//  Created by Ryota Honjo on 5/5/15.
//  Copyright (c) 2015 Ryota Honjo. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var stepCount: UILabel!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var flightCount: UILabel!
    @IBOutlet weak var multiplier: UILabel!
    
    var steps = 0
    var total: Double = 0
    var mult = 1.0
    var flights = 0
    var distance = 0
    var timeStart: NSDate? = nil
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        steps = 0
        total = 0
        mult = 1
        flights = 0
        distance = 0
        timeStart = nil
        self.updateUI()
        pedometer.stopPedometerUpdates();
    }
    @IBAction func startButtonPressed(sender: UIButton) {
        println("pressed")
        self.timeStart = NSDate()
        println("start = \(self.timeStart)")
        // start takes in a date and a closure
        pedometer.startPedometerUpdatesFromDate(NSDate(), withHandler: { data, error in
//            println("Update \(data.numberOfSteps)")
//            println("Distance = \(data.distance)")
            // dispatch async
            dispatch_async(dispatch_get_main_queue()) {
                self.steps = Int(data.numberOfSteps)
                self.flights = Int(data.floorsAscended) + Int(data.floorsDescended)
                self.distance = Int(data.distance)
                self.updateScore()
                self.updateUI()
            }
        })
    }
    
    let pedometer: CMPedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepCount.text = steps.description
        totalScore.text = total.description
        flightCount.text = flights.description
        multiplier.text = mult.description + "x"
    }
    func updateScore() {
        var intervalCalculator = NSDate.timeIntervalSinceDate(timeStart!)
        var interval = intervalCalculator(NSDate())
        interval *= -1
        println("Interval = \(interval)")
        mult = Double(distance) / interval
        println("Mult = \(mult)")
        total = Double(steps + flights*10)*mult
    }
    func updateUI() {
        multiplier.text = String(format: "%.2f", mult) + "x"
        totalScore.text = String(format: "%.2f", total)
        stepCount.text = String(stringInterpolationSegment: steps)
        flightCount.text = flights.description
    }
    
}


