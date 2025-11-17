//
//  Weather.swift
//  Blue Wave Radio Roatan
//
//  Model for weather data
//

import Foundation

struct Weather: Codable {
    let temperature: Double
    let feelsLike: Double
    let condition: String
    let conditionId: Int
    let humidity: Int
    let windSpeed: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case condition = "main"
        case conditionId = "id"
        case humidity
        case windSpeed = "wind_speed"
    }
}

struct WeatherResponse: Codable {
    let main: MainWeather
    let conditions: [WeatherCondition]
    let wind: Wind

    struct MainWeather: Codable {
        let temp: Double
        let feelsLike: Double
        let humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case humidity
        }
    }

    struct WeatherCondition: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Wind: Codable {
        let speed: Double
    }

    enum CodingKeys: String, CodingKey {
        case main
        case conditions = "weather"
        case wind
    }

    var weather: Weather {
        Weather(
            temperature: main.temp,
            feelsLike: main.feelsLike,
            condition: conditions.first?.main ?? "Clear",
            conditionId: conditions.first?.id ?? 800,
            humidity: main.humidity,
            windSpeed: wind.speed
        )
    }
}

// Weather condition to SF Symbol mapping
extension Weather {
    var sfSymbol: String {
        switch conditionId {
        case 200...232: // Thunderstorm
            return "cloud.bolt.fill"
        case 300...321: // Drizzle
            return "cloud.drizzle.fill"
        case 500...504: // Rain
            return "cloud.rain.fill"
        case 511: // Freezing rain
            return "cloud.sleet.fill"
        case 520...531: // Shower rain
            return "cloud.heavyrain.fill"
        case 600...622: // Snow
            return "cloud.snow.fill"
        case 701...781: // Atmosphere (fog, mist, etc.)
            return "cloud.fog.fill"
        case 800: // Clear
            return "sun.max.fill"
        case 801: // Few clouds
            return "cloud.sun.fill"
        case 802: // Scattered clouds
            return "cloud.fill"
        case 803...804: // Broken/overcast clouds
            return "smoke.fill"
        default:
            return "cloud.fill"
        }
    }
}
