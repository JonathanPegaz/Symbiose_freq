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
    @StateObject var bleController:BLEController = BLEController()
    
    @StateObject var bleObservable:BLEObservable = BLEObservable()
    
    @State var spheroConnection = "sphero pas connecté"
    @State var appact3 = "app pas connecté"
    
    @State var freq:String = ""
    
    @State var isPlaying = false
    
    var body: some View {
        VStack {
            Text("Frequency : " + freq)
            Text(spheroConnection)
            Text(appact3)
            Button("play"){
                spheroSensorControl.load()
                myUnit.enableSpeaker()
                isPlaying = true
            }
            Button("stop"){
                myUnit.stop()
                isPlaying = false
            }
            
        }
        .padding()
        .onAppear(){
            bleController.load()
        }
        .onChange(of: bleController.bleStatus, perform: { newValue in
            SharedToyBox.instance.searchForBoltsNamed(["SB-808F"]) { err in
                if err == nil {
                    spheroConnection = (SharedToyBox.instance.bolt?.peripheral?.name)!
                    bleObservable.startScann()
                    
                }
               
            }
        })
        .onChange(of: bleObservable.bleStatus, perform: { newValue in
            
            print(newValue)
            
            if newValue == "go" {
                spheroSensorControl.load()
            }
            if newValue == "reset" {
                SharedToyBox.instance.bolt?.sensorControl.disable()
                myUnit.stop()
                isPlaying = false
            }
            
            if newValue == "endact3" {
                myUnit.stop()
            }
            
    
            bleObservable.bleStatus = ""
        })
        .onChange(of: bleObservable.connectedPeripheral, perform: { newValue in
            if let p = newValue {
                appact3 = p.name
                bleObservable.listen { r in
                    print(r)
                }
            }
        })
        .onChange(of: spheroSensorControl.isShaking, perform: { newValue in
            if(newValue == true && isPlaying == false){
                myUnit.enableSpeaker()
                isPlaying = true
            }
        })
        .onChange(of: spheroSensorControl.orientation) { newValue in
            if(isPlaying == true) {
                SharedToyBox.instance.bolt!.clearMatrix()
                if(newValue > 40) {
                    myUnit.setFrequency(freq: 397)
                    self.freq = "397"
                    SharedToyBox.instance.bolt!.setMainLed(color: .green)
                }
                else if(newValue > 20) {
                    myUnit.setFrequency(freq: 375)
                    self.freq = "375"
                    SharedToyBox.instance.bolt!.setMainLed(color: .cyan)
                }
                else if (newValue > 0){
                    myUnit.setFrequency(freq: 371)
                    self.freq = "371"
                    SharedToyBox.instance.bolt!.setMainLed(color: .purple)
                }
                else if(newValue > -20) {
                    myUnit.setFrequency(freq: 355)
                    self.freq = "355"
                    SharedToyBox.instance.bolt!.setMainLed(color: .yellow)
                }
                else if(newValue > -40) {
                    myUnit.setFrequency(freq: 300)
                    self.freq = "300"
                    SharedToyBox.instance.bolt!.setMainLed(color: .orange)
                }
                else if(newValue > -60) {
                    myUnit.setFrequency(freq: 274)
                    self.freq = "274"
                    SharedToyBox.instance.bolt!.setMainLed(color: .red)
                }
                
                myUnit.setToneVolume(vol: 10)
                myUnit.setToneTime(t: 20000)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
