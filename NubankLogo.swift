import SwiftUI

struct NubankLogo: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.purple)
            Text("nu")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(width: 48, height: 48)
    }
}
