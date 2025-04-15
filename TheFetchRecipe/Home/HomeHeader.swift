import SwiftUI

struct HomeHeader: View {
    var body: some View {
        HStack(spacing: 0) {
            Image("appicon")
                .resizable()
                .frame(width: 50, height: 50)
                
            Text("The")
            Text("Fetch")
                .foregroundStyle(AppConfigs.defaultThemeColor)
            Text("Recipe")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, AppConfigs.defaultPadding / 2)
        .padding([.bottom, .leading], AppConfigs.defaultPadding)
        .shadow(color: .black.opacity(0.15), radius: 2, y: 2)
        .fontWeight(.bold)
        .font(.title)
    }
}

#Preview {
    HomeHeader()
}
