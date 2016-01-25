//
//  CalculatorBrain.swift
//  01 - Calculator
//
//  Created by DIDIl on 25/1/16.
//  Copyright © 2016年 JD. All rights reserved.
//

import Foundation

class CalculatorBrain
{
  private enum Op{
        case Operand(Double)
        case UnaryOperation(String,Double->Double)
        case BinaryOperation(String,(Double,Double)->Double)
    }
   private var opStack = [Op]()
   private var knowOps = [String:Op]()
    init()
    {
        knowOps["×"] = Op.BinaryOperation("×",*)
        knowOps["÷"] = Op.BinaryOperation("÷"){$1 / $0}
        knowOps["＋"] = Op.BinaryOperation("＋",+)
        knowOps["－"] = Op.BinaryOperation("－"){$1 - $0}
        knowOps["√"] = Op.UnaryOperation("√",sqrt)

     }
   private func evaluate(ops:[Op])->(result:Double?,remainingOps:[Op]){
        if !ops.isEmpty{
            var remainingOps =  ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                
                return (operand,remainingOps)
                
            case .UnaryOperation(_, let operation):
                
                let operantEvaluate = evaluate(remainingOps)
                
                if let operand = operantEvaluate.result{
                    
                    return (operation(operand),operantEvaluate.remainingOps)
                    
                }
                
            case .BinaryOperation(_, let operation):
                
                let op1Evaluation = evaluate(remainingOps)
                
                if  let operand1 = op1Evaluation.result{
                    
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    
                    if let operand2 = op2Evaluation.result {
                        
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                    
                }
            }
        }
        return (nil,ops)
    }

    func evaluate() ->Double? {
        
        let (result,_) = evaluate(opStack)
        
        return result
    }
    
    func pushOperand(operand:Double) ->Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    func performOperation(symbol:String) ->Double?
    {
        if let operation = knowOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
}