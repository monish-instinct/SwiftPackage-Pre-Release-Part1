//
//  Network.swift
//  SystemInfo
//  Raghul'S Neural Engine
//
//  Created by Raghul S on 02/01/24.
//

import Foundation
import SystemConfiguration
import Network

class Network {
    
    public init(){}
    
    private static var publicIP: String = ""
    private static var publicIPbasedLocation: String? = nil
    private static var publicIPbasedLongitude: String? = nil
    private static var publicIPbasedLatitude: String? = nil
    private static var publicIPbasedISP: String? = nil
    private static var publicIPbasedTimeZone: String? = nil
    private static var publicIPbasedPostalCode: String? = nil
    public static var publicIPbasedDetils_ipinfoIoAPIToken: ipinfoIoAPIToken? = nil
    public static var publicIPbasedDetils_ipdataCo: IPData? = nil
    public static var publicIPbasedDetils_abstractAPIResponse: abstractAPIResponse? = nil
    public static var publicIPbasedDetils_whoisXMLAPIBalance: whoisXMLAPIBalance? = nil
    public static var publicIPbasedDetils_ipRegistryAddressResponse: ipRegistryAddressResponse? = nil
    public static var publicIPbasedDetils_greyNoiseAddressResponse: greyNoiseAddressResponse? = nil
    public static var publicIPbasedDetils_bigDataCloudAddressResponse: bigDataCloudAddressResponse? = nil
    
