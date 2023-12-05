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
    
    var songs = Sounds()
    
    var enviromentPlayer: AVAudioPlayer?
    var effectPlayer: AVAudioPlayer?
    
    @Published var enviromentSong: Bool = true
    @Published var effectPlayerSong: Bool = true
    
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
    
    
    static let shared = AudioPlayer()
    
    
    private init() {}
    
    func playEnviroment(sound: String, type: String, volume: Float){
        
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                enviromentPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                enviromentPlayer?.volume = enviromentVolume * volume
                enviromentPlayer?.numberOfLoops = -1 //loops sound
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
    
    func stopMusic(songEnviroment: AVAudioPlayer){
        songEnviroment.stop()
    }
    
    
    func EnviromentSong(){
        if !AudioPlayer.shared.enviromentSong {
            guard let enviromentPlayer else {return}
            AudioPlayer.shared.stopMusic(songEnviroment: enviromentPlayer)
        } else {
            AudioPlayer.shared.playEnviroment(sound: songs.ambient, type: "mp3", volume: 1.0)
        }
    }
    
    
    func playerEffectSong(songs: String){
       
        if !AudioPlayer.shared.effectPlayerSong {
            guard let effectPlayer else {return}
            AudioPlayer.shared.stopMusic(songEnviroment: effectPlayer)
           
        } else {
            AudioPlayer.shared.playEffect(effect: songs, type: "mp3", volume: 1.0)
        }
    
    }
    
}

