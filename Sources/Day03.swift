import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { Int($0) }
    }
  }
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let regex = /mul\(\d+,\d+\)/
    
    let mul = data.matches(of: regex).map { match in
      let match = match.localizedLowercase
      let digits = match.split(separator: ",")
      let first = Int(digits.first?.trimmingPrefix("mul(") ?? "") ?? 0
      let last = Int(digits.last?.trimmingSuffix(while: { $0 == ")" }) ?? "") ?? 0
      
      return first * last
    }
    
    return mul.reduce(0, +)
  }
  
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    entities.map { $0.max() ?? 0 }.reduce(0, +)
  }
}
