/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct WhiteLabelResp : Codable {
	let errors : [Errors]?
	let id : Int?
	let domain : String?
	let code : String?
	let nameAr : String?
	let nameEn : String?
	let logoPath : String?
	let showChat : Bool?
	let showNotification : Bool?
	let showAppsDownlaodLinks : Bool?
	let showBankTransfer : Bool?
	let enable : Bool?
	let supportLink : String?
	let websiteLink : String?
	let whiteLogo : String?
	let darkLogo : String?
	let fullWebsiteLink : String?
	let showJoinUs : Bool?
	let masterApp : Bool?
	let faqLink : String?
	let termsOfUseLink : String?
	let privacyPolicyLink : String?
	let favIcon : String?
	let siteColorOne : String?
	let siteColorTwo : String?
	let siteColorThree : String?
    
    var name: String{
        if lang == "en"{
            return nameEn ?? ""
        }else{
            return nameAr ?? ""
        }
    }

}

struct Errors : Codable {
    let errorCode : String?
    let errorMessage : String?
}


class WhiteLabelLocal{
    
    static let shared = WhiteLabelLocal()
    
    func appendValueToLocalWhiteLabelList(whiteLabel: WhiteLabelResp) {
            do {
                let encodedData = try PropertyListEncoder().encode(whiteLabel)
                sharedPref.shared.setSharedValue("whiteLabel", value: encodedData)
            }catch let error {
                print("error insert data \(error.localizedDescription)")
            }
        }
    
    func getLocalWhiteLabelList() -> WhiteLabelResp? {
        if let decoded = sharedPref.shared.getSharedValue(forKey: "whiteLabel") as? Data {
                do {
                    let goldRateList = try PropertyListDecoder().decode(WhiteLabelResp.self, from: decoded)
                    return goldRateList
                }catch let error {
                    print("error get data \(error.localizedDescription)")
                    return nil
                }
      
            }
            return nil
        }
}


class sharedPref {
    
    static let shared = sharedPref()
    
    private let pref = UserDefaults.standard
    
    
    /// store value in user defaults
    ///
    /// - Parameters:
    ///   - value: you can store any value that can be converted to JsonObject
    ///   - key: the specified key for this value
    func setSharedValue(_ key:String, value:Any)
    {
        self.pref.set(value, forKey: key)
    }
    
    
    /// get stored value for a specific key
    ///
    /// - Parameter key: the value key
    /// - Returns: the value if exist as (Any?) or nil if it doesn't exist
    func getSharedValue(forKey key:String) -> Any?
    {
        return self.pref.object(forKey: key)
    }

    
    /// get stored string for a specific key
    ///
    /// - Parameter key: the string key
    /// - Returns: the string value if exist or empty string if it doesn't exist
    func getSharedSrting(forKey key:String) -> String {
        return self.pref.object(forKey: key) as? String ?? ""
    }
    
    
    /// get stored string for a specific key
    ///
    /// - Parameter key: the int key
    /// - Returns: the int value if exist or 0 if it doesn't exist
    func getSharedInt(forKey key:String) -> Int {
        return self.pref.object(forKey: key) as? Int ?? 0
    }
    
    /// get stored Bool for a specific key
    ///
    /// - Parameter key: the Bool key
    /// - Returns: the Bool value if exist or false if it doesn't exist
    func getSharedBool(forKey key:String) -> Bool {
        return self.pref.object(forKey: key) as? Bool ?? false
    }
    
    func removeValue(forKey key:String) {
        self.pref.removeObject(forKey: key)
    }
    
    
    /// cleare all stored data
    func clearCach() {
        let domain = Bundle.main.bundleIdentifier ?? ""
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