    static func getIPv6() -> String {
        var address: String = "Unavailable"
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                guard let interface = ptr?.pointee else { continue }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    let name: String = String(cString: interface.ifa_name)
                    if name == "en0" { // en0is the Wi-Fi interface
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                        break
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
    static func getIPv4()->String{
        var address: String = ""
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) { // IPv4
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let addressString = String(validatingUTF8: hostname) {
                                address = addressString
                                break
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
     
    static func getIP() -> String {
//        let ip = publicIP ?? "IP is nil"
//        return ip
        return publicIP
    }

    
    static func getLocation() -> String? {
        return publicIPbasedLocation
    }
    
    static func getLongitude() -> String? {
        return publicIPbasedLongitude
    }
    
    static func getLatitude() -> String? {
        return publicIPbasedLatitude
    }
    
    static func getCoordinates() -> String? {
        guard let latitude = getLatitude(), let longitude = getLongitude() else {
            return nil
        }
        return "\(latitude),\(longitude)"
    }
    
    static func getISP() -> String? {
        return publicIPbasedISP
    }
    
    static func getTimeZone() -> String? {
        return publicIPbasedTimeZone
    }
    
    static func getPostalCode() -> String? {
        return publicIPbasedPostalCode
    }
    
    static var monitor: NWPathMonitor?
    
    static func updatePublicIP() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            if path.status == .satisfied {
                if path.isExpensive {
                    // Connected to the internet but using an expensive connection (e.g., cellular)
                    DispatchQueue.main.async {
                        // Implement your function calls here, for example:
                        // Randomly select 3 functions to call
                        let functions = [updatePublicIPwithhttpbinOrgSlashIp,updatePublicIPFromIpifyOrg,getQueryFromIpApiCom,getIPFromMyExternalIp,getIPFromIpinfoIo,getIPFromIcanhazipCom,getIPFromIfconfigCo,getIPFromIpechoNet,getIPFromIfconfigMe]
                        let selectedFunctions = functions.shuffled().prefix(3)
                        for function in selectedFunctions {
                            function()
                        }
                    }
                } else {
                    // Connected to the internet through a non-expensive connection
                    DispatchQueue.main.async {
                        // Implement your function calls here
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if path.availableInterfaces.isEmpty {
                        publicIP = "Not connected to any network"
                    } else {
                        publicIP = "Network not connected to Internet"
                    }
                }
            }
        }
    }
    
    internal static func updatePublicIPwithhttpbinOrgSlashIp(){
        guard let url = URL(string: httpbinOrgSlashIp) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                clSync(error,type:"RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updatePublicIPwithhttpbinOrgSlashIp")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                clSync("Invalid response",type:"RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updatePublicIPwithhttpbinOrgSlashIp ")
                return
            }
            
            guard let data = data else {
                clSync("No data recieved",type:"RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updatePublicIPwithhttpbinOrgSlashIp")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let origin = json["origin"] as? String {
                clSync("IP : \(origin)")
                Network.publicIP = origin
            } else {
                clSync("Unable to parse JSON","RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updatePublicIPwithhttpbinOrgSlashIp")
                return
            }
        }
        task.resume()
    }
    
    internal static func updatePublicIPFromIpifyOrg() {
        guard let url = URL(string: ipifyOrg) else {
        clSync("Invalid URL", type: "URL Error")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            clSync(error, type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updatePublicIPFromIpifyOrg")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            clSync("Invalid response or status code", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updatePublicIPFromIpifyOrg")
            return
        }
        
        guard let data = data else {
            clSync("No data received", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updatePublicIPFromIpifyOrg")
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let origin = json["ip"] as? String {
                clSync("IP :\(origin)")
                Network.publicIP = origin
            } else {
                clSync("IP value not found in JSON (origin key missing)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updatePublicIPFromIpifyOrg")
            }
        } catch {
            clSync("Error parsing JSON", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updatePublicIPFromIpifyOrg")
        }
    }
    task.resume()}
    
    internal static func getQueryFromIpApiCom() {
        
        guard let url = URL(string: ipApiCom) else {
            clSync("Invalid URL", type: "URL Error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                clSync(error, type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getQueryFromIpApiCom")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                clSync("Invalid response or status code", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getQueryFromIpApiCom")
                clSync("Response vimal: \(String(describing: response))")
                clSync("Error vimal: \(String(describing: error))")
                return
            }
            
            guard let data = data else {
                clSync("No data received", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getQueryFromIpApiCom")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let query = json["query"] as? String {
                    clSync("IP: \(query)") // Do something with the query value
                } else {
                    clSync("IP value not found in JSON", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] getQueryFromIpApiCom")
                }
            } catch {
                clSync(error, type: "JSON Parsing Error")
            }
        }
        task.resume()
    }
    
    internal static func getIPFromMyExternalIp() {
        
        guard let url = URL(string: myExternalIp) else {
            clSync("Invalid URL", type: "URL Error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                clSync(error, type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromMyExternalIp")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                clSync("Invalid response or status code", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromMyExternalIp")
                return
            }
            
            guard let data = data else {
                clSync("No data received", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromMyExternalIp")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let ip = json["ip"] as? String {
                    clSync("IP: \(ip)") // Do something with the IP address
                } else {
                    clSync("IP value not found in JSON", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] getIPFromMyExternalIp")
                }
            } catch {
                clSync(error, type: "JSON Parsing Error")
            }
        }
        task.resume()
    }
    
    internal static func getIPFromIpinfoIo() {
        
        guard let url = URL(string: ipinfoIo) else {
            clSync("Invalid URL", type: "URL Error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                clSync(error, type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIpinfoIo")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                clSync("Invalid response or status code", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIpinfoIo")
                return
            }
            
            guard let data = data else {
                clSync("No data received", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIpinfoIo ")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let ip = json["ip"] as? String {
                    clSync("IP: \(ip)") // Do something with the IP address
                } else {
                    clSync("IP value not found in JSON", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] getIPFromIpinfoIo")
                }
            } catch {
                clSync(error, type: "JSON Parsing Error")
            }
        }
        task.resume()
    }
    
    internal static func getIPFromIcanhazipCom() {
        
        guard let url = URL(string: icanhazipCom) else {
            clSync("Invalid URL", type: "URL Error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                clSync(error, type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIcanhazipCom")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                clSync("Invalid response or status code", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIcanhazipCom")
                return
            }
            
            guard let data = data else {
                clSync("No data received", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIcanhazipCom")
                return
            }
            
            if let ipString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                clSync("IP: \(ipString)") // Do something with the IP address
            } else {
                clSync("Unable to convert data to IP string", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] getIPFromIcanhazipCom")
            }
        }
        task.resume()
    }
    
    internal static func getIPFromIfconfigCo() {
        guard let url = URL(string: ipConFig) else {
            clSync("Invalid URL", type: "URL Error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                clSync(error, type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIfconfigCo")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                clSync("Invalid response or status code", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIfconfigCo")
                return
            }
            
            guard let data = data else {
                clSync("No data received", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIfconfigCo")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let ip = json["ip"] as? String {
                    clSync("IP: \(ip)") // Do something with the IP address
                } else {
                    clSync("IP value not found in JSON", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] getIPFromIfconfigCo")
                }
            } catch {
                clSync(error, type: "JSON Parsing Error")
            }
        }
        task.resume()
    }
    
    internal static func getIPFromIpechoNet() {
        guard let url = URL(string: ipEchoCom) else {
            clSync("Invalid URL", type: "URL Error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                clSync(error, type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIpechoNet")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                clSync("Invalid response or status code", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIpechoNet")
                return
            }
            
            guard let data = data else {
                clSync("No data received", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIpechoNet")
                return
            }
            
            if let ipString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                clSync("IP: \(ipString)") // Do something with the IP address
            } else {
                clSync("Unable to convert data to IP string", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] getIPFromIpechoNet")
            }
        }
        task.resume()
    }
    
    internal static func getIPFromIfconfigMe() {
        guard let url = URL(string: ifconfigMe) else {
            clSync("Invalid URL", type: "URL Error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                clSync(error, type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIfconfigMe")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                clSync("Invalid response or status code", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIfconfigMe")
                return
            }
            
            guard let data = data else {
                clSync("No data received", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] getIPFromIfconfigMe")
                return
            }
            
            if let ipString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                clSync("IP: \(ipString)") // Do something with the IP address
            } else {
                clSync("Unable to convert data to IP string", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] getIPFromIfconfigMe")
            }
        }
        task.resume()
    }
    
    static func logIP(){
        updatePublicIPFromIpifyOrg()
        updatePublicIPwithhttpbinOrgSlashIp()
        getQueryFromIpApiCom()
        getIPFromMyExternalIp()
        getIPFromIpinfoIo()
        getIPFromIcanhazipCom()
        getIPFromIfconfigCo()
        getIPFromIpechoNet()
        getIPFromIfconfigMe()
    }
    
    static func updateAdress(){
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            if path.status == .satisfied {
                if path.isExpensive {
                    // Connected to the internet but using an expensive connection (e.g., cellular)
                    DispatchQueue.main.async {
                        // Implement your function calls here, for example:
                        // Randomly select 3 functions to call
                        let functions = [updateAddressFromipinfoIoAPIToken1,updateAddressFromipinfoIoAPIToken2,updateAddressFromipDataCoAccessToken1,updateAddressFromipDataCoAccessToken2,updateAddressFromabstractAPIIPGeolocationAPIAccessToken1,updateAddressFromabstractAPIIPGeolocationAPIAccessToken2,updateAddressFromwhoisXMLAPIAccessToken1,updateAddressFromwhoisXMLAPIAccessToken2,updateAddressFromipRegisteryAccessToken1,updateAddressFromipRegisteryAccessToken2,updateAddressFromgreyNoiseAccessToken1,updateAddressFromgreyNoiseAccessToken2,updateAddressFrombigDataCloudAccessToken1,
                                         updateAddressFrombigDataCloudAccessToken2]
                        let selectedFunctions = functions.shuffled().prefix(3)
                        for function in selectedFunctions {
                            function()
                        }
                    }
                } else {
                    // Connected to the internet through a non-expensive connection
                    DispatchQueue.main.async {
                        // Implement your function calls here
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if path.availableInterfaces.isEmpty {
                        publicIP = "Not connected to any network"
                    } else {
                        publicIP = "Network not connected to Internet"
                    }
                }
            }
        }
        
    }
    

 
    
    internal static func updateAddressFromipinfoIoAPIToken1(){
        // Your IPInfo API access token
        let accessToken = ipinfoIoAccessToken1//Raghul's Access Token
        
        // The IPInfo API URL
        let urlString = "\(ipinfoIo)?token=\(accessToken)"//https://ipinfo.io
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Check for errors
                if let error = error {
                    clSync("Couldn't fetch data: \(error)",type:"RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error  [s~1] updateAddressFromipinfoIoAPIToken1",line: #line)
                    return
                }
                
                // Ensure there is data returned
                guard let data = data else {
                    clSync("No data returned",type:"RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipinfoIoAPIToken1",line: #line)
                    return
                }
                
                // Attempt to decode the data as JSON
                do {
                    // Decode the JSON data, ensuring optional values are handled correctly
                    let decodedData = try JSONDecoder().decode(ipinfoIoAPIToken.self, from: data)

 // Print for debugging
                    // Prepare the output strings
                    var ipOutput = "RAziyaip: \(decodedData.ip)"
                    var cityOutput = "city: \(decodedData.city)"
                    var regionOutput = "region: \(decodedData.region)"
                    var countryOutput = "country: \(decodedData.country)"
                    var locOutput = "loc: \(decodedData.loc)"
                    var postalOutput = "postal: \(decodedData.postal)"
                    var timezoneOutput = "timezone: \(decodedData.timezone)"

                    // Handle ASN (if present)
                    var asnOutput = ""
                    if let asn = decodedData.asn {
                        asnOutput = """
                        asn: \(asn.asn)
                        name: \(asn.name)
                        domain: \(asn.domain)
                        route: \(asn.route)
                        type: \(asn.type)
                        """
                    }

                    // Similarly handle Company, Privacy, Abuse, Domains (if present)
                    // ...

                    // Combine all output strings
                    let formattedOutput = """
                    \(ipOutput)
                    \(cityOutput)
                    \(regionOutput)
                    \(countryOutput)
                    \(locOutput)
                    \(postalOutput)
                    \(timezoneOutput)
                    \(asnOutput)
                    """

                    // Print the formatted output
                    clSync(formattedOutput)
                }  catch {
                    clSync("Couldn't decode JSON: \(error)",type:"RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromipinfoIoAPIToken1",line: #line)
                }
            }
            
            // Start the task
            task.resume()
        }
    }
    internal static func updateAddressFromipinfoIoAPIToken2(){
        // Your IPInfo API access token
        let accessToken = ipinfoIoAccessToken2//Shahina's Access Token
        
        // The IPInfo API URL
        let urlString = "\(ipinfoIo)?token=\(accessToken)"//https://ipinfo.io
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Check for errors
                if let error = error {
                    clSync("Couldn't fetch data: \(error)",type:"RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipinfoIoAPIToken2",line: #line)
                    return
                }
                
                // Ensure there is data returned
                guard let data = data else {
                    clSync("No data returned",type:"RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipinfoIoAPIToken2",line: #line)
                    return
                }
                
                // Attempt to decode the data as JSON
                do {
                    // Decode the JSON data, ensuring optional values are handled correctly
                    let decodedData = try JSONDecoder().decode(ipinfoIoAPIToken.self, from: data)

 // Print for debugging
                    // Prepare the output strings
                    var ipOutput = "ip: \(decodedData.ip)"
                    var cityOutput = "city: \(decodedData.city)"
                    var regionOutput = "region: \(decodedData.region)"
                    var countryOutput = "country: \(decodedData.country)"
                    var locOutput = "loc: \(decodedData.loc)"
                    var postalOutput = "postal: \(decodedData.postal)"
                    var timezoneOutput = "timezone: \(decodedData.timezone)"

                    // Handle ASN (if present)
                    var asnOutput = ""
                    if let asn = decodedData.asn {
                        asnOutput = """
                        asn: \(asn.asn)
                        name: \(asn.name)
                        domain: \(asn.domain)
                        route: \(asn.route)
                        type: \(asn.type)
                        """
                    }

                    // Similarly handle Company, Privacy, Abuse, Domains (if present)
                    // ...

                    // Combine all output strings
                    let formattedOutput = """
                    \(ipOutput)
                    \(cityOutput)
                    \(regionOutput)
                    \(countryOutput)
                    \(locOutput)
                    \(postalOutput)
                    \(timezoneOutput)
                    \(asnOutput)
                    """

                    // Print the formatted output
                    clSync(formattedOutput)
                }catch {
                    clSync("Couldn't decode JSON: \(error)",type:"RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromipinfoIoAPIToken2",line: #line)
                }
            }
            
            // Start the task
            task.resume()
        }
    }
    //updateAddressFromipinfoIoAPIToken - Completely Done
    internal static func updateAddressFromipDataCoAccessToken1() {
        // Your ipdata.co API access token
         //Shahina's Access Key
        // The ipdata.co API URL
        let urlString = "https://api.ipdata.co/?api-key=\(ipDataCoAccessToken1)"
        clSync(urlString,#line)
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Check for errors
                if let error = error {
                    clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipDataCoAccessToken1",line: #line)
                    return
                }
                
                // Ensure there is data returned
                guard let data = data else {
                    clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipDataCoAccessToken1",line: #line)
                    return
                }
                
                // Attempt to decode the data as JSON
                do {
                    // Decode the JSON data (using the 'ipdataCo' struct below)
                    let decoded = try JSONDecoder().decode(IPData.self, from: data)
                    clSync("cahnchal\(decoded)")
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromipDataCoAccessToken1",line: #line)
                }
            }
            
            // Start the task
            task.resume()
        }
    }
    internal static func updateAddressFromipDataCoAccessToken2(){
        // Your ipdata.co API access token
        _ = ipDataCoAccessToken2 //Chanchal's Access Key
        // The ipdata.co API URL
        let urlString = "https://api.ipdata.co/?api-key=4ef18676a739598c84f78163a41f7dbbc86fc3b1e2f184275cf04d2d"

        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Check for errors
                if let error = error {
                    clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1]updateAddressFromipDataCoAccessToken2",line: #line)
                    return
                }
                
                // Ensure there is data returned
                guard let data = data else {
                    clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromipDataCoAccessToken1",line: #line)
                    return
                }
                
                // Attempt to decode the data as JSON
                do {
                    // Decode the JSON data (using the 'ipdataCo' struct below)
                    let decoded = try JSONDecoder().decode(IPData.self, from: data)
                    clSync("cahnchal\(decoded)")
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1]updateAddressFromipDataCoAccessToken1",line: #line)
                }
            }
            
            // Start the task
            task.resume()
        }
    }
    //Not Done Completely - Error in Parse Decoding Json
    internal static func updateAddressFromabstractAPIIPGeolocationAPIAccessToken1(){
        // Your Abstract API IP Geolocation API access token
        let accessToken = abstractAPIIPGeolocationAPIAccessToken1 // Shahina's Token
        
        // The Abstract API IP Geolocation API URL
        let urlString = "\(abstractAPIIPGeolocationAPI)?api_key=\(accessToken)"
        clSync("\(urlString)jall")
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Check for errors
                if let error = error {
                    clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromabstractAPIIPGeolocationAPIAccessToken1",line: #line)
                    return
                }
                
                // Ensure there is data returned
                guard let data = data else {
                    clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromabstractAPIIPGeolocationAPIAccessToken1",line: #line)
                    return
                }
                clSync("manikam \(data)")
                
                // Attempt to decode the data as JSON
                do {
                    // Decode the JSON data (using a struct named 'abstractAPIResponse' below)
                    let decodedData = try JSONDecoder().decode(abstractAPIResponse.self, from: data)
                    clSync("chanchal\(decodedData)")
                    
                    // Update your Network properties based on decodedData
                    // ... (You'll need to adjust this based on the structure of abstractAPIResponse)
                    
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromabstractAPIIPGeolocationAPIAccessToken1",line: #line)
                }
            }
            
            // Start the task
            task.resume()
        }}
    internal static func updateAddressFromabstractAPIIPGeolocationAPIAccessToken2(){
        // Your Abstract API IP Geolocation API access token
        let accessToken = abstractAPIIPGeolocationAPIAccessToken2 // Chanchal's API KEY
        
        // The Abstract API IP Geolocation API URL
        let urlString = "\(abstractAPIIPGeolocationAPI)?api_key=\(accessToken)"
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Check for errors
                if let error = error {
                    clSync("Couldn't fetch data: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromabstractAPIIPGeolocationAPIAccessToken2",line: #line)
                    return
                }
                
                // Ensure there is data returned
                guard let data = data else {
                    clSync("No data returned", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] Network Error [s~1] updateAddressFromabstractAPIIPGeolocationAPIAccessToken2",line: #line)
                    return
                }
                
                // Attempt to decode the data as JSON
                do {
                    // Decode the JSON data (using a struct named 'abstractAPIResponse' below)
                    _ = try JSONDecoder().decode(abstractAPIResponse.self, from: data)
                    
                    // Update your Network properties based on decodedData
                    // ... (You'll need to adjust this based on the structure of abstractAPIResponse)
                    
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] IP-API [s~1] API Error [s~1] updateAddressFromabstractAPIIPGeolocationAPIAccessToken2",line: #line)
                }
            }
            
            // Start the task
            task.resume()
        }}
    //Not Done Completely - Some error in url
    internal static func updateAddressFromwhoisXMLAPIAccessToken1() {
        let accessToken = whoisXMLAPIAccessToken1 // Shahina's token
        
        // Construct the WhoisXMLAPI endpoint URL (you'll need to replace this)
        let urlString = "https://www.whoisxmlapi.com/api/v2?apiKey=\(accessToken)&domainName=example.com&outputFormat=JSON"
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                // Error Handling
                if let error = error {
                    clSync("Couldn't fetch address data: \(error)", type: "RNE [s~1] SystemInfo [s~1] WhoisXMLAPI [s~1] Network Error [s~1] updateAddressFromwhoisXMLAPIAccessToken1",line: #line)
                    return
                }
                
                // Data Validation
                guard let data = data else {
                    clSync("No address data returned", type: "RNE [s~1] SystemInfo [s~1] WhoisXMLAPI [s~1] Network Error [s~1] updateAddressFromwhoisXMLAPIAccessToken1",line: #line)
                    return
                }
                
                // JSON Decoding
                do {
                    // Decode JSON using a 'whoisXMLAPIAddressResponse' struct
                    _ = try JSONDecoder().decode(whoisXMLAPIBalance.self, from: data)
                    
                    // Update your Network properties based on decodedData
                    // ... (Adjust this based on the API response structure)
                    
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] WhoisXMLAPI [s~1] API Error [s~1] updateAddressFromwhoisXMLAPIAccessToken1",line: #line)
                }
            }
            task.resume()
        }
    }
    internal static func updateAddressFromwhoisXMLAPIAccessToken2(){
        let accessToken = whoisXMLAPIAccessToken2 // Chanchal's token
        
        // Construct the WhoisXMLAPI endpoint URL (you'll need to replace this)
        let urlString = "https://www.whoisxmlapi.com/api/v2?apiKey=\(accessToken)&domainName=example.com&outputFormat=JSON"
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                // Error Handling
                if let error = error {
                    clSync("Couldn't fetch address data: \(error)", type: "RNE [s~1] SystemInfo [s~1] WhoisXMLAPI [s~1] Network Error [s~1] updateAddressFromwhoisXMLAPIAccessToken2",line: #line)
                    return
                }
                
                // Data Validation
                guard let data = data else {
                    clSync("No address data returned", type: "RNE [s~1] SystemInfo [s~1] WhoisXMLAPI [s~1] Network Error [s~1] updateAddressFromwhoisXMLAPIAccessToken2",line: #line)
                    return
                }
                
                // JSON Decoding
                do {
                    // Decode JSON using a 'whoisXMLAPIAddressResponse' struct
                    _ = try JSONDecoder().decode(whoisXMLAPIBalance.self, from: data)
                    
                    // Update your Network properties based on decodedData
                    // ... (Adjust this based on the API response structure)
                    
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] WhoisXMLAPI [s~1] API Error [s~1] updateAddressFromwhoisXMLAPIAccessToken2",line: #line)
                }
            }
            task.resume()
        }
    }
    //404-Error
    internal static func updateAddressFromipRegisteryAccessToken1() {
        let accessToken = ipRegisteryAccessToken1 // Shahina's Token
        
        // Construct the ipRegistry API endpoint URL (you might need to adjust this)
        let urlString = "\(ipRegistery)?key=\(accessToken)"
        clSync("\(urlString)kall")
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Error Handling
                if let error = error {
                    clSync("Couldn't fetch address data: \(error)", type: "RNE [s~1] SystemInfo [s~1] ipRegistry [s~1] Network Error [s~1] updateAddressFromipRegisteryAccessToken1",line: #line)
                    return
                }
                
                // Data Validation
                guard let data = data else {
                    clSync("No address data returned", type: "RNE [s~1] SystemInfo [s~1] ipRegistry [s~1] Network Error [s~1] updateAddressFromipRegisteryAccessToken1",line: #line)
                    return
                }
                
                // JSON Decoding
                do {
                    // Decode JSON using an 'ipRegistryAddressResponse' struct
                    _ = try JSONDecoder().decode(ipRegistryAddressResponse.self, from: data)
                    
                    // Update your Network properties based on decodedData
                    // ... (Adjust this based on the API response structure)
                    
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] ipRegistry [s~1] API Error [s~1] updateAddressFromipRegisteryAccessToken1",line: #line)
                }
            }
            task.resume()
        }
    }
    internal static func updateAddressFromipRegisteryAccessToken2(){
        let accessToken = ipRegisteryAccessToken2 // Chanchal's token
        
        // Construct the ipRegistry API endpoint URL (you might need to adjust this)
        let urlString = "\(ipRegistery)?key=\(accessToken)"
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // Error Handling
                if let error = error {
                    clSync("Couldn't fetch address data: \(error)", type: "RNE [s~1] SystemInfo [s~1] ipRegistry [s~1] Network Error [s~1] updateAddressFromipRegisteryAccessToken2",line: #line)
                    return
                }
                
                // Data Validation
                guard let data = data else {
                    clSync("No address data returned", type: "RNE [s~1] SystemInfo [s~1] ipRegistry [s~1] Network Error [s~1] updateAddressFromipRegisteryAccessToken2",line: #line)
                    return
                }
                
                // JSON Decoding
                do {
                    // Decode JSON using an 'ipRegistryAddressResponse' struct
                    _ = try JSONDecoder().decode(ipRegistryAddressResponse.self, from: data)
                    
                    // Update your Network properties based on decodedData
                    // ... (Adjust this based on the API response structure)
                    
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] ipRegistry [s~1] API Error [s~1] updateAddressFromipRegisteryAccessToken2",line: #line)
                }
            }
            task.resume()
        }
    }
    //URL error
    internal static func updateAddressFromgreyNoiseAccessToken1() {
        _ = greyNoiseAccessToken1
        // Replace with the actual GreyNoise API endpoint based on your choice
        let urlString = "https://api.greynoise.io/v3/context/ip/(IP_ADDRESS)"
        clSync("\(urlString)ball")
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                // Error Handling
                if let error = error {
                    clSync("Couldn't fetch address data: \(error)", type: "RNE [s~1] SystemInfo [s~1] GreyNoise [s~1] Network Error [s~1] updateAddressFromgreyNoiseAccessToken1",line: #line)
                    return
                }
                
                // Data Validation
                guard let data = data else {
                    clSync("No address data returned", type: "RNE [s~1] SystemInfo [s~1] GreyNoise [s~1] Network Error [s~1] updateAddressFromgreyNoiseAccessToken1",line: #line)
                    return
                }
                
                // JSON Decoding
                do {
                    // Replace with an accurate struct based on the API response
                    let decodedData = try JSONDecoder().decode(greyNoiseAddressResponse.self, from: data)
                    
                    // Update Network object (Adjust based on your Network object structure)
                    Network.publicIPbasedLocation = decodedData.metadata?.city ?? ""
                    
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] GreyNoise [s~1] API Error [s~1] updateAddressFromgreyNoiseAccessToken1",line: #line)
                }
            }
            task.resume()
        }
    }
    internal static func updateAddressFromgreyNoiseAccessToken2(){
        _ = greyNoiseAccessToken2
        // Replace with the actual GreyNoise API endpoint based on your choice
        let urlString = "https://api.greynoise.io/v3/context/ip/(IP_ADDRESS)"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                // Error Handling
                if let error = error {
                    clSync("Couldn't fetch address data: \(error)", type: "RNE [s~1] SystemInfo [s~1] GreyNoise [s~1] Network Error [s~1] updateAddressFromgreyNoiseAccessToken2",line: #line)
                    return
                }
                
                // Data Validation
                guard let data = data else {
                    clSync("No address data returned", type: "RNE [s~1] SystemInfo [s~1] GreyNoise [s~1] Network Error [s~1] updateAddressFromgreyNoiseAccessToken2",line: #line)
                    return
                }
                
                // JSON Decoding
                do {
                    // Replace with an accurate struct based on the API response
                    let decodedData = try JSONDecoder().decode(greyNoiseAddressResponse.self, from: data)
                    
                    // Update Network object (Adjust based on your Network object structure)
                    Network.publicIPbasedLocation = decodedData.metadata?.city ?? ""
                    
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] GreyNoise [s~1] API Error [s~1] updateAddressFromgreyNoiseAccessToken2",line: #line)
                }
            }
            task.resume()
        }
    }
    //URL Error
    internal static func updateAddressFrombigDataCloudAccessToken1() {
        let accessToken = bigDataCloudAccessToken1 // "bdc_63a1338580024f5684b3"
        
        // Construct the BigDataCloud API endpoint URL (might need adjustment)
        let urlString = "\(bigDataCloud)/?key=\(accessToken)"
        clSync("hiji\(urlString)")
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                // Error Handling
                if let error = error {
                    clSync("Couldn't fetch address data: \(error)", type: "RNE [s~1] SystemInfo [s~1] BigDataCloud [s~1] Network Error [s~1] updateAddressFrombigDataCloudAccessToken1",line: #line)
                    return
                }
                
                // Data Validation
                guard let data = data else {
                    clSync("No address data returned", type: "RNE [s~1] SystemInfo [s~1] BigDataCloud [s~1] Network Error [s~1] updateAddressFrombigDataCloudAccessToken1",line: #line)
                    return
                }
                
                // JSON Decoding
                do {
                    // Decode JSON using a 'bigDataCloudAddressResponse' struct
                    _ = try JSONDecoder().decode(bigDataCloudAddressResponse.self, from: data)
                    
                    // Update your Network properties based on decodedData
                    // ... (Adjust this based on the API response structure)
                    
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] BigDataCloud [s~1] API Error [s~1] updateAddressFrombigDataCloudAccessToken1",line: #line)
                }
            }
            task.resume()
        }
    }
    internal static func updateAddressFrombigDataCloudAccessToken2(){
        let accessToken = bigDataCloudAccessToken2 // "bdc_63a1338580024f5684b3"
        
        // Construct the BigDataCloud API endpoint URL (might need adjustment)
        let urlString = "\(bigDataCloud)/?key=\(accessToken)"
        
        // Ensure the URL is valid
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                // Error Handling
                if let error = error {
                    clSync("Couldn't fetch address data: \(error)", type: "RNE [s~1] SystemInfo [s~1] BigDataCloud [s~1] Network Error [s~1] updateAddressFrombigDataCloudAccessToken2",line: #line)
                    return
                }
                
                // Data Validation
                guard let data = data else {
                    clSync("No address data returned", type: "RNE [s~1] SystemInfo [s~1] BigDataCloud [s~1] Network Error [s~1] updateAddressFrombigDataCloudAccessToken2",line: #line)
                    return
                }
                
                // JSON Decoding
                do {
                    // Decode JSON using a 'bigDataCloudAddressResponse' struct
                    _ = try JSONDecoder().decode(bigDataCloudAddressResponse.self, from: data)
                    
                    // Update your Network properties based on decodedData
                    // ... (Adjust this based on the API response structure)
                    
                } catch {
                    clSync("Couldn't decode JSON: \(error)", type: "RNE [s~1] SystemInfo [s~1] BigDataCloud [s~1] API Error [s~1] updateAddressFrombigDataCloudAccessToken2",line: #line)
                }
            }
            task.resume()
        }
    }
    
    static func logAPIIP(){
        updateAddressFromipinfoIoAPIToken1()
        updateAddressFromipinfoIoAPIToken2()
        updateAddressFromgreyNoiseAccessToken1()
        updateAddressFromgreyNoiseAccessToken2()
        updateAddressFromipRegisteryAccessToken1()
        updateAddressFromipRegisteryAccessToken2()
        updateAddressFromwhoisXMLAPIAccessToken1()
        updateAddressFromwhoisXMLAPIAccessToken2()
        updateAddressFromipDataCoAccessToken1()
        updateAddressFromipDataCoAccessToken2()
        updateAddressFrombigDataCloudAccessToken1()
        updateAddressFrombigDataCloudAccessToken2()
        updateAddressFromabstractAPIIPGeolocationAPIAccessToken1()
        updateAddressFromabstractAPIIPGeolocationAPIAccessToken2()
    }
    
    struct ipinfoIoAPIToken: Codable {
        let ip: String
        let city: String
        let region: String
        let country: String
        let loc: String
        let postal: String
        let timezone: String
        let asn: ASN?
        let company: Company?
        let privacy: Privacy?
        let abuse: Abuse?
        let domains: Domains?
        
        struct ASN: Codable {
            let asn: String
            let name: String
            let domain: String
            let route: String
            let type: String
        }
        
        struct Company: Codable {
            let name: String
            let domain: String
            let type: String
        }
        
        struct Privacy: Codable {
            let vpn: Bool
            let proxy: Bool
            let tor: Bool
            let relay: Bool
            let hosting: Bool
            let service: String
        }
        
        struct Abuse: Codable {
            let address: String
            let country: String
            let email: String
            let name: String
            let network: String
            let phone: String
        }
        
        struct Domains: Codable {
            let page: Int
            let total: Int
            let domains: [String]
        }
    }
    struct IPData: Codable {
        let ip: String
        let is_EU: Bool?
        let country_Name: String
        let countryCode: String
        let continentName: String
        let continentCode: String
        let latitude: Double
        let longitude: Double
        let callingCode: String
        let flag: String
        let emojiFlag: String
        let emojiUnicode: String
        let asn: ASN
        let languages: [Language]
        let currency: Currency
        let timeZone: TimeZone
        let threat: Threat

        struct ASN: Codable {
            let asn: String
            let name: String
            let domain: String?
            let route: String
            let type: String
        }

        struct Language: Codable {
            let name: String
            let native: String
            let code: String
        }

        struct Currency: Codable {
            let name: String
            let code: String
            let symbol: String
            let native: String
            let plural: String
        }

        struct TimeZone: Codable {
            let name: String
            let abbr: String
            let offset: String
            let isDst: Bool
            let currentTime: String
        }

        struct Threat: Codable {
            let isTor: Bool
            let isIcloudRelay: Bool
            let isProxy: Bool
            let isDatacenter: Bool
            let isAnonymous: Bool
            let isKnownAttacker: Bool
            let isKnownAbuser: Bool
            let isThreat: Bool
            let isBogon: Bool
            let blocklists: [String]
        }
    }
    struct abstractAPIResponse: Codable {
        let ipAddress: String? // Rename if necessary
        let city: String?
        let region: String?
        let country: String?
        let countryCode: String? // Some APIs use country codes
        let latitude: Double?
        let longitude: Double?
        // ... Add other properties as needed based on Abstract API response
    }
    struct whoisXMLAPIBalance: Codable {
        let apiKey: String  // Might be in the response
        let credits: Int    // Or some similar property
        // ... Add other relevant properties
    }
    struct ipRegistryAddressResponse: Codable {
        // Add properties based on the ipRegistry API response
        // Example:
        let ip: String?
        let country: Country?
        let timezone: Timezone?
        
        struct Country: Codable {
            let name: String?
            let code: String?
        }
        
        struct Timezone: Codable {
            let id: String?
            let offset: Int?
        }
    }
    struct greyNoiseAddressResponse: Codable {
        let ip: String
        let metadata: Metadata?
        
        struct Metadata: Codable {
            let country: String?
            let city: String?
            // Add other relevant properties
        }
    }
    struct bigDataCloudAddressResponse: Codable {
        let locality: String? // City
        let localityInfo: LocalityInfo?
        
        struct LocalityInfo: Codable {
            let administrative: [AdministrativeInfo]?
            
            struct AdministrativeInfo: Codable {
                let name: String?
            }
        }
    }
    

}
