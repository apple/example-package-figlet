//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===--------------------------------------------------------------------

// This code is take from https://github.com/dfreniche/SwiftFiglet/, license as follows:

/*

MIT - Licence

Copyright (c) 2020 Diego Freniche

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

import Foundation

extension Figlet {
    public struct Font {
        /// Loads a Figlet font file and returns a fully loaded, ready to use `SFKFont` object
        /// - Parameter url: URL to the font file
        static func from(url: URL) -> Self? {
            FigletFile.from(url:  url).flatMap(Self.from(file:))
        }

        /// Loads a Figlet font file and returns a fully loaded, ready to use `SFKFont` object
        /// - Parameter file: font file name path including extension
        static func from(fileName: String) -> Self? {
            FigletFile.from(fileName: fileName).flatMap(Self.from(file:))
        }

        /// Given a Figlet font file already loaded returns a ready to use `SFKFont` object
        static func from(file figletFile: FigletFile) -> Self? {
            var height = figletFile.header.height

            var nextASCIIChar = 32 // 32 is Space

            //        let separator = figletFile.characterLineTerminator()

            var arrayLines = [String]()
            var characters = [Character: Char]()
            for line in figletFile.lines {
                let fontLine: Substring

                if arrayLines.count < height - 1 {
                    // remove last @
                    fontLine = line.dropLast()
                } else {
                    // remove last @@
                    fontLine = line.dropLast().dropLast()
                }
                arrayLines.append(String(fontLine.replacingOccurrences(of: String(figletFile.header.hardBlank), with: " ")))

                // last line
                if arrayLines.count == height {
                    let char = Char(charLines: arrayLines)
                    characters[Character(UnicodeScalar(nextASCIIChar) ?? " ")] = char
                    height = char.height

                    nextASCIIChar = nextASCIIChar + 1
                    arrayLines = []
                }
            }

            return Self(figletFile: figletFile, height: height, characters: characters)
        }

        private let figletFile: FigletFile
        public let height: Int
        public let characters: [Character: Char]

        init(figletFile: FigletFile, height: Int, characters: [Character: Char]) {
            self.figletFile = figletFile
            self.height = height
            self.characters = characters
        }
    }
}

extension Figlet {
    public struct Char {
        /// Represents an empty Character
        public static let EmptyChar = Self(charLines: [])

        /// height in lines of this Character
        public let height: Int

        /// lines, from top to bottom that made up this Character
        public let lines: [String]

        public init(charLines: [String]) {
            self.lines = charLines
            self.height = charLines.count
        }
    }
}
