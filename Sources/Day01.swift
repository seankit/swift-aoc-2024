import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var split: (left: [Int], right: [Int]) {
    let pairs = data.split(separator: "\n").map { line in
      line.split(separator: " ").compactMap { Int($0) }
    }
    let left = pairs.map { $0[0] }
    let right = pairs.map { $0[1] }
    return (left, right)
  }

  func part1() -> Any {
    var (left, right) = split
    
    left = left.sorted()
    right = right.sorted()
    
    let diff = zip(left, right).map { abs($0 - $1) }
    return diff.reduce(0, +)
  }

  func part2() -> Any {
    let (left, right) = split
    
    var frequency: [Int: Int] = [:]
    right.forEach {
      frequency[$0, default: 0] += 1
    }
    
    let mult = left.map {
      let frequency = frequency[$0] ?? 0
      return $0 * frequency
    }
    
    return mult.reduce(0, +)
  }
}
