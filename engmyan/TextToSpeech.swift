//
//  TextToSpeech.swift
//  engmyan
//
//  Created by New Wave Technology on 1/10/18.
//  Copyright © 2018 Soe Minn Minn. All rights reserved.
//

import AVFoundation

class TextToSpeech : NSObject {
    let synth = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        synth.delegate = self
    }
    
    func speak(_ announcement: String) {
        prepareAudioSession()
        let utterance = AVSpeechUtterance(string: announcement.lowercased())
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
    }
    
    private func prepareAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: .mixWithOthers)
        } catch {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    func stop() {
        if synth.isSpeaking {
            synth.stopSpeaking(at: .immediate)
        }
    }
}

extension TextToSpeech : AVSpeechSynthesizerDelegate {
    
}
