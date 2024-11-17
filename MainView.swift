import SwiftUI
import UserNotifications

struct MainView: View {
    @State private var affirmations: [String] = [
        "You are good enough",
        "You can achieve anything you set your mind to",
        "Every day is a new opportunity"
    ]
    @State private var currentAffirmationIndex = 0
    @State private var showChatView = false
    @State private var showBubbleHint = true
    @State private var showPersonalCenter = false

    var body: some View {
        ZStack {
            
            RadialGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.6, blue: 0.6), Color.white]), center: .center, startRadius: 100, endRadius: 500)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    
                    Button(action: {
                        showPersonalCenter = true
                    }) {
                        Image(systemName: "person")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showPersonalCenter) {
                        PersonalCenterView()
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 40)

                Spacer()

                
                VStack {
                    Text(affirmations[currentAffirmationIndex])
                        .font(.system(size: 28, weight: .regular, design: .serif))
                        .padding()
                }
                .gesture(DragGesture().onEnded { value in
                    if value.translation.height < 0 {
                        currentAffirmationIndex = (currentAffirmationIndex + 1) % affirmations.count
                    } else if value.translation.height > 0 {
                        currentAffirmationIndex = (currentAffirmationIndex - 1 + affirmations.count) % affirmations.count
                    }
                })
                .frame(height: 300)

                Spacer()

                
                if showBubbleHint {
                    Text("Can I talk to you for a second?")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                showBubbleHint = false
                            }
                        }
                }

               
                Button(action: {
                    showChatView = true
                }) {
                    Image(systemName: "smiley")
                        .font(.system(size: 40))
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showChatView) {
                    ChatView(onAffirmationGenerated: { affirmation in
                        affirmations.insert(affirmation, at: 0)
                        currentAffirmationIndex = 0
                    })
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            scheduleAffirmationUpdates()
        }
    }

    func loadAffirmations() {
        fetchAffirmationsFromGemini { result in
            switch result {
            case .success(let generatedAffirmations):
                affirmations = generatedAffirmations
            case .failure:
                print("Error loading affirmations.")
            }
        }
    }

    func scheduleAffirmationUpdates() {
        let interval: TimeInterval = 1800
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            loadAffirmations()
        }
    }
}
