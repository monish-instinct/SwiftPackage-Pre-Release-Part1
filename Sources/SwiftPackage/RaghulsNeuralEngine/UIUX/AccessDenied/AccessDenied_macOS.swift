//
//  AccessDenied / visionOS & macOS.swift
//  UIUX
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 17/03/24.
//
#if os(macOS) || os(visionOS)
import Foundation
import SwiftUI

struct AccessDenied: View{
    var body: some View {
        VStack{
            Text("Access Denied")
        }
    }
}

func blockUIUXaccess(_ reason: String){
    AccessDenied()
}

#endif


