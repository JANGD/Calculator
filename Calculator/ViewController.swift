//
//  ViewController.swift
//  01 - Calculator
//
//  Created by DIDIl on 24/1/16.
//  Copyright © 2016年 JD. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var UserIsInMiddleOfTypeANumber:Bool = false
    var brain = CalculatorBrain()
    @IBOutlet weak var display: UILabel!
    
    @IBAction func digit(sender: UIButton) {
        let digit = sender.currentTitle
        if UserIsInMiddleOfTypeANumber {
            display.text = (display.text)! + digit!
        }else
        {
            display.text = digit
            UserIsInMiddleOfTypeANumber = true
        }
        
    }
    var operandStack = Array<Double>()
    @IBAction func enter() {
        UserIsInMiddleOfTypeANumber = false
        if let result = brain.pushOperand(operand: displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
    }
    //计算
    @IBAction func operate(sender: UIButton) {
        if UserIsInMiddleOfTypeANumber {
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(symbol: operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
        
    }
    func performOperation1(operation1:(Double,Double)->Double){
        if operandStack.count >= 2 {
            displayValue = operation1(operandStack.removeLast(),operandStack.removeLast())
        }
    }
    func performOperation2(operation2:(Double)->Double){
        if operandStack.count >= 1{
            displayValue = operation2(operandStack.removeLast())
            enter()
        }
    }
    var displayValue:Double{
        get{
            return NumberFormatter().number(from: display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            UserIsInMiddleOfTypeANumber = false
        }
    }
}

