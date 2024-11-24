//
//  SwiftUIView.swift
//  Jan11Game23pm
//
//  Created by Дмитрий Докукин on 18/01/2020.
//  Copyright © 2020 Дмитрий Докукин. All rights reserved.
//

import SwiftUI
import SpriteKit
import UIKit

struct SwiftUIView: View {
    
    var view = SKView()
    var size = CGSize()
    var body: some View {
        Button (action: {
            
            let transition = SKTransition.flipVertical(withDuration: 1)
            let gameScene = GameScene(size: self.size)
            self.view.presentScene(gameScene, transition: transition)
        }) {
            
                HStack {
                    Image(systemName: "trash")
                        .font(.title)
                    Text("Delete")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(40)
            }
        }
    }


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
