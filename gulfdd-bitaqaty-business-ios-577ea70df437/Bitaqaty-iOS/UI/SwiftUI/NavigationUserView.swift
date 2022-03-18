//
//  NavigationBarView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/23/21.
//

import SwiftUI


struct NavigationUserView: View {
    @State var user: User
    @State var isBalanceVisible = false
    @State var name = ""
    var body: some View {
        HStack(spacing: 4){
            Image("Person_Icon")
                .renderingMode(.original)
                .resizable()
                .frame(width: 23, height: 23)
            VStack(alignment: .leading, spacing: 5){
                Text("\(strings.Hello.localizedValue) \(self.name)".adjustAlignment).font(Font.custom(FONT_SEMI_BOLD, size: FONT_SMALLER))
                    .accentColor(.primary)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                if isBalanceVisible{
                HStack(spacing: 4){
                    Text(strings.YourBalance.localizedValue).font(Font.custom(FONT_LIGHT, size: FONT_SMALLER))
                    Text(user.reseller!.BalanceStr).font(Font.custom(FONT_SEMI_BOLD, size: FONT_SMALLER))
                    Text(user.reseller!.Currency).font(Font.custom(FONT_LIGHT, size: FONT_SMALLER))
                  }
                }
            }.foregroundColor(.primary)
        }.background(Color.white)
        .frame(width: (UIScreen.main.bounds.width / 2) - 30, alignment: .leading)
        .environment(\.layoutDirection, lang == "en" ? .leftToRight : .rightToLeft)
        .onAppear{
            if let user = DataService.getUserData(), let reseller = user.reseller{
                self.name = reseller.FullName
                if name.contains("@"){
                    name = String(name.split(separator: "@")[0])
                }
                self.user = user
                if user.accountType == Roles.SUB_ACCOUNT.rawValue{
                    if reseller.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.NO_LIMIT.rawValue{
                        if reseller.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.VIEW_MASTER_BALANCE.rawValue})[0].Enabled{
                            isBalanceVisible = true
                        }else{
                            isBalanceVisible = false
                        }
                    }else{
                        if reseller.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.VIEW_PURCHASE_LIMIT.rawValue})[0].Enabled{
                            isBalanceVisible = true
                        }else{
                            isBalanceVisible = false
                        }
                    }
                }else{
                    isBalanceVisible = true
                }
            }
        }
    }
}

//struct NavigationUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationUserView().frame(height: 200)
//    }
//}
