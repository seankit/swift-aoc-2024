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
  
  func calculateAllCombinations(_ nums: [Int]) -> Set<Int> {
    func helper(_ index: Int, _ current: Int) -> Set<Int> {
      if index == nums.count {
        return [current]
      }
      
      var results: Set<Int> = []
      results = results.union(helper(index + 1, current + nums[index]))
      results = results.union(helper(index + 1, current * nums[index]))
      return results
    }
    
    return helper(1, nums[0])
  }
  
  func part1() -> Int {
    equations.filter { equation in
      let total = equation.keys.first!
      guard let values = equation[total] else { return false }
      
      let allCombinations = calculateAllCombinations(values)
      return allCombinations.contains(total)
    }
    .map { $0.keys.first! }
    .reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
//  func part2() -> Any {
//    // Sum the maximum entries in each set of data
//    entities.map { $0.max() ?? 0 }.reduce(0, +)
//  }
}
