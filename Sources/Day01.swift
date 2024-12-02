import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var split: (left: [Int], right: [Int]) {
    var left: [Int] = []
    var right: [Int] = []
    data.split(separator: "\n").forEach {
      let split = $0.split(separator: " ").compactMap { Int($0) }
      left.append(split[0])
      right.append(split[1])
    }
    return (left, right)
  }

  func part1() -> Any {
    var (left, right) = split
    
    left = left.sorted()
    right = right.sorted()
    
    let diff = zip(left, right).map { left, right in
      abs(left - right)
    }
    
    return diff.reduce(0, +)
  }

  func part2() -> Any {
    let (left, right) = split
    
    var frequency: [Int: Int] = [:]
    for value in right {
      frequency[value, default: 0] += 1
    }
    
    let mult = left.map {
      let freq = frequency[$0] ?? 0
      return $0 * freq
    }
    
    return mult.reduce(0, +)
  }
}
