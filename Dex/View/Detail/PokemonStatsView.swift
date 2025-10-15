import Charts
import SwiftUI

struct PokemonStatsView: View {
    @State var animatedProgress = 0
    @State private var showAnnotation = false
    
    var pokemon: Pokemon
    
    var body: some View {
        VStack {
            Chart(pokemon.stats) { stat in
                BarMark(x: .value("Value", stat.value * animatedProgress), y: .value("Name", stat.name))
                    .annotation(position: .trailing) {
                        Text("\(stat.value)")
                            .contentTransition(.numericText())
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.top, -5)
                            .opacity(showAnnotation ? 1 : 0)
                    }
            }
            .frame(height: 200)
            .padding(.horizontal)
            .foregroundStyle(pokemon.typeColor)
            .chartXScale(domain: 0...pokemon.highestValue.value + 10)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 3)) {
                animatedProgress = 1
            } completion: {
                showAnnotation = true
            }
        }
    }
}

#Preview {
    PokemonStatsView(pokemon: PersistenceController.previewSample)
}
