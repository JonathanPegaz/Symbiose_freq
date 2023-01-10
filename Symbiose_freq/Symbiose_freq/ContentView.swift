//
//  ContentView.swift
//  Symbiose_freq
//
//  Created by Jonathan Pegaz on 10/01/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var myUnit = ToneOutputUnit()
    @StateObject var spheroSensorControl:SpheroSensorControl = SpheroSensorControl()
    
    @State var freq:String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Frequency : " + freq)
        }
        .padding()
        .onAppear(){
            SharedToyBox.instance.searchForBoltsNamed(["SB-808F"]) { err in
                if err == nil {
                    spheroSensorControl.load()
                    myUnit.enableSpeaker()
                }
               
            }
        }
        .onChange(of: spheroSensorControl.orientation) { newValue in
            SharedToyBox.instance.bolt!.clearMatrix()
            if(newValue < -60) {
                myUnit.setFrequency(freq: 300)
                self.freq = "300"
                SharedToyBox.instance.bolt!.setMainLed(color: .red)
            }
            else if(newValue < -40) {
                myUnit.setFrequency(freq: 315)
                self.freq = "315"
                SharedToyBox.instance.bolt!.setMainLed(color: .orange)
            }
            else if(newValue < -20) {
                myUnit.setFrequency(freq: 330)
                self.freq = "330"
                SharedToyBox.instance.bolt!.setMainLed(color: .yellow)
            }
            else if(newValue > 60) {
                myUnit.setFrequency(freq: 400)
                self.freq = "400"
                SharedToyBox.instance.bolt!.setMainLed(color: .blue)
            }
            else if(newValue > 40) {
                myUnit.setFrequency(freq: 375)
                self.freq = "375"
                SharedToyBox.instance.bolt!.setMainLed(color: .green)
            }
            else if(newValue > 20) {
                myUnit.setFrequency(freq: 360)
                self.freq = "360"
                SharedToyBox.instance.bolt!.setMainLed(color: .cyan)
            }
            else {
                myUnit.setFrequency(freq: 345)
                self.freq = "345"
                SharedToyBox.instance.bolt!.setMainLed(color: .purple)
            }
            myUnit.setToneVolume(vol: 10)
            myUnit.setToneTime(t: 20000)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
