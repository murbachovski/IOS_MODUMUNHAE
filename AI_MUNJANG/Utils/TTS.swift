//
//  TTS.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/08/12.
//

import Foundation
import AVFoundation

class TTS: NSObject, AVSpeechSynthesizerDelegate {
    let speech = AVSpeechSynthesizer()
    var voice: AVSpeechSynthesisVoice!
    var utterance: AVSpeechUtterance!
    var completion: (() -> Void)?
    
    var voiceToUse: AVSpeechSynthesisVoice?
    
    override init() {
        super.init()
        speech.delegate = self
    }
    func setText(_ s: String, complete: (() -> Void)?) {
        completion = complete
        utterance = AVSpeechUtterance(string: s)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.4
        speakVoice()
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .allowBluetooth)
    }
    
    func speakVoice() {
        speech.speak(utterance)
    }
    
    func stopSpeak() {
        
    }
    @available(iOS 7.0, *)
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance){
        
    }

    @available(iOS 7.0, *)
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance){
        completion!()
    }

    @available(iOS 7.0, *)
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance){
        
    }

    @available(iOS 7.0, *)
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance){
        
    }

    @available(iOS 7.0, *)
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance){
        
    }
    
    func voiceTTS() {
        for voice in AVSpeechSynthesisVoice.speechVoices()
            {
                print("\(voice.name)")
                if voice.name == "Susan (Enhanced)" {
                    self.voiceToUse = voice
                }
            }

            let textToSpeak = "안녕하세요"
            if (!textToSpeak.isEmpty)
            {
                let speechSynthesizer = AVSpeechSynthesizer()
                let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: textToSpeak)
                speechUtterance.voice = self.voiceToUse
                speechSynthesizer.speak(speechUtterance)
            }
    }
    
    
}
