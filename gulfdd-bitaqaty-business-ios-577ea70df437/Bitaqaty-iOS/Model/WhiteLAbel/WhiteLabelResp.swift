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

}

struct Errors : Codable {
    let errorCode : String?
    let errorMessage : String?
}