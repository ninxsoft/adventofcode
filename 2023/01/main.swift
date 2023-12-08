import Foundation

let string: String = try String(contentsOfFile: "input.txt")

/// Part One
func number(from line: String) -> Int? {
    let string: String = line.filter(\.isNumber)

    guard
        let first: Character = string.first,
        let last: Character = string.last else {
        return nil
    }

    return Int("\(first)\(last)")
}

let sumForPart1: Int = string.components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
    .compactMap { number(from: $0) }
    .reduce(0, +)
print("Part 1:", sumForPart1)

/// Part Two
let digits: [String] = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

func stringReplacingLettersWithNumbers(_ line: String) -> String {
    var string: String = ""

    for character: Character in line {
        string.append(character)

        for (index, digit) in digits.enumerated() where string.contains(digit) {
            string.replace(digit, with: "\(index + 1)")
        }
    }

    return string
}

let sumForPart2: Int = string.components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
    .compactMap { number(from: stringReplacingLettersWithNumbers($0)) }
    .reduce(0, +)
print("Part 2:", sumForPart2)
