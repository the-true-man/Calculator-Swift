//
//  ContentView.swift
//  Calculator iOS
//
//  Created by Евгений Михайлов on 10.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State var result = "0"
    @State var num1: Double? = nil
    @State var num2: Double? = nil
    @State var isEqual: Bool = false
    @State var isOperator: Bool = false
    @State var binaryOperator: String? = nil
    @State var history = ""
    private let maxCharacters = 24
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    let allButton = [["C", "/"],["7", "8", "9", "*"], ["4", "5", "6", "-"], ["1", "2", "3", "+"], ["0", ".", "="]]
    var body: some View {
        Spacer()
        Grid(alignment: .bottom, verticalSpacing: 10) {
            GridRow {
                Text(history)
                    .font(.system(size: 30 , weight: .regular, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .gridCellColumns(4)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                    .foregroundColor(.gray)
            }
            GridRow() {
                Text(result)
                    .onChange(of: result) { newValue in
                        if newValue.count > maxCharacters {
                            result = String(newValue.prefix(maxCharacters))
                        }
                        if result.lowercased().contains("inf") {
                            clearAll()
                        }
                    }
                    .font(.system(size: 50, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .gridCellColumns(4)
                    .minimumScaleFactor(0.5)
                    
                    .lineLimit(1)

            }
            ForEach(allButton, id: \.self) { row in
                GridRow(alignment: .center) {
                    ForEach(row, id: \.self) { button in
                        if(button == "C"){
                            Button(action: {
                                actionButton(button)
                            }) {
                                Text(button)
                                    .font(.system(size: 45, weight: .regular, design: .rounded))
                                    .clipShape(Capsule())
                                    .frame(maxWidth: .infinity, maxHeight: 70)
                                    .foregroundColor(.white)
                            }
                            .gridCellColumns(3)
                            .background(Color.black)
                            .clipShape(Capsule())
                            
                        }
                        else if(button == "0"){
                            Button(action: {
                                actionButton(button)
                            }) {
                                Text(button)
                                    .font(.system(size: 45, weight: .regular, design: .rounded))
                                    .clipShape(Capsule())
                                    .frame(maxWidth: .infinity, maxHeight: 70)
                                    .foregroundColor(.white)
                            }
                            .gridCellColumns(2)
                            .background(Color.black)
                            .clipShape(Capsule())
                        }
                        else{
                            Button(action: {actionButton(button)}
                            ) {
                                Text(button)
                                    .font(.system(size: 45, weight: .regular, design: .rounded))
                                    .clipShape(Capsule())
                                    .frame(maxWidth: .infinity, maxHeight: 70)
                                    .foregroundColor(.white)
                            }
                            .background(Color.black)
                            .clipShape(Capsule())
                            
                            
                        }
                    }
                }
            }
        }.padding(.horizontal, 10)
    }
    func actionButton(_ button: String) {
        
            switch button {
            case "C":
                clearAll()
            case "+", "-", "*", "/":
                pressAction(button: button)
            case "=":
                calculate()
            case ".":
                addDot()
            default: addNumber(button: button)
            }
        
    }
    func clearAll(){
        history = ""
        num1 = nil
        num2 = 0.0
        binaryOperator = nil
        result = "0"
    }
    func addDot() {
        if(!result.contains(".")){
            result.append(".")
        }
    }
    func addNumber(button: String){
        if(isEqual){
            clearAll()
        }
        if(result == "0" || isOperator){
            result = ""
        }
        
        result += button
        isEqual = false
        isOperator = false
        
    }
    func pressAction(button: String) {
        if(num1 != nil && !isEqual && !isOperator){
            calculate()
        }
        num1 = Double(result)
        binaryOperator = button
        history = zeroTrimming(result)+" "+binaryOperator!
        isEqual = false
        isOperator = true

        
    }
    func calculate() {
        if(num1 != nil && binaryOperator != nil){
            if(!isEqual){
                num2 = Double(result)
                
            }
            history = zeroTrimming(String(num1!)) + " " + binaryOperator! + " " + zeroTrimming(String(num2!)) + " = "
            
            isEqual = true
            switch binaryOperator {
            case "+":
                result = zeroTrimming(String(num1! + num2!))
            case "-":
                result = zeroTrimming(String(num1! - num2!))
            case "*":
                result = zeroTrimming(String(num1! * num2!))
            case "/":
                if(num2 == 0.0){
                    clearAll()
                    return
                }
                result = zeroTrimming(String(num1! / num2!))
            default:
                print("error")
            }
            num1 = Double(result)
        }
    }
    func zeroTrimming(_ number: String) -> String{
        if number.hasSuffix(".0") {
            return String(number.dropLast(2))
        }
        return number
    }
}

#Preview {
    ContentView()
}
