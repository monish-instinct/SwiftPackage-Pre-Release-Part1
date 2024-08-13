import Foundation

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

struct IPData: Decodable {
    let ip: String
    let isEu: Bool
    let city: String?
    let region: String?
    let regionCode: String?
    let regionType: String?
    let countryName: String
    let countryCode: String
    let continentName: String
    let continentCode: String
    let latitude: Double
    let longitude: Double
    let postal: String?
    let callingCode: String
    let flag: URL
    let emojiFlag: String
    let emojiUnicode: String
    let asn: ASN
    let languages: [Language]
    let currency: Currency
    let timeZone: TimeZone
    let threat: Threat
    let count: String

    enum CodingKeys: String, CodingKey {
        case ip, isEu = "is_eu", city, region, regionCode = "region_code", regionType = "region_type", countryName = "country_name", countryCode = "country_code", continentName = "continent_name", continentCode = "continent_code", latitude, longitude, postal, callingCode = "calling_code", flag, emojiFlag = "emoji_flag", emojiUnicode = "emoji_unicode", asn, languages, currency, timeZone = "time_zone", threat, count
    }
}

// ASN information
struct ASN: Decodable {
    let asn: String
    let name: String
    let domain: String?
    let route: String
    let type: String
}

// Language information
struct Language: Decodable {
    let name: String
    let native: String
    let code: String
}

// Currency information
struct Currency: Decodable {
    let name: String
    let code: String
    let symbol: String
    let native: String
    let plural: String
}

// Time zone information
struct TimeZone: Decodable {
    let name: String
    let abbr: String
    let offset: String
    let isDst: Bool
    let currentTime: String

    enum CodingKeys: String, CodingKey {
        case name, abbr, offset, isDst = "is_dst", currentTime = "current_time"
    }
}

// Threat information
struct Threat: Decodable {
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

    enum CodingKeys: String, CodingKey {
        case isTor = "is_tor", isIcloudRelay = "is_icloud_relay", isProxy = "is_proxy", isDatacenter = "is_datacenter", isAnonymous = "is_anonymous", isKnownAttacker = "is_known_attacker", isKnownAbuser = "is_known_abuser", isThreat = "is_threat", isBogon = "is_bogon", blocklists
    }
}
// Struct for the decoded JSON data
struct abstractAPIResponse: Decodable {
    let ip_address: String
    let city: String?
    let city_geoname_id: Int?
    let region: String?
    let region_iso_code: String?
    let region_geoname_id: Int?
    let postal_code: String?
    let country: String?
    let country_code: String?
    let country_geoname_id: Int?
    let country_is_eu: Bool?
    let continent: String?
    let continent_code: String?
    let continent_geoname_id: Int?
    let longitude: Double?
    let latitude: Double?
    let security: securityData
    let timezone: timeZoneData
    let flag: flagData
    let currency: currencyData
    let connection: connectionData
}

// Nested structs for security, timezone, flag, and currency data
struct securityData: Decodable {
    let is_vpn: Bool
}

struct timeZoneData: Decodable {
    let name: String
    let abbreviation: String
    let gmt_offset: Int
    let current_time: String
    let is_dst: Bool
}

struct flagData: Decodable {
    let emoji: String
    let unicode: String
    let png: String
    let svg: String
}

struct currencyData: Decodable {
    let currency_name: String
    let currency_code: String
}

struct connectionData: Decodable {
    let autonomous_system_number: Int
    let autonomous_system_organization: String
    let connection_type: String
    let isp_name: String
    let organization_name: String
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

struct IPGeolocationData: Decodable{
  let ip: String
  let country_code: String
  let country_name: String
  let region_name: String
  let city_name: String
  let latitude: Double
  let longitude: Double
  let zip_code: String? // Optional since zip code might be missing
  let time_zone: String
  let asn: String
    let `as`: String
  let is_proxy: Bool
}

struct DataIPfyorg: Codable {
  let ip: String?
  let location: Location?
  let `as`: ASInfo?
  let isp: String?

  struct Location: Codable {
    let country: String
    let region: String
    let timezone: String
  }

  struct ASInfo: Codable {
    let asn: Int
    let name: String
    let route: String
    let domain: String
    let type: String
  }
}

