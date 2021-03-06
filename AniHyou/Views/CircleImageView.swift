//
//  CircleImageView.swift
//  AniHyou
//
//  Created by Axel Lopez on 2/7/22.
//

import SwiftUI
import Kingfisher

struct CircleImageView: View {
    
    var imageUrl: String?
    var size: CGFloat
    var systemPlaceHolder: String = "person.circle.fill"
    
    var body: some View {
        KFImage(URL(string: imageUrl ?? ""))
            .placeholder {
                Image(systemName: systemPlaceHolder)
                    .resizable()
                    .frame(width: size, height: size, alignment: .center)
            }
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: size, height: size, alignment: .center)
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView(size: 110)
    }
}
