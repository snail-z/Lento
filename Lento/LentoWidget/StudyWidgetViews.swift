//
//  StudyWidgetViews.swift
//  LentoWidgetExtension
//
//  Created by zhang on 2023/4/13.
//

import SwiftUI
import WidgetKit

struct ProductImageView: View {
    var model: LentoProductSummary
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: model.image ?? UIImage(named: "dd_alreadyPaid_default_loading_icon")!)
                .resizable()
                .frame(width: 60, height: 80)
                .cornerRadius(6)
            Text(model.tag)
                .font(.system(size: 10))
                .foregroundColor(.white)
                .padding(2)
                .background(Color.black.opacity(0.5))
                .cornerRadius(3)
                .offset(x: -3, y: -3)
        }
    }
}


struct StudyWidgetPlaceholderView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            HStack {
                Const.placeholder
                    .frame(width: 26, height: 26)
                    .cornerRadius(6)
                Const.placeholder
                    .frame(width: 101, height: 18)
                    .cornerRadius(6)
                Spacer()
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
            HStack(spacing: 10) {
                let testData = (0..<4)
                ForEach(testData, id: \.self) { _ in
                    VStack {
                        Const.placeholder
                            .frame(width: 60, height: 80)
                            .cornerRadius(6)
                        Spacer()
                        Const.placeholder
                            .frame(width: 60, height: 13)
                            .cornerRadius(6)
                    }
                    .frame(width: 70, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment:/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(colorScheme == .dark ? Const.darkBackground : Const.lightBackground)
    }
}



struct ProductView: View {
    var model: LentoProductSummary
    var body: some View {
        Link(destination: Util.widgetURL(model.JumpURL(), widgetName: WidgetName.study)) {
            VStack(alignment: .center) {
                ProductImageView(model: model)
                    .frame(width: 60, height: 80)
                Spacer()
                Text(model.title)
                    .foregroundColor(Color("ProductNameColor"))
                    .font(.system(size: 12))
                    .bold()
            }
            .frame(width: 70, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}
struct StudyWidgetContentView: View {
    @Environment(\.colorScheme) var colorScheme
    let list: [LentoProductSummary]
    
    var body: some View {
        VStack {
            HStack {
                Image("logo")
                    .resizable()
                    .frame(width: 21, height: 26)
                Text("xx·99最近在学")
                    .font(.system(size: 12))
                    .bold()
                Spacer()
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
            HStack(spacing: 10) {
                let maxCount: Int = min(list.count, 4)
                ForEach(0..<maxCount, id: \.self) { index in
                    ProductView(model: list[index])
                }
                if list.count < 4 {
                    Spacer()
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(colorScheme == .dark ? Const.darkBackground : Const.lightBackground)
    }
}
//
//struct StudyWidgetViews_Previews: PreviewProvider {
//    static var previews: some View {
//        StudyWidgetPlaceholderView()
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//        StudyWidgetContentView(list: Array(repeating: LentoProductSummary(), count: 4))
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//        ProductView(model: LentoProductSummary())
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
////            .previewLayout(.sizeThatFits)
//    }
//}
