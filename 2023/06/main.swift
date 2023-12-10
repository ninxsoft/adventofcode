import Foundation

let string: String = try String(contentsOfFile: "input.txt")

/// Part One
var times: [Int] = []
var distances: [Int] = []
var waysToWin: [Int] = []

for (index, line) in string.components(separatedBy: .newlines).filter({ !$0.isEmpty }).enumerated() {
    if index == 0 {
        times = line.components(separatedBy: .whitespaces).compactMap { Int($0) }
    } else {
        distances = line.components(separatedBy: .whitespaces).compactMap { Int($0) }
    }
}

for (index, time) in times.enumerated() {
    let count: Int = (0 ..< time).filter { (time - $0) * $0 > distances[index] }.count
    waysToWin.append(count)
}

let part1: Int = waysToWin.reduce(1, *)
print("Part 1:", part1)

/// Part Two
var time: Int = 0
var distance: Int = 0

for (index, line) in string.components(separatedBy: .newlines).filter({ !$0.isEmpty }).enumerated() {
    guard let number: Int = Int(line.replacing(#/[a-zA-Z: ]/#, with: "")) else {
        continue
    }

    if index == 0 {
        time = number
    } else {
        distance = number
    }
}

let part2: Int = (0 ..< time).filter { (time - $0) * $0 > distance }.count
print("Part 2:", part2)
