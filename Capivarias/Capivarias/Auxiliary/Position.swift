//
//  RandomPosition.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 16/11/23.
//

import Foundation

struct Position {
    static func randomize(_ size: CGSize) -> CGPoint {
        let random = Int.random(in: 0..<8)
        switch random {
        case 0:
            return CGPoint(x: size.width/2, y: size.height/3)
        case 1:
            return CGPoint(x: size.width/2, y: size.height/4)
        case 2:
            return CGPoint(x: size.width/1.5, y: size.height/4)
        case 3:
            return CGPoint(x: size.width/2, y: size.height/2)
        case 4:
            return CGPoint(x: size.width/5, y: size.height/5)
        case 5:
            return CGPoint(x: size.width/5, y: size.height/1.5)
        case 6:
            return CGPoint(x: size.width/4, y: size.height/3)
        case 7:
            return CGPoint(x: size.width/1.5, y: size.height/1.5)
        default:
            return CGPoint(x: size.width/5, y: size.height/5)
        }
    }
}
