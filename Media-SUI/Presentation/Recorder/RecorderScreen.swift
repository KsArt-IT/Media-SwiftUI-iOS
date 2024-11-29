//
//  RecorderScreen.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct RecorderScreen: View {
    @StateObject private var viewModel = RecorderViewModel()
    
    var body: some View {
        VStack {
            TitleTextView("Audio recorder")
            
            List(viewModel.recordings) { recording in
                RecordingView(
                    recording: recording,
                    playing: $viewModel.currentPlaying
                )
                .swipeActions(edge: .trailing) {
                    Button {
                        withAnimation {
                            viewModel.delete(recording.url)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        viewModel.showRename(recording)
                    } label: {
                        Label("Rename", systemImage: "rectangle.and.pencil.and.ellipsis")
                    }
                    .tint(.blue)
                }
                .onTapGesture {
                    viewModel.playOrStop(recording.url)
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            
            VStack {
                if viewModel.isRecording {
                    AudioWaveformView(audioLevels: viewModel.audioLevels)
                } else {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.waveformHeight)
            .border(.green)
            .padding(.vertical, Constants.small)
            
            ButtonRecordingView(
                isRecording: $viewModel.isRecording,
                isDisabled: $viewModel.isRecordingButtonDisabled
            ) {
                viewModel.startOrStopRecording()
            }
            .frame(width: Constants.recordingButton, height: Constants.recordingButton)
            .padding(.bottom, Constants.small)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .alertRename(isPresented: $viewModel.isRenameVisible, name: $viewModel.name) {
            viewModel.rename()
        }

        .onAppear {
            viewModel.fetchRecordings()
        }
        .onReceive(NotificationCenter.default.publisher(for: .playbackFinished)) { _ in
            viewModel.stop()
        }
    }
}

#Preview {
    RecorderScreen()
}
