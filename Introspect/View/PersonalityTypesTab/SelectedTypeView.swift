//
//  SelectedTypeView.swift
//  Introspect
//
//  Created by Kody Deda on 4/13/21.
//

import SwiftUI
import ComposableArchitecture
import FancyScrollView
import DynamicColor

struct SelectedTypeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let type: PersonalityType
    
    var body: some View {
        FancyScrollView(
            headerHeight: 400,
            header: { HeaderView(type: type) }
        ) {
            VStack(alignment: .leading) {
                Text(type.headline)
                    .font(.title3)
                    .bold()
                
                Divider()
                
                Text(type.bodyText)
                    .foregroundColor(.secondary)
                
            }
            .padding()
        }
        .gesture(
            DragGesture().onEnded {
                if $0.translation.width > 60 {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        )
    }
}


struct SelectedTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedTypeView(type: PersonalityType.architect)
    }
}

struct HeaderView: View {
    var type: PersonalityType
    @State var doneAnimatingImage: Bool = false
    @State var doneAnimatingText: Bool = false
    var animDuration = 0.6
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Image(type.imageSelectedURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .scaleEffect(doneAnimatingImage ? 1 : 0)
            
            VStack(alignment: .leading) {
                Text(type.rawValue)
                    .bold()
                    .foregroundColor(Color(.lightText))
                
                Text(type.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                Text(type.description)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .opacity(doneAnimatingText ? 1 : 0)
            .animation(Animation.easeInOut(duration: animDuration * 0.75).delay(animDuration), value: doneAnimatingText)
        }
        .scaleEffect(doneAnimatingImage ? 1 : 0)
        .opacity(doneAnimatingImage ? 1 : 0)
        .animation(Animation.spring(), value: doneAnimatingImage)
        .onAppear {
            doneAnimatingImage.toggle()
            doneAnimatingText.toggle()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(type.group.associatedColor)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(type: PersonalityType.architect)
    }
}




