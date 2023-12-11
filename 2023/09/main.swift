import Foundation

let string: String = try String(contentsOfFile: "input.txt")

/// Part One
extension [[Int]] {
    var hasAllZeroes: Bool {
        guard let sequence: [Int] = last else {
            return false
        }

        return sequence.filter { $0 != 0 }.isEmpty
    }
}

var part1: Int = 0

for line in string.components(separatedBy: .newlines).filter({ !$0.isEmpty }) {
    var sequences: [[Int]] = [line.components(separatedBy: .whitespaces).compactMap { Int($0) }]

    while !sequences.hasAllZeroes {
        guard let current: [Int] = sequences.last else {
            continue
        }

        let next: [Int] = (0 ..< current.count - 1).map { current[$0 + 1] - current[$0] }
        sequences.append(next)
    }

    for index in sequences.indices.reversed() {
        let sequence: [Int] = sequences[index]
        let next: Int = index == sequences.count - 1 ? 0 : sequence[sequence.count - 1] + sequences[index + 1][sequence.count - 1]
        sequences[index].append(next)

        if index == 0 {
            part1 += next
        }
    }
}

print("Part 1:", part1)

/// Part Two
var part2: Int = 0

for line in string.components(separatedBy: .newlines).filter({ !$0.isEmpty }) {
    var sequences: [[Int]] = [line.components(separatedBy: .whitespaces).compactMap { Int($0) }]

    while !sequences.hasAllZeroes {
        guard let current: [Int] = sequences.last else {
            continue
        }

        let next: [Int] = (0 ..< current.count - 1).map { current[$0 + 1] - current[$0] }
        sequences.append(next)
    }

    for index in sequences.indices.reversed() {
        let sequence: [Int] = sequences[index]
        let next: Int = index == sequences.count - 1 ? 0 : sequence[0] - sequences[index + 1][0]
        sequences[index].insert(next, at: 0)

        if index == 0 {
            part2 += next
        }
    }
}

print("Part 2:", part2)
