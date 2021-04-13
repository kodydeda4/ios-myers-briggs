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
                Progressbar(percentage: viewStore.percentCompleted, action: { viewStore.send(.showSheetView) })
                
                Text(viewStore.currentQuestion.content)
                    .font(.title)
                    .bold()
                    .padding(.vertical)
                    .frame(height: 300, alignment: .topLeading)
                
                HStack {
                    ForEach(Question.Response.allCases) { response in
                        Button(action: { viewStore.send(.responseButtonTapped(response)) }) {
                            Circle()
                                .foregroundColor(response.buttonColor)
                                .opacity((viewStore.changingQuestion && viewStore.currentQuestion.response != response) ? 0.25 : 1)
                                .animation(.default, value: viewStore.changingQuestion && viewStore.currentQuestion.response != response)
                        }
                    }
                }
                
                DebugView(store: store)
            }
            .padding()
            .navigationBarHidden(true)
            .sheet(isPresented: viewStore.binding(get: \.showingSheetView, send: .hideSheetView)) {
                AssessmentSheetView(store: store)
            }
        }
    }
}


struct DebugView: View {
    let store: Store<Assessment.State, Assessment.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Text(viewStore.currentQuestion.tendsToward.rawValue)
                        .font(.title)
                        .bold()
                        .foregroundColor(.green)
                    
                    Text(viewStore.currentQuestion.tendsToward.opposite.rawValue)
                        .font(.title)
                        .bold()
                        .foregroundColor(.orange)
                }
                
                HStack {
                    TextField("", text: .constant("\(viewStore.introversion.description) Introversion"))
                    TextField("", text: .constant("\(viewStore.extroversion.description) Extroversion"))
                }
                HStack {
                    TextField("", text: .constant("\(viewStore.sensing.description) Sensing"))
                    TextField("", text: .constant("\(viewStore.intuition.description) Intuition"))
                }
                HStack {
                    TextField("", text: .constant("\(viewStore.thinking.description) Thinking"))
                    TextField("", text: .constant("\(viewStore.feeling.description) Feeling"))
                }
                HStack {
                    TextField("", text: .constant("\(viewStore.judging.description) Judging"))
                    TextField("", text: .constant("\(viewStore.percieving.description) Percieving"))
                }
            }
            .padding()
            .border(Color.red)
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView(store: Assessment.defaultStore)
    }
}


struct AssessmentQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentQuestionView(store: Assessment.defaultStore)
    }
}


