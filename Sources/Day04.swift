import Algorithms

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var grid: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }
  
  let xmas: [Character] = ["X", "M", "A", "S"]
  
  var directions: [(Int, Int)] {
    cardinalDirections + diagonalDirections
  }
  
  let cardinalDirections: [(Int, Int)] = [
    (0, 1),
    (0, -1),
    (1, 0),
    (-1, 0),
  ]

  let diagonalDirections: [(Int, Int)] = [
    (-1, -1),
    (1, 1),
    (1, -1),
    (-1, 1),
  ]

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    /// Iterate though every node in the grid
    /// If an X is found, start a DFS and increment indec
    /// DFS looks in all 8 directions
    /// during DFS, check that the character is equal to word[index]
    /// if index == word.count, return true
    /// for every true, increment count
    let numRows = grid.count
    let numColumns = grid[0].count
    
    func dfs(row: Int, column: Int, index: Int, direction: (Int, Int)) -> Int {
      guard index < xmas.count else { return 1 }
      
      guard row >= 0,
            row < numRows,
            column >= 0,
            column < numColumns,
            grid[row][column] == xmas[index]
      else { return 0 }
      
      return dfs(row: row + direction.0, column: column + direction.1, index: index + 1, direction: direction)
    }
    
    var xmasCount = 0
    for row in 0..<numRows {
      for column in 0..<numColumns {
        guard grid[row][column] == "X" else { continue }
        
        for direction in directions {
          xmasCount += dfs(row: row, column: column, index: 0, direction: direction)
        }
      }
    }
    return xmasCount
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let numRows = grid.count
    let numColumns = grid[0].count
    
    func checkMas(row: Int, column: Int, directions: [(Int, Int)]) -> Bool {
      for direction in directions {
        guard row + direction.0 >= 0,
              row + direction.0 < numRows,
              column + direction.1 >= 0,
              column + direction.1 < numColumns
        else { return false }
      }
            
      var characters: Set<Character> = []
      for direction in directions {
        characters.insert(grid[row + direction.0][column + direction.1])
      }
      return characters == ["M", "S"]
    }
    
    var xmasCount = 0
    for row in 0..<numRows {
      for column in 0..<numColumns {
        guard grid[row][column] == "A" else { continue }
        
        if checkMas(row: row, column: column, directions: [diagonalDirections[0], diagonalDirections[1]])
            && checkMas(row: row, column: column, directions: [diagonalDirections[2], diagonalDirections[3]]) {
          xmasCount += 1
        }
      }
    }
    return xmasCount
  }
}
