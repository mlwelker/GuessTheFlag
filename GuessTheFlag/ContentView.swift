
import SwiftUI

struct FlagImageView: View {
    var flag: String
    
    var body: some View {
        Image(flag)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.accentColor)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var questionsShown = 1
    
    @State private var animationAmount = [0.0, 0.0, 0.0]
    @State private var opacityAmount = [1.0, 1.0, 1.0]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
//            LinearGradient(gradient: Gradient(colors: [.black, .blue]), startPoint: .bottom, endPoint: .top).ignoresSafeArea()
            RadialGradient(stops: [
                Gradient.Stop(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                Gradient.Stop(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.weight(.bold))
                
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImageView(flag: countries[number])
                        }
                        .rotation3DEffect(.degrees(animationAmount[number]), axis: (x: 0, y: 1, z: 0))
                        .opacity(opacityAmount[number])
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .padding(.bottom, 20)
                .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Round: \(questionsShown)")
                    .font(.subheadline).foregroundColor(.white).bold()
                Text("Score: \(score)")
                    .font(.title).foregroundColor(.white).bold()
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
        .alert(scoreTitle, isPresented: $gameOver) {
            Button("Start Over", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
    }
    
    
    func flagTapped(_ number: Int) {
        withAnimation(.interpolatingSpring(stiffness: 25, damping: 10)) {
            for i in 0..<3 {
                opacityAmount[i] = 0.25
            }
            animationAmount[number] += 360
            opacityAmount[number] += 0.75
        }
        if number ==  correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Doh! That's not right..."
        }
        
        scoreMessage = "That's the flag of \(countries[number])"
        showingScore = true // reset autocomplete heuristics
    }
    
    
    func askQuestion() {
        if questionsShown >= 8 {
            scoreTitle = "Game Over"
            scoreMessage = "Final Score: \(score) out of 8."
            questionsShown = 0
            score = 0
            gameOver = true
        } else {
            withAnimation {
                for i in 0..<3 {
                    opacityAmount[i] = 1.0
                }
            }
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            questionsShown += 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
