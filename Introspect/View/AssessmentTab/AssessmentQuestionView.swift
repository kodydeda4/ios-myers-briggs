//
//  AssessmentQuestionView.swift
//  Introspect
//
//  Created by Kody Deda on 4/6/21.
//

import SwiftUI
import ComposableArchitecture

struct AssessmentQuestionView: View {
    let store: Store<Assessment.State, Assessment.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                VStack(alignment: .trailing) {
                    Button(action: { viewStore.send(.showSheetView) }) {
                        Text("\(viewStore.questions.filter({ $0.response != nil}).count)/\(viewStore.questions.count) Complete")
                            .bold()
                    }
                    HStack(spacing: 0) {
                        ForEach(viewStore.questions) {
                            if $0.response == nil {
                                Rectangle()
                                    .foregroundColor(Color(.secondarySystemBackground))
                            } else {
                                Rectangle()
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .frame(height: 10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
                }
                Text(viewStore.currentQuestion.content)
                    .font(.title)
                    .bold()
                    .padding()
                
                ForEach(viewStore.currentQuestion.responses, id: \.self) { response in
                    Button(response.lowercased()) {
                        viewStore.send(.responseButtonTapped(response))
                    }
                    .buttonStyle(RoundedRectangleButtonStyle(style: viewStore.currentQuestion.response == response ? .confirm : .dismiss))
                }
                .padding(.horizontal)
                
                Spacer()
                HStack {
                    Button("Back") {
                        viewStore.send(.backButtonTapped)
                    }
                    .buttonStyle(RoundedRectangleButtonStyle(style: .dismiss))
                    .disabled(viewStore.progress == .firstQuestion)
                    
                    Button("Next") {
                        viewStore.send(.nextButtonTapped)
                    }
                    .buttonStyle(
                        //RoundedRectangleButtonStyle(style: viewStore.testStatus == .lastQuestion ? .dismiss : .confirm)
                        RoundedRectangleButtonStyle(style: .confirm)
                    )
                    
                    //.disabled(viewStore.testStatus == .lastQuestion)
                }
                .disabled(viewStore.changingQuestion)
            }
            .padding()
            .navigationBarHidden(true)
            .sheet(isPresented: viewStore.binding(get: \.showingSheetView, send: .hideSheetView)) {
                AssessmentSheetView(store: store)
            }
        }
    }
}

struct AssessmentQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentQuestionView(store: Assessment.defaultStore)
    }
}
