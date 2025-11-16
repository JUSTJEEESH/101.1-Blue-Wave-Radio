//
//  SleepTimerView.swift
//  Blue Wave Radio Roatan
//
//  Sleep timer configuration view
//

import SwiftUI

struct SleepTimerView: View {
    @ObservedObject var audioManager: AudioStreamManager
    @Binding var isPresented: Bool
    @State private var selectedMinutes = 0

    let timerOptions = [0, 15, 30, 45, 60]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "bed.double.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.accentTurquoise)
                    .padding()

                Text("Sleep Timer")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("The radio will stop playing after the selected time")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Picker("Minutes", selection: $selectedMinutes) {
                    ForEach(timerOptions, id: \.self) { minutes in
                        if minutes == 0 {
                            Text("Off").tag(minutes)
                        } else {
                            Text("\(minutes) minutes").tag(minutes)
                        }
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)

                if audioManager.sleepTimerMinutes > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Timer active: \(audioManager.sleepTimerMinutes) minutes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                }

                Button(action: {
                    audioManager.setSleepTimer(minutes: selectedMinutes)
                    isPresented = false
                }) {
                    Text("Set Timer")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentTurquoise)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            selectedMinutes = audioManager.sleepTimerMinutes
        }
    }
}

#Preview {
    SleepTimerView(
        audioManager: AudioStreamManager.shared,
        isPresented: .constant(true)
    )
}
