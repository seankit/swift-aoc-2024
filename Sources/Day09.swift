import Algorithms

struct Day09: AdventDay {
  var data: String
  
  var entities: [Int] {
    Array(data).compactMap { Int(String($0)) }
  }
  
  var diskMap: [String] {
    var index = 0
    var isFile = true
    return entities.flatMap {
      let value = Array(repeating: isFile ? "\(index)" : ".", count: $0)
      
      if isFile {
        index += 1
      }
      isFile.toggle()
      
      return value
    }
  }
  
  func part1() -> Int {
    var diskMap = diskMap
    var left = 0
    var right = diskMap.count - 1
    
    while left < right {
      guard diskMap[left] == "." else {
        left += 1
        continue
      }
      
      guard diskMap[right] != "." else {
        right -= 1
        continue
      }
      
      let temp = diskMap[left]
      diskMap[left] = diskMap[right]
      diskMap[right] = temp
      
      left += 1
      right -= 1
    }
    
    return checksum(of: diskMap)
  }
  
  func checksum(of: [String]) -> Int {
     diskMap.compactMap { Int($0) }
      .enumerated()
      .map { $0 * $1 }
      .reduce(0, +)
  }
}
