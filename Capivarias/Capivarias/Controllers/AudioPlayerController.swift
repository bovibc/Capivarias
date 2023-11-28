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
        
    @Published
    var enviromentVolume: Float = 1.0 {
        didSet {
            enviromentPlayer?.volume = enviromentVolume
        }
    }

    @Published
    var effectsVolume: Float = 1.0 {
        didSet {
            effectPlayer?.volume = effectsVolume
        }
    }

    func playEnviroment(sound: String, type: String, volume: Float){
                
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                enviromentPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                enviromentPlayer?.volume = enviromentVolume * volume
                enviromentPlayer?.numberOfLoops = -1
                enviromentPlayer?.play()
            } catch {
                print ("Audio Player ERROR")
            }
        }
    }

    func playEffect(effect: String, type: String, volume: Float){
        if let path = Bundle.main.path(forResource: effect, ofType: type) {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)
                effectPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                effectPlayer?.volume = effectsVolume * volume
                effectPlayer?.prepareToPlay()
                effectPlayer?.play()
            } catch {
                print ("Audio Player ERROR")
            }
        }
    }
    
}

