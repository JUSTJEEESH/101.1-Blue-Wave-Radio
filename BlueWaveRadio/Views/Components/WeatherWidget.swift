//
//  WeatherWidget.swift
//  Blue Wave Radio Roatan
//
//  Small weather widget showing current conditions in Roatan
//

import SwiftUI

struct WeatherWidget: View {
    @EnvironmentObject var weatherManager: WeatherManager

    var body: some View {
        HStack(spacing: 8) {
            if weatherManager.isLoading {
                ProgressView()
                    .tint(.white)
            } else if let weather = weatherManager.currentWeather {
                Image(systemName: weather.sfSymbol)
                    .font(.title3)
                    .foregroundColor(.white)
                    .symbolRenderingMode(.hierarchical)

                Text(weatherManager.formattedTemperature())
                    .font(.headline)
                    .foregroundColor(.white)

                Text("Roatan")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.2))
        )
    }
}

#Preview {
    WeatherWidget()
        .environmentObject(WeatherManager.shared)
        .background(Color.blue)
}
