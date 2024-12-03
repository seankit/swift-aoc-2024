import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    let products = matches(in: data).compactMap { match in
      product(from: match)
    }
    
    return products.reduce(0, +)
  }
  
  func matches(in string: String) -> [Regex<Regex<Substring>.RegexOutput>.Match] {
    let regex = /mul\(\d+,\d+\)/
    
    return string.matches(of: regex)
  }
  
  private func product(from match:  Regex<Regex<Substring>.RegexOutput>.Match) -> Int? {
    guard let match = String(match.utf8) else { return nil }
    let digits = match.split(separator: ",")
    guard let firstDigit = digits.first?.trimmingPrefix("mul("),
          let lastDigit = digits.last?.trimmingSuffix(while: { $0 == ")" }) else { return nil }
    
    guard let first = Int(firstDigit), let last = Int(lastDigit) else { return nil }

    return first * last
  }
  
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    /// splitting on do() first marks all products as valid until we find the next dont() in the line
    let enabledLines = data.split(separator: "do()").map {
      $0.split(separator: "don't()").first
    }

    var total = 0
    for enabledSubstring in enabledLines {
      guard let enabledSubstring else { continue }
      let enabled = String(enabledSubstring)
      let products = matches(in: enabled).map { match in
        product(from: match)!
      }
      total += products.reduce(0, +)
    }
    
    return total
  }
}
