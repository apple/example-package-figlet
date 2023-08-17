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

import Foundation

public enum Figlet {
    public static func say(_ text: String) {
        guard let figletFileURL = Bundle.module.url(forResource: "standard", withExtension: "flf") else {
            fatalError("invalid figlet font file: missing resource")
        }
        guard let figletFile = FigletFile.from(url: figletFileURL) else {
            fatalError("invalid figlet font file: invalid file")
        }
        guard let font = Font.from(file: figletFile) else {
            fatalError("invalid figlet font file: invalid font")
        }

        for line in 0 ..< font.height {
            for c in text {
                if let fontCharacter = font.characters[c], line < fontCharacter.lines.count {
                    print(fontCharacter.lines[line], separator: "", terminator: "")
                }
            }
            print("")
        }
    }
}
