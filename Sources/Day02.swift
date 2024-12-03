import Algorithms

fileprivate enum Direction {
  case increasing
  case decreasing
}

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var levels: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  func part1() -> Int {
    levels.filter { $0.isValid }.count
  }

  func part2() -> Int {
    let safeCount = part1()

    let dampenedSafeCount = levels
      .filter { !$0.isValid }
      .filter { level in
        level.indices.contains { index in
          var level = level
          level.remove(at: index)
          return level.isValid
        }
    }.count

    return safeCount + dampenedSafeCount
  }
}

extension Array where Element == Int {
  fileprivate var isValid: Bool {
    var stack = self
    var current = stack.removeFirst()

    while !stack.isEmpty {
      let range = direction == .decreasing ? (current-3...current-1) : (current+1...current+3)
      guard range.contains(stack.first!) else { return false }
      current = stack.removeFirst()
    }
    return true
  }

  fileprivate var direction: Direction {
    self[1] > self[0] ? .increasing : .decreasing
  }
}
