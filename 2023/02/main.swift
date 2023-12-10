import Foundation

let string: String = try String(contentsOfFile: "input.txt")

/// Part One
enum Color: String {
    case red
    case green
    case blue
}

struct GamesResult {
    let id: Int
    let games: [(red: Int, green: Int, blue: Int)]

    var isPossible: Bool {
        games.map(\.red).max() ?? Int.max <= 12 &&
            games.map(\.green).max() ?? Int.max <= 13 &&
            games.map(\.blue).max() ?? Int.max <= 14
    }

    var power: Int {
        (games.map(\.red).max() ?? 0) * (games.map(\.green).max() ?? 0) * (games.map(\.blue).max() ?? 0)
    }
}

func gamesResult(from line: String) -> GamesResult? {
    let components: [String] = line.components(separatedBy: ":")

    guard
        let gameString: String = components.first,
        let idString: String = gameString.components(separatedBy: " ").last,
        let id: Int = Int(idString),
        let gamesString: String = components.last else {
        return nil
    }

    var games: [(red: Int, green: Int, blue: Int)] = []

    let gameStrings: [String] = gamesString.components(separatedBy: ";")

    for gameString in gameStrings {
        let colorsStrings: [String] = gameString.components(separatedBy: ", ")

        for colorsString in colorsStrings.map({ $0.trimmingCharacters(in: .whitespaces) }) {
            let colorStrings: [String] = colorsString.components(separatedBy: " ")

            guard
                let countString: String = colorStrings.first,
                let count: Int = Int(countString),
                let colorString: String = colorStrings.last,
                let color: Color = .init(rawValue: colorString) else {
                continue
            }

            var game: (red: Int, green: Int, blue: Int) = (red: 0, green: 0, blue: 0)

            switch color {
            case .red:
                game.red = count
            case .green:
                game.green = count
            case .blue:
                game.blue = count
            }

            games.append(game)
        }
    }

    return GamesResult(id: id, games: games)
}

let part1: Int = string.components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
    .compactMap { gamesResult(from: $0) }
    .filter(\.isPossible)
    .map(\.id)
    .reduce(0, +)
print("Part 1:", part1)

/// Part Two
let part2: Int = string.components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
    .compactMap { gamesResult(from: $0) }
    .map(\.power)
    .reduce(0, +)
print("Part 2:", part2)
