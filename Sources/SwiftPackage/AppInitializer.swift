//
//  AppInitializer.swift
//  RD Vivaha Jewellers
//
//  Created by Raghul S on 01/03/24.
//

import Foundation

class Initializer: ObservableObject{
    init() {
        Timezone.checkAllDateTimeFunctions()
        Network.logIP()
        Network.logAPIIP()
    }
}
