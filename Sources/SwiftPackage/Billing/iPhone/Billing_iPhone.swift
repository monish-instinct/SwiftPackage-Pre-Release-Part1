//
//  ContentView.swift
//  RD Vivaha Jewellers
//
//  Created by Raghul S on 31/12/23.
//

#if os(iOS)

import SwiftUI
import CodeScanner

struct Billing :View {
    
    @State var ispersentingScanner = false
    @State var scannedCode: String = "Scan a QR Code to get the LINK."
    var sannerSheet : some View{
        CodeScannerView(
            codeTypes: [.qr],
            completion: {result in
                if case let.success(code) = result {
                    self.scannedCode = code.string
                    self.ispersentingScanner = false
                }
            }
        )
    }
    var body: some View{
        VStack(spacing: 10) {
           Text(scannedCode)
                .padding()
                .background(Color.yellow)
                .foregroundColor(.white)
                .font(.headline)
            
//            Text(locationManager.location)
//                           .padding()
//            Text(locationManager.address) // Display the address
//                           .padding()
            
            Button("scan QR Code"){
                self.ispersentingScanner  = true
                
            }
            .padding()
            .background(Color(red:0,green:0,blue:0.5))
            .clipShape(Capsule())
            
            .sheet(isPresented: $ispersentingScanner){
                self.sannerSheet
            }
            
            Button("Check SystemInfo") {
                cl(User.getDB(),type:"si")
                cl(User.getName(),type:"si")
                cl(User.getQueue(),type:"si")
                cl(User.getOwnComCode(),type:"si")
                
                cl(Device.getModelName(),type:"si")
                cl(Device.getUniqueID(),type:"si")
                cl(Device.getUserName(),type:"si")
                cl(Device.getOSName(),type:"si")
                cl(Device.getOSVersion(),type:"si")
                cl(Device.getStorageSize(),type:"si")
                cl(Device.getFreeSpace(),type:"si")
                cl(Device.getUsedSpace(),type:"si")
                
                #if os(macOS)
                cl(Device.getScreenWidth(),type:"si")
                cl(Device.getScreenHeight(),type:"si")
                #endif
                
                cl(Network.getIPv4(),type:"si")
                cl(Network.getIPv6(),type:"si")
                cl(Network.getIP(),type:"si")
                cl(Network.getLocation(),type:"si")
                cl(Network.getISP(),type:"si")
                cl(Network.publicIPbasedDetils_ipinfoIoAPIToken,type:"si")
                
//                cl(locationManager.location,type:"si")
//                cl(locationManager.address,type:"si")
                cl(GPS.getLatitude(),type:"si")
                cl(GPS.getLongitude(),type:"si")
                cl(GPS.getAltitude(),type:"si")
                cl(GPS.getAddress(),type:"si")
                cl(GPS.getLocationPermissionStatus(),type:"si")
                cl(GPS.getAccuracy(),type:"si")
                
                //cl(getDate(),type:"si")
                //cl(getTime(),type:"si")
            }
            .padding()
        }
            
        }
    }

#endif
