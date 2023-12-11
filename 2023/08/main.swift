import Foundation

let string: String = try String(contentsOfFile: "input.txt")

/// Part One
enum Direction: String {
    case left = "L"
    case right = "R"
}

var directions: [Direction] = []
var nodes: [String: (left: String, right: String)] = [:]

for (index, line) in string.components(separatedBy: .newlines).filter({ !$0.isEmpty }).enumerated() {
    if index == 0 {
        directions = line.compactMap { Direction(rawValue: String($0)) }
        continue
    }

    let components: [String] = line.components(separatedBy: "=")

    guard
        let key: String = components.first?.trimmingCharacters(in: .whitespaces),
        let elementsString: String = components.last?.trimmingCharacters(in: .whitespaces).replacing(#/[(,)]/#, with: "") else {
        continue
    }

    let elements: [String] = elementsString.components(separatedBy: .whitespaces)

    guard
        let left: String = elements.first,
        let right: String = elements.last else {
        continue
    }

    nodes[key] = (left: left, right: right)
}

var part1: Int = 0
var key: String = "AAA"

while key != "ZZZ" {
    switch directions[part1 % directions.count] {
    case .left:
        if let value: (left: String, right: String) = nodes[key] {
            key = value.left
        }
    case .right:
        if let value: (left: String, right: String) = nodes[key] {
            key = value.right
        }
    }

    part1 += 1
}

print("Part 1:", part1)

/// Part Two
func gcd(_ x: Int, _ y: Int) -> Int {
    var a: Int = 0
    var b: Int = max(x, y)
    var r: Int = min(x, y)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }

    return b
}

var keys: [String] = nodes.filter { $0.key.hasSuffix("A") }.map(\.key)
var steps: [Int] = keys.map { _ in 0 }

for index in keys.indices {
    while !keys[index].hasSuffix("Z") {
        switch directions[steps[index] % directions.count] {
        case .left:
            if let value: (left: String, right: String) = nodes[keys[index]] {
                keys[index] = value.left
            }
        case .right:
            if let value: (left: String, right: String) = nodes[keys[index]] {
                keys[index] = value.right
            }
        }

        steps[index] += 1
    }
}

let part2: Int = steps.reduce(1) { x, y in x / gcd(x, y) * y }
print("Part 2:", part2)
