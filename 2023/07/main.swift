import Foundation

let string: String = try String(contentsOfFile: "input.txt")

/// Part One
enum Card: String, CaseIterable, CustomStringConvertible {
    case ace = "A"
    case king = "K"
    case queen = "Q"
    case jack = "J"
    case ten = "T"
    case nine = "9"
    case eight = "8"
    case seven = "7"
    case six = "6"
    case five = "5"
    case four = "4"
    case three = "3"
    case two = "2"

    var strength: Int {
        switch self {
        case .ace:
            14
        case .king:
            13
        case .queen:
            12
        case .jack:
            11
        case .ten:
            10
        case .nine:
            9
        case .eight:
            8
        case .seven:
            7
        case .six:
            6
        case .five:
            5
        case .four:
            4
        case .three:
            3
        case .two:
            2
        }
    }

    var alternateStrength: Int {
        switch self {
        case .jack:
            1
        default:
            strength
        }
    }

    var description: String {
        rawValue
    }
}

enum HandType: Int {
    case fiveOfAKind = 7
    case fourOfAKind = 6
    case fullHouse = 5
    case threeOfAKind = 4
    case twoPair = 3
    case onePair = 2
    case highCard = 1

    var strength: Int {
        rawValue
    }
}

struct Hand: Comparable {
    let cards: [Card]
    let bid: Int

    func dictionary(for cards: [Card]) -> [Card: Int] {
        var dictionary: [Card: Int] = [:]

        for card in cards {
            if dictionary[card] == nil {
                dictionary[card] = 1
            } else {
                dictionary[card]! += 1
            }
        }

        return dictionary
    }

    func type(for cards: [Card]) -> HandType {
        let dictionary: [Card: Int] = dictionary(for: cards)

        if dictionary.values.contains(5) {
            return .fiveOfAKind
        }

        if dictionary.values.contains(4) {
            return .fourOfAKind
        }

        if dictionary.values.contains(3), dictionary.values.contains(2) {
            return .fullHouse
        }

        if dictionary.values.contains(3) {
            return .threeOfAKind
        }

        if dictionary.values.filter({ $0 == 2 }).count == 2 {
            return .twoPair
        }

        if dictionary.values.contains(2) {
            return .onePair
        }

        return .highCard
    }

    var type: HandType {
        type(for: cards)
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.type.strength != rhs.type.strength {
            return lhs.type.strength < rhs.type.strength
        }

        for index in lhs.cards.indices {
            if lhs.cards[index].strength == rhs.cards[index].strength {
                continue
            } else {
                return lhs.cards[index].strength < rhs.cards[index].strength
            }
        }

        return false
    }
}

var hands: [Hand] = []

for line in string.components(separatedBy: .newlines).filter({ !$0.isEmpty }) {
    let components: [String] = line.components(separatedBy: .whitespaces)

    guard
        let cardsString: String = components.first,
        let bidString: String = components.last,
        let bid: Int = Int(bidString) else {
        continue
    }

    let cards: [Card] = cardsString.compactMap { Card(rawValue: String($0)) }
    let hand: Hand = .init(cards: cards, bid: bid)
    hands.append(hand)
}

let part1: Int = hands.sorted().enumerated().map { ($0 + 1) * $1.bid }.reduce(0, +)
print("Part 1:", part1)

/// Part Two
extension Hand {
    var bestAlternateCards: [Card] {
        var hands: [Hand] = []
        for card in Card.allCases {
            let cards: [Card] = cards.map { $0 == .jack ? card : $0 }
            let hand: Hand = .init(cards: cards, bid: bid)
            hands.append(hand)
        }
        return hands.sorted().last!.cards
    }

    var alternateType: HandType {
        type(for: bestAlternateCards)
    }
}

func alternate(lhs: Hand, rhs: Hand) -> Bool {
    if lhs.alternateType != rhs.alternateType {
        return lhs.alternateType.strength < rhs.alternateType.strength
    }

    for index in lhs.bestAlternateCards.indices {
        if lhs.cards[index].strength == rhs.cards[index].strength {
            continue
        } else {
            return lhs.cards[index].alternateStrength < rhs.cards[index].alternateStrength
        }
    }

    return false
}

let part2: Int = hands.sorted(by: alternate).enumerated().map { ($0 + 1) * $1.bid }.reduce(0, +)
print("Part 2:", part2)
