import Foundation

let string: String = try String(contentsOfFile: "input.txt")

/// Part One
struct Mapping {
    let source: Int
    let destination: Int
    let length: Int
}

func location(for seed: Int, using mappingSections: [[Mapping]]) -> Int {
    var location: Int = seed

    for mappingSection in mappingSections {
        for mapping in mappingSection where mapping.source <= location && location < mapping.source + mapping.length {
            location = mapping.destination + (location - mapping.source)
            break
        }
    }

    return location
}

let lines: [String] = string.components(separatedBy: .newlines).filter { $0.isEmpty || !$0.matches(of: #/^(\d+\s)+\d+$/#).isEmpty }
var mappingSections: [[Mapping]] = []
var numbers: [String] = []

for line in lines {
    if line.isEmpty {
        let mappingSection = numbers.map { $0.components(separatedBy: .whitespaces).compactMap { Int($0) } }
            .map { Mapping(source: $0[1], destination: $0[0], length: $0[2]) }

        if !mappingSection.isEmpty {
            mappingSections.append(mappingSection)
        }

        numbers.removeAll()
    } else {
        numbers.append(line)
    }
}

var seeds: [Int] = string.components(separatedBy: .newlines).first?.components(separatedBy: ":").last?.components(separatedBy: .whitespaces).compactMap { Int($0) } ?? []
var locations: [Int] = seeds.map { location(for: $0, using: mappingSections) }

if let part1: Int = locations.min() {
    print("Part 1:", part1)
}

/// Part Two
let seedPairs: [Int] = string.components(separatedBy: .newlines).first?.components(separatedBy: ":").last?.components(separatedBy: .whitespaces).compactMap { Int($0) } ?? []
seeds.removeAll()
locations.removeAll()

for index in stride(from: 0, through: seedPairs.count - 1, by: 2) {
    seeds.append(contentsOf: seedPairs[index] ... seedPairs[index] + seedPairs[index + 1])
}

// Brute force!
// TODO: Re-implement
locations = seeds.map { location(for: $0, using: mappingSections) }

if let part2: Int = locations.min() {
    print("Part 2:", part2)
}
