import Algorithms

typealias Coordinate = (row: Int, column: Int)
typealias ObstacleCoordinate = [Int]

struct Obstacle: Hashable {
  var coordinate: ObstacleCoordinate
  var direction: GridDirection
}

enum GridDirection {
  case up
  case down
  case left
  case right
  
  var coordinate: Coordinate {
    switch self {
    case .up: return (-1, 0)
    case .down: return (1, 0)
    case .left: return (0, -1)
    case .right: return (0, 1)
    }
  }
  
  var toRight: GridDirection {
    switch self {
    case .up: return .right
    case .right: return .down
    case .down: return .left
    case .left: return .up
    }
  }
}

struct Day06: AdventDay {
  typealias QueueElement = (coordinate: Coordinate, direction: GridDirection)
  
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  var grid: [[Character]] {
    data.split(separator: "\n").map {
      Array($0)
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    let numRows = grid.count
    let numColumns = grid[0].count
    
    var grid = self.grid

    for row in 0..<numRows {
      for column in 0..<numColumns {
        guard grid[row][column] == "^" else { continue }
        
        let value = traverseBFS(row: row, column: column, direction: .up, grid: &grid)
        
        return value
      }
    }
    return -1
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    let numRows = grid.count
    let numColumns = grid[0].count
    
    for row in 0..<numRows {
      for column in 0..<numColumns {
        guard grid[row][column] == "^" else { continue }
        
        let value = traverseBFS(row: row, column: column, direction: .up)
        
        return value
      }
    }
    return -1
  }
  
  func traverseBFS(row: Int, column: Int, direction: GridDirection) -> Int {
    let numRows = grid.count
    let numColumns = grid[0].count
    var queue: [QueueElement] = [(Coordinate(row, column), direction)]
    var visitedObstacles: Set<Obstacle> = []
    var totalValue = 0
    
    var grid = grid
    
    while !queue.isEmpty {
      // printGrid(grid: grid)
      
      let (currentCoordinate, currentDirection) = queue.removeFirst()
      let (row, column) = currentCoordinate
      
      let nextCoordinate: Coordinate = (row + currentDirection.coordinate.row, column + currentDirection.coordinate.column)
            
      guard nextCoordinate.row >= 0,
            nextCoordinate.row < numRows,
            nextCoordinate.column >= 0,
            nextCoordinate.column < numColumns
      else {
        continue
      }
      
      let isObstacle = grid[nextCoordinate.row][nextCoordinate.column] == "#"
      
      grid[row][column] = if grid[row][column] == "-" || grid[row][column] == "|" || isObstacle {
        "+"
      } else if currentDirection == .up || currentDirection == .down {
        "|"
      } else {
        "-"
      }
        
      if let closestObstacleCoordinate = grid.closestObstacle(from: currentCoordinate, in: currentDirection.toRight) {
//        let closestObstacle = Obstacle(coordinate: closestObstacleCoordinate, direction: currentDirection.toRight)
        
//        if visitedObstacles.contains(closestObstacle) {
          var temp = grid
          
          temp[nextCoordinate.row][nextCoordinate.column] = "0"
          temp[currentCoordinate.row][currentCoordinate.column] = "+"
          
          if containsCycle2(grid: temp, startingCoordinate: currentCoordinate, direction: currentDirection.toRight, visited: visitedObstacles) {
            totalValue += 1
          }
//        }
      }
      
      if isObstacle {
        visitedObstacles.insert(Obstacle(coordinate: [nextCoordinate.row, nextCoordinate.column], direction: currentDirection))
      }
      
      let newDirection = isObstacle ? currentDirection.toRight : currentDirection
      
      queue.append((coordinate: (currentCoordinate.row + newDirection.coordinate.row, currentCoordinate.column + newDirection.coordinate.column), direction: newDirection))
    }
    
    print("Obstacles: \(visitedObstacles.count)")
    
    printGrid(grid: grid)
    return totalValue
  }
  
  func containsCycle2(grid: [[Character]], startingCoordinate: Coordinate, direction: GridDirection, visited: Set<Obstacle>) -> Bool {
    let numRows = grid.count
    let numColumns = grid[0].count
    var queue: [QueueElement] = [(Coordinate(startingCoordinate.row, startingCoordinate.column), direction)]
    
    var grid = grid
    
    while !queue.isEmpty {
      // printGrid(grid: grid)
      
      let (currentCoordinate, currentDirection) = queue.removeFirst()
      let (row, column) = currentCoordinate
      let nextCoordinate: Coordinate = (row + currentDirection.coordinate.row, column + currentDirection.coordinate.column)
      
      guard nextCoordinate.row >= 0,
            nextCoordinate.row < numRows,
            nextCoordinate.column >= 0,
            nextCoordinate.column < numColumns
      else {
        continue
      }
      
      let isObstacle = grid[nextCoordinate.row][nextCoordinate.column] == "#"
      let newDirection = isObstacle ? currentDirection.toRight : currentDirection
      
      if isObstacle, let closestObstacleCoordinate = grid.closestObstacle(from: currentCoordinate, in: newDirection) {
        let closestObstacle = Obstacle(coordinate: closestObstacleCoordinate, direction: newDirection)
        
        if visited.contains(closestObstacle) {
          return true
        }
      }
            
      grid[row][column] = if isObstacle {
        "+"
      } else if direction == .up || direction == .down {
        "|"
      } else {
        "-"
      }
      
      if let closestObstacleCoordinate = grid.closestObstacle(from: currentCoordinate, in: newDirection) {
        let coordinate = (closestObstacleCoordinate[0] - direction.coordinate.row, closestObstacleCoordinate[1] - newDirection.coordinate.column)
        
        queue.append((coordinate: coordinate, direction: newDirection))
      } else {
        return false
      }
    }
    
    return false
  }
  
  func containsCycle(grid: [[Character]], startingCoordinate: Coordinate, direction: GridDirection, visited: Set<Obstacle>) -> Bool {
    let numRows = grid.count
    let numColumns = grid[0].count
    var queue: [QueueElement] = [(Coordinate(startingCoordinate.row, startingCoordinate.column), direction)]
    
    var grid = grid
    
    while !queue.isEmpty {
      let (currentCoordinate, currentDirection) = queue.removeFirst()
      let (row, column) = currentCoordinate
      
      let nextCoordinate: Coordinate = (row + currentDirection.coordinate.row, column + currentDirection.coordinate.column)
      
      if nextCoordinate == startingCoordinate {
        return true
      }
      
      guard nextCoordinate.row >= 0,
            nextCoordinate.row < numRows,
            nextCoordinate.column >= 0,
            nextCoordinate.column < numColumns
      else {
        continue
      }
      
      let isObstacle = grid[nextCoordinate.row][nextCoordinate.column] == "#"
      let direction = isObstacle ? currentDirection.toRight : currentDirection
      
      grid[row][column] = if isObstacle {
        "+"
      } else if direction == .up || direction == .down {
        "|"
      } else {
        "-"
      }
      
      let coordinate = (currentCoordinate.row + direction.coordinate.row, currentCoordinate.column + direction.coordinate.column)
      
      if coordinate == startingCoordinate {
        return true
      }
      
      queue.append((coordinate: coordinate, direction: direction))
    }
    
    return false
  }
  
  func traverseBFS(row: Int, column: Int, direction: GridDirection, grid: inout [[Character]]) -> Int {
    typealias QueueElement = (coordinate: Coordinate, direction: GridDirection)
    
    let numRows = grid.count
    let numColumns = grid[0].count
    var queue: [QueueElement] = [(Coordinate(row, column), direction)]
    var totalValue = 0
    
    while !queue.isEmpty {
      let (currentCoordinate, currentDirection) = queue.removeFirst()
      let (row, column) = currentCoordinate
      
      let nextCoordinate: Coordinate = (row + currentDirection.coordinate.row, column + currentDirection.coordinate.column)
      
      let positionValue = grid[row][column] == "X" ? 0 : 1
      
      guard nextCoordinate.row >= 0,
            nextCoordinate.row < numRows,
            nextCoordinate.column >= 0,
            nextCoordinate.column < numColumns
      else {
        totalValue += positionValue
        continue
      }
      
      let isObstacle = grid[nextCoordinate.row][nextCoordinate.column] == "#"
      let direction = isObstacle ? currentDirection.toRight : currentDirection
      
      totalValue += positionValue
      
      grid[row][column] = "X"
      
      queue.append((coordinate: (currentCoordinate.row + direction.coordinate.row, currentCoordinate.column + direction.coordinate.column), direction: direction))
    }
    
    return totalValue
  }
  
  func printGrid(grid: [[Character]]) {
    print("\n\n")
    
    for row in grid {
      print(String(row))
    }
    
    print("\n\n")
  }
}

extension Array where Element == [Character] {
  func obstaclesInRow(row: Int) -> Set<ObstacleCoordinate> {
    let coordinates = self[row].enumerated()
      .filter { (column, element) in
        element == "#"
      }
      .map { [row, $0.offset] }
    return Set(coordinates)
  }
  
