import Algorithms

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var equations: [[Int: [Int]]] {
    data.split(separator: "\n").map {
      let equation = $0.split(separator: ":")
      let values = equation[1].split(separator: " ").compactMap { Int(String($0)) }
      let answer = Int(String(equation[0]))!
      return [answer: values]
    }
  }
  
  enum Element {
    case number(Int)
    case `operator`(Operator)
  }
  
  enum Operator {
    case add
    case multiply
  }
    
  func generateExpressions(_ numbers: [Element], _ currentExpression: [Element], _ currentIndex: Int) {
    // Base case: if we are at the last number, print the expression
    if currentIndex == numbers.count {
      print(currentExpression)
      return
    }
    
    // Add the current number to the expression with a `+`
    generateExpressions(numbers, currentExpression + [Element.operator(.add)] + [numbers[currentIndex]], currentIndex + 1)
    
    // Add the current number to the expression with a `*`
    generateExpressions(numbers, currentExpression + [Element.operator(.multiply)] + [numbers[currentIndex]], currentIndex + 1)
  }
  
//  func allPermutationsOfOperators(numbers: [Int]) {
//    // Start with the first number in the list
//    guard !numbers.isEmpty else { return }
//    let firstNumber = Element.number(numbers[0])
//    let remainingNumbers = Array(numbers.dropFirst()).map { Element.number($0) }
//    generateExpressions(remainingNumbers, [firstNumber], 1)
//  }
  
//  // Example usage
//  let numbers = [1, 2, 3]
//  allPermutationsOfOperators(numbers: numbers)
  
  func part1() -> Int {
    equations.map { equation in
      let total = equation.keys.first!
      guard let values = equation[total] else { return 0 }
      
      let firstNumber = Element.number(values.first!)
      let remainingNumbers = Array(values.dropFirst()).map { Element.number($0) }
      generateExpressions(remainingNumbers, [firstNumber], 1)
      return 0
    }.reduce(0, +)
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1Old() -> Int {
    let values = equations.map { equation in
      let total = equation.keys.first!
      guard let values = equation[total] else { return 0 }
      
      var index = 0
      var isValid = true
      var currentTotal = 0
      var currentOperator = Operator.multiply
      while isValid && currentTotal != total && index <= equation.count {
        guard index >= 0 && index < values.count else { break }
        
        var current: Int = 0
        switch currentOperator {
        case .multiply:
          let product = values[index] * values[index + 1]
          current += product
        case .add:
          let sum = values[index] + values[index + 1]
          current += sum
        }
        
        currentTotal += current
        
        if currentTotal == total && index == equation.count - 1 {
          return 1
        } else if currentTotal > total && currentOperator == .add && index >= equation.count {
          isValid = false
          return 0
        } else if currentTotal > total && currentOperator == .multiply {
          currentOperator = .add
          currentTotal -= current
          index -= 1
          continue
        }
      }
      
      return isValid ? currentTotal : 0
    }
    
    print(values)
    return 0
  }

  // Replace this with your solution for the second part of the day's challenge.
//  func part2() -> Any {
//    // Sum the maximum entries in each set of data
//    entities.map { $0.max() ?? 0 }.reduce(0, +)
//  }
}
