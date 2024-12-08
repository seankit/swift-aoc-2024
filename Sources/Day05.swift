import Algorithms

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { Int($0) }
    }
  }
  
  var rules: [[Int]] {
    data.split(separator: "\n\n")[0].split(separator: "\n").map {
      String($0).split(separator: "|").compactMap { Int($0) }
    }
  }
  
  var updates: [[Int]] {
    data.split(separator: "\n\n")[1].split(separator: "\n").map {
      String($0).split(separator: ",").compactMap { Int($0) }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    let graph = buildDependencyGraph(rules: rules)
    
    return updates.filter { $0.isValid(using: graph) }
      .map { update in
        update[update.count / 2]
      }.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    let graph = buildDependencyGraph(rules: rules)
    
    let invalidUpdates = updates.filter { !$0.isValid(using: graph) }
    
    var validUpdates: [[Int]] = []
    
    for update in invalidUpdates {
      var valid: [Int] = []
      
      for current in update {
        if valid.isEmpty {
          valid.append(current)
          continue
        }
        
        var insertionIndex: Int?
        
        for (index, _) in valid.enumerated() {
          var temp = valid
          temp.insert(current, at: index)
          if temp.isValid(using: graph) {
            insertionIndex = index
            break
          }
        }
        
        if let insertionIndex {
          valid.insert(current, at: insertionIndex)
        } else {
          valid.append(current)
        }
      }
      
      validUpdates.append(valid)
    }
    
    return validUpdates
      .map { update in
        update[update.count / 2]
      }.reduce(0, +)
  }
  
  func buildDependencyGraph(rules: [[Int]]) -> (predecessors: [Int: [Int]], successors: [Int: [Int]]) {
    var predecessors: [Int: [Int]] = [:]
    var successors: [Int: [Int]] = [:]
    
    for rule in rules {
      let before = rule[0]
      let after = rule[1]
      
      successors[before, default: []].append(after)
      predecessors[after, default: []].append(before)
    }
    
    return (predecessors, successors)
  }
}

extension Array where Element == Int {
  func getSubarrays(around index: Int) -> ([Int], [Int]) {
    guard index >= 0 && index < self.count else {
      fatalError("Index out of bounds")
    }
    
    let before = Array(self[..<index]) // Subarray before the index
    let after = Array(self[(index + 1)...]) // Subarray after the index
    
    return (before, after)
  }

  func isValid(using graph: (predecessors: [Int: [Int]], successors: [Int: [Int]])) -> Bool {
    let (predecessors, successors) = graph
    
    for (index, current) in self.enumerated() {
      let (valuesBefore, valuesAfter) = getSubarrays(around: index)
      
      for value in valuesAfter {
        guard predecessors[value]?.contains(current) == true else {
          return false
        }
      }
      
      for value in valuesBefore {
        guard successors[value]?.contains(current) == true else {
          return false
        }
      }
    }
      
    return true
  }
}
