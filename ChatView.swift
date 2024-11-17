import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var userInput: String = ""
    @State private var questionIndex: Int = 0
    let questions = [
        "How are you feeling now?",
        "Is there something specific causing it?",
        "How long has this feeling lasted?"
    ]
    let onAffirmationGenerated: (String) -> Void

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isUser {
                                Spacer()
                                Text("You: \(message.content)")
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(.trailing, 5)
                                    .transition(.move(edge: .trailing))
                            } else {
                                Text("Urrare: \(message.content)")
                                    .padding()
                                    .background(Color.pink.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(.leading, 5)
                                    .transition(.move(edge: .leading))
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 20)
            }

            HStack {
                TextEditor(text: $userInput)
                    .frame(minHeight: 40, maxHeight: 80) 
                    .padding(4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                
                Button("Send") {
                    sendMessage()
                }
                .padding(.leading, 5)
            }
            .padding()
        }
        .onAppear {
            sendAIQuestion()
        }
    }

    func sendMessage() {
        let userMessage = Message(content: userInput, isUser: true)
        withAnimation(.spring()) {
            messages.append(userMessage)
        }
        userInput = ""

        if questionIndex < questions.count - 1 {
            questionIndex += 1
            sendAIQuestion()
        } else {
            generateAffirmationBasedOnChat()
        }
    }

    func sendAIQuestion() {
        let aiMessage = Message(content: questions[questionIndex], isUser: false)
        withAnimation(.spring()) {
            messages.append(aiMessage)
        }
    }

    func generateAffirmationBasedOnChat() {
        fetchAffirmationsFromGemini { result in
            switch result {
            case .success(let affirmations):
                if let affirmation = affirmations.first {
                    let aiMessage = Message(content: affirmation, isUser: false)
                    withAnimation(.spring()) {
                        messages.append(aiMessage)
                    }
                    onAffirmationGenerated(affirmation)
                } else {
                    withAnimation(.spring()) {
                        messages.append(Message(content: "Sorry, I couldn't generate an affirmation.", isUser: false))
                    }
                }
            case .failure:
                withAnimation(.spring()) {
                    messages.append(Message(content: "Sorry, I couldn't generate an affirmation.", isUser: false))
                }
            }
        }
    }
}

