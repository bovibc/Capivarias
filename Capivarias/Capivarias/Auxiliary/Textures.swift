//
//  Textures.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 19/10/23.
//

import Foundation
import SpriteKit

struct Textures {

    static func getTextures(atlas: String) -> [SKTexture] {
        let atlas = SKTextureAtlas(named: atlas)
        var textures: [SKTexture] = []
        let name = atlas.textureNames.sorted { name1, name2 in
            return name1<name2
        }
        for i in name {
            let texture = atlas.textureNamed(i)
            texture.filteringMode = .nearest
            textures.append(texture)
        }

        return textures
    }
}
