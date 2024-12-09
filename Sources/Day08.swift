import Algorithms

struct Day08: AdventDay {
  var grid: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }
  
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var coordinates: [Character: [Coordinate]] = [:]
    
    let numRows = grid.count
    let numColumns = grid[0].count
    
    for row in 0..<numRows {
      for column in 0..<numColumns {
        guard grid[row][column] != "." else { continue }
        
        let character = grid[row][column]
        coordinates[character, default: []].append(Coordinate(row: row, column: column))
      }
    }
    
    var grid = grid
    var count = 0
    
    for key in coordinates.keys {
      guard let characterCoordinates = coordinates[key] else { continue }
      for coordinate in characterCoordinates {
        for otherCoordinate in characterCoordinates {
          guard coordinate != otherCoordinate else { continue }
          
          let offset = Coordinate(row: coordinate.row - otherCoordinate.row, column: coordinate.column - otherCoordinate.column)
          let antinode = Coordinate(row: coordinate.row + offset.row, column: coordinate.column + offset.column)

          guard antinode.row >= 0,
                antinode.row < numRows,
                antinode.column >= 0,
                antinode.column < numColumns
          else { continue}
          
          count += isValidCoordinate(antinode) ? 1 : 0

          grid[antinode.row][antinode.column] = "#"
        }
      }
    }
    
    func isValidCoordinate(_ coordinate: Coordinate) -> Bool {
      coordinates.keys.contains(grid[coordinate.row][coordinate.column]) || grid[coordinate.row][coordinate.column] == "."
    }

    return count
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    var grid = grid
    let numRows = grid.count
    let numColumns = grid[0].count
    var coordinates: [Character: [Coordinate]] = [:]

    for row in 0..<numRows {
      for column in 0..<numColumns {
        guard grid[row][column] != "." else { continue }
        
        let character = grid[row][column]
        coordinates[character, default: []].append(Coordinate(row: row, column: column))
      }
    }
    
    for key in coordinates.keys {
      guard let characterCoordinates = coordinates[key] else { continue }
      for coordinate in characterCoordinates {
        for otherCoordinate in characterCoordinates {
          guard coordinate != otherCoordinate else { continue }
          
          let offset = Coordinate(row: coordinate.row - otherCoordinate.row, column: coordinate.column - otherCoordinate.column)
          var currentAntinode = Coordinate(row: coordinate.row + offset.row, column: coordinate.column + offset.column)
          
          while currentAntinode.row >= 0,
                currentAntinode.row < numRows,
                currentAntinode.column >= 0,
                currentAntinode.column < numColumns {
            
            grid[currentAntinode.row][currentAntinode.column] = "#"
            
            currentAntinode = Coordinate(row: currentAntinode.row + offset.row, column: currentAntinode.column + offset.column)
          }
        }
      }
    }
    
    func isValidCoordinate(_ coordinate: Coordinate) -> Bool {
      coordinates.keys.contains(grid[coordinate.row][coordinate.column]) || grid[coordinate.row][coordinate.column] == "."
    }
    
    // easy way out
    let count = grid.map { row in
      row.map { character in
        character == "." ? 0 : 1
      }.reduce(0, +)
    }.reduce(0, +)
    
    for row in grid {
      print(String(row))
    }
    
    return count
  }
}
