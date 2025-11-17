//
//  WeatherManager.swift
//  Blue Wave Radio Roatan
//
//  Service for managing weather data
//

import Foundation
import Combine

@MainActor
class WeatherManager: ObservableObject {
    static let shared = WeatherManager()

    // Weather data
    @Published var currentWeather: Weather?
    @Published var isLoading = false
    @Published var lastUpdated: Date?

    // Settings
    @Published var useMetric: Bool {
        didSet {
            UserDefaults.standard.set(useMetric, forKey: "weatherUseMetric")
        }
    }

    // Roatan coordinates
    private let latitude = 16.3266
    private let longitude = -86.5375

    // API configuration - stored securely
    private var apiKey: String {
        // In a production app, this should come from a secure keychain or configuration
        return "f55f2adcf1dce3b4e259df0ab8d98e8a"
    }

    private var cancellables = Set<AnyCancellable>()
    private nonisolated(unsafe) var refreshTimer: Timer?

    private init() {
        // Load settings
        self.useMetric = UserDefaults.standard.object(forKey: "weatherUseMetric") as? Bool ?? true

        // Start auto-refresh (every 30 minutes)
        startAutoRefresh()
    }

    // MARK: - Public Methods

    func fetchWeather() async {
        await MainActor.run {
            isLoading = true
        }

        let units = useMetric ? "metric" : "imperial"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=\(units)&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            await MainActor.run {
                isLoading = false
            }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(WeatherResponse.self, from: data)

            await MainActor.run {
                currentWeather = response.weather
                lastUpdated = Date()
                isLoading = false
            }
        } catch {
            print("Weather fetch error: \(error)")
            await MainActor.run {
                isLoading = false
            }
        }
    }

    func toggleUnits() {
        useMetric.toggle()
        // Immediately refresh weather with new units
        Task { @MainActor in
            await fetchWeather()
        }
    }

    func formattedTemperature() -> String {
        guard let temp = currentWeather?.temperature else { return "--" }
        let unit = useMetric ? "°C" : "°F"
        return "\(Int(temp.rounded()))\(unit)"
    }

    // MARK: - Private Methods

    private func startAutoRefresh() {
        // Refresh every 30 minutes
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 1800, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.fetchWeather()
            }
        }

        // Fetch immediately on init
        Task {
            await fetchWeather()
        }
    }

    deinit {
        refreshTimer?.invalidate()
    }
}