  func obstaclesInColumn(column: Int) -> Set<ObstacleCoordinate> {
    let coordinates = self.enumerated()
      .filter { (row, _) in
        self[row][column] == "#"
      }
      .map { [$0.offset, column] }
    return Set(coordinates)
  }
  
  func closestObstacle(from coordinate: Coordinate, in direction: GridDirection) -> ObstacleCoordinate? {
    switch direction {
    case .up:
      return obstaclesInColumn(column: coordinate.column)
        .filter { $0[0] < coordinate.row } // Only obstacles above
        .min { abs($0[0] - coordinate.row) < abs($1[0] - coordinate.row) }
    case .down:
      return obstaclesInColumn(column: coordinate.column)
        .filter { $0[0] > coordinate.row } // Only obstacles below
        .min { abs($0[0] - coordinate.row) < abs($1[0] - coordinate.row) }
    case .left:
      return obstaclesInRow(row: coordinate.row)
        .filter { $0[1] < coordinate.column } // Only obstacles to the left
        .min { abs($0[1] - coordinate.column) < abs($1[1] - coordinate.column) }
    case .right:
      return obstaclesInRow(row: coordinate.row)
        .filter { $0[1] > coordinate.column } // Only obstacles to the right
        .min { abs($0[1] - coordinate.column) < abs($1[1] - coordinate.column) }
    }
  }
}
