//
//  AudioPlayerController.swift
//  Capivarias
//
//  Created by Guilherme Ferreira Lenzolari on 24/10/23.
//

import Foundation
import AVKit
import AVFoundation


class AudioPlayer: ObservableObject {
    
    @Published var enviromentPlayer: AVAudioPlayer?
    @Published var effectPlayer: AVAudioPlayer?
    
    @Published var enviromentVolume: Float = 1.0
    @Published var effectsVolume: Float = 1.0
    
    func playEnviroment (sound: String, type: String){
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                enviromentPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                enviromentPlayer?.volume = enviromentVolume
                enviromentPlayer?.numberOfLoops = -1
                enviromentPlayer?.play()
            } catch {
                print ("Audio Player ERROR")
            }
        }

    func playEffect (effect: String, type: String){
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                effectPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                effectPlayer?.volume = effectsVolume
                effectPlayer?.play()
            } catch {
                print ("Audio Player ERROR")
            }
        }
            
            
        }
    }
}
