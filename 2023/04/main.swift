import Foundation

let string: String = try String(contentsOfFile: "input.txt")

/// Part One
struct Card {
    let index: Int
    let winningNumbers: [Int]
    let numbers: [Int]

    var matchingNumbers: Int {
        winningNumbers.filter { numbers.contains($0) }.count
    }

    var points: Int {
        matchingNumbers > 0 ? Int(pow(Double(2), Double(matchingNumbers - 1))) : 0
    }

    var copies: Int
}

var cards: [Card] = []

for line in string.components(separatedBy: .newlines).filter({ !$0.isEmpty }) {
    let cardStrings: [String] = line.components(separatedBy: ":")

    guard
        let cardString: String = cardStrings.first,
        let indexString: String = cardString.components(separatedBy: .whitespaces).last,
        let index: Int = Int(indexString) else {
        continue
    }

    let winningNumbers: [Int] = cardStrings[1].components(separatedBy: "|")[0].components(separatedBy: .whitespaces).compactMap { Int($0) }
    let numbers: [Int] = cardStrings[1].components(separatedBy: "|")[1].components(separatedBy: .whitespaces).compactMap { Int($0) }
    let card: Card = .init(index: index, winningNumbers: winningNumbers, numbers: numbers, copies: 1)
    cards.append(card)
}

let part1: Int = cards
    .map(\.points)
    .reduce(0, +)
print("Part 1:", part1)

// Part Two
for (outer, _) in cards.enumerated() {
    for inner in cards[outer].index ..< cards[outer].index + cards[outer].matchingNumbers {
        cards[inner].copies += cards[outer].copies
    }
}

let part2: Int = cards
    .map(\.copies)
    .reduce(0, +)
print("Part 2:", part2)
