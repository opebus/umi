//
//  ContentView.swift
//  Umi
//
//  Created by Benedict Neo on 2/21/24.
//

import SwiftUI

struct AnimatedGrainyBackground: View {
    @State private var noiseOffset = CGSize.zero
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                for _ in 0..<5000 { // Number of grains
                    let position = CGPoint(
                        x: .random(in: 0...size.width) + noiseOffset.width,
                        y: .random(in: 0...size.height) + noiseOffset.height
                    )
                    let rect = CGRect(origin: position, size: CGSize(width: 1, height: 1))
                    context.fill(Path(rect), with: .color(Color.white.opacity(0.2))) // Grain color and opacity
                }
            }
            .blur(radius: 0.2)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onReceive(timer) { _ in
                // Randomize the noiseOffset to change the grain positions
                noiseOffset = CGSize(
                    width: .random(in: -10...10),
                    height: .random(in: -10...10)
                )
            }
        }
        .background(Color.gray.opacity(0.01)) // Base color of the background
        .ignoresSafeArea()
    }
}

struct ContentView: View {
    
    let questions: [Questions] = Bundle.main.decode("questions.json")
    @State private var randomQuestion = "?"
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedGrainyBackground()

                VStack(spacing: 20) {
                    Spacer()
                    
                    Text(randomQuestion)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button("New Question") {
                        if let question = questions.randomElement() {
                            randomQuestion = question.question
                        }
                    }
                    .font(.headline)
                    .padding(.vertical, 7)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .padding(.bottom, 100)
                }
            }
        }
        .colorScheme(.dark)
    }

}

#Preview {
    ContentView()
}
