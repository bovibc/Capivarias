//
//  Menu.swift
//  Capivarias
//
//  Created by Renan Tavares on 24/11/23.
//

import SwiftUI

struct Menu: View {
    let backGround = Assets()
    var body: some View {
        ZStack {
            Image(backGround.map3)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    Menu()
}
