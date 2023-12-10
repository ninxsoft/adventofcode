import Foundation

let string: String = try String(contentsOfFile: "input.txt")

/// Part One
extension String {
    func substring(start: Int, end: Int) -> String {
        String(self[index(startIndex, offsetBy: start > 0 ? start : 0) ..< index(startIndex, offsetBy: end < count - 1 ? end : count - 1)])
    }
}

let lines: [String] = string.components(separatedBy: .newlines).filter { !$0.isEmpty }
var sumForPart1: Int = 0

for (index, line) in lines.enumerated() {
    for match in line.matches(of: #/\d+/#) {
        guard let number: Int = Int(match.output) else {
            continue
        }

        if
            // same line
            (match.startIndex.utf16Offset(in: line) > 0 && line[line.index(before: match.startIndex)] != ".") ||
            (match.endIndex.utf16Offset(in: line) < line.count - 1 && line[line.index(line.startIndex, offsetBy: match.endIndex.utf16Offset(in: line))] != ".") {
            sumForPart1 += number
            continue
        }

        // previous line
        if index > 0 {
            let previous: String = lines[index - 1]
            let substring: String = previous.substring(start: match.startIndex.utf16Offset(in: line) - 1, end: match.endIndex.utf16Offset(in: line) + 1)

            if Set(substring).count > 1 {
                sumForPart1 += number
                continue
            }
        }

        // next line
        if index < lines.count - 1 {
            let next: String = lines[index + 1]
            let substring: String = next.substring(start: match.startIndex.utf16Offset(in: line) - 1, end: match.endIndex.utf16Offset(in: line) + 1)

            if Set(substring).count > 1 {
                sumForPart1 += number
                continue
            }
        }
    }
}

print("Part 1:", sumForPart1)

/// Part Two
extension String {
    func leadingNumber(end: Int) -> Int? {
        var string: String = ""
        var index: Int = end

        while index >= 0, self[String.Index(utf16Offset: index, in: self)].isNumber {
            string = String(self[String.Index(utf16Offset: index, in: self)]) + string
            index -= 1
        }

        return Int(string)
    }

    func trailingNumber(start: Int) -> Int? {
        var string: String = ""
        var index: Int = start

        while index < count, self[String.Index(utf16Offset: index, in: self)].isNumber {
            string += String(self[String.Index(utf16Offset: index, in: self)])
            index += 1
        }

        return Int(string)
    }

    func middleNumber(midpoint: Int) -> Int? {
        guard self[String.Index(utf16Offset: midpoint, in: self)].isNumber else {
            return nil
        }

        var string: String = .init(self[String.Index(utf16Offset: midpoint, in: self)])

        for offset in [1, 2] {
            var match: Bool = false

            if self[String.Index(utf16Offset: midpoint - offset + 1, in: self)].isNumber, self[String.Index(utf16Offset: midpoint - offset, in: self)].isNumber {
                string = String(self[String.Index(utf16Offset: midpoint - offset, in: self)]) + string
                match = true
            }

            if self[String.Index(utf16Offset: midpoint + offset - 1, in: self)].isNumber, self[String.Index(utf16Offset: midpoint + offset, in: self)].isNumber {
                string += String(self[String.Index(utf16Offset: midpoint + offset, in: self)])
                match = true
            }

            guard match else {
                return Int(string)
            }
        }

        return Int(string)
    }
}

var sumForPart2: Int = 0

for (index, line) in lines.enumerated() {
    for match in line.matches(of: #/\*/#) {
        var parts: [Int] = []

        // same line leading
        if let number: Int = line.leadingNumber(end: match.startIndex.utf16Offset(in: line) - 1) {
            parts.append(number)
        }

        // same line trailing
        if let number: Int = line.trailingNumber(start: match.endIndex.utf16Offset(in: line)) {
            parts.append(number)
        }

        // previous line
        if index > 0 {
            let previous: String = lines[index - 1]

            if previous[match.startIndex] == "." {
                // previous line leading
                if let number: Int = previous.leadingNumber(end: match.startIndex.utf16Offset(in: line) - 1) {
                    parts.append(number)
                }

                // previous line trailing
                if let number: Int = previous.trailingNumber(start: match.endIndex.utf16Offset(in: line)) {
                    parts.append(number)
                }
            } else if let number: Int = previous.middleNumber(midpoint: match.startIndex.utf16Offset(in: line)) {
                parts.append(number)
            }
        }

        // next line
        if index < lines.count - 1 {
            let next: String = lines[index + 1]

            if next[match.startIndex] == "." {
                // next line leading
                if let number: Int = next.leadingNumber(end: match.startIndex.utf16Offset(in: line) - 1) {
                    parts.append(number)
                }

                // next line trailing
                if let number: Int = next.trailingNumber(start: match.endIndex.utf16Offset(in: line)) {
                    parts.append(number)
                }
            } else if let number: Int = next.middleNumber(midpoint: match.startIndex.utf16Offset(in: line)) {
                parts.append(number)
            }
        }

        if parts.count == 2 {
            sumForPart2 += parts[0] * parts[1]
        }
    }
}

print("Part 2:", sumForPart2)
