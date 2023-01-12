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
            bleController.load()
        }
        .onChange(of: bleController.bleStatus, perform: { newValue in
            SharedToyBox.instance.searchForBoltsNamed(["SB-808F"]) { err in
                if err == nil {
                    bleObservable.startScann()
                    
                }
               
            }
        })
        .onChange(of: bleObservable.bleStatus, perform: { newValue in
            
            print(newValue)
            
            if newValue == "go" {
                spheroSensorControl.load()
                myUnit.enableSpeaker()
            }
            
            if newValue == "endact3" {
                myUnit.stop()
            }
        })
        .onChange(of: bleObservable.connectedPeripheral, perform: { newValue in
            print("connecté")
            if let p = newValue {
                print(p.name)
                bleObservable.listen { r in
                    print(r)
                }
            }
        })
        .onChange(of: spheroSensorControl.orientation) { newValue in
            SharedToyBox.instance.bolt!.clearMatrix()
            

            if(newValue > 40) {
                myUnit.setFrequency(freq: 375)
                self.freq = "373"
                SharedToyBox.instance.bolt!.setMainLed(color: .green)
            }
            else if(newValue > 20) {
                myUnit.setFrequency(freq: 360)
                self.freq = "371"
                SharedToyBox.instance.bolt!.setMainLed(color: .cyan)
            }
            else if (newValue > 0){
                myUnit.setFrequency(freq: 345)
                self.freq = "369"
                SharedToyBox.instance.bolt!.setMainLed(color: .purple)
            }
            else if(newValue > -20) {
                myUnit.setFrequency(freq: 371)
                self.freq = "364"
                SharedToyBox.instance.bolt!.setMainLed(color: .yellow)
            }
            else if(newValue > -40) {
                myUnit.setFrequency(freq: 355)
                self.freq = "355"
                SharedToyBox.instance.bolt!.setMainLed(color: .orange)
            }
            else if(newValue > -60) {
                myUnit.setFrequency(freq: 300)
                self.freq = "300"
                SharedToyBox.instance.bolt!.setMainLed(color: .red)
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
