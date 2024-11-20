//
//  ChuckNorrisView.swift
//  AsyncAPIs
//
//  Created by Kimberly Brewer on 7/26/23.
//
// TODO: Show pop-up with error messages
// TODO: Improve UI

import SwiftUI

struct Joke: Codable {
    /// 'value' is the string found in the JSON from the API URL that holds the joke
    let value: String
}
enum CNError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
struct ChuckNorrisView: View {
    /// Joke related variables
    @State private var joke = "Are you ready for a Chuck Norris Joke?"
    private var jokeURL = "https://api.chucknorris.io/jokes/random"
    /// Title related variables
    let title = Array("Chuck Norris Jokes")
    @State private var bgEnabled = false
    @State private var dragAmount = CGSize.zero
    /// View
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                ForEach(0..<title.count, id: \.self) { num in
                    Text(String(title[num]))
                        .padding(5)
                        .font(.title2)
                        .background(bgEnabled ? .teal : .green)
                        .offset(dragAmount)
                        .animation(
                            .default.delay(Double(num) / 20),
                            value: dragAmount
                        )
                }
            }
            .padding(.bottom, 20)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        dragAmount = .zero
                        bgEnabled.toggle()
                    }
            )
            Text(joke)
                .padding()
            Button {
                Task {
                    do {
                        try await getJoke()
                    } catch CNError.invalidURL {
                        print("Invalid URL")
                    } catch CNError.invalidResponse {
                        print("Invalid response")
                    } catch CNError.invalidData {
                        print("Invalid data")
                    } catch {
                        print("unexpected error")
                    }
                }
            } label: {
                Text("Fetch Joke")
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
    func getJoke() async throws {
        guard let url = URL(string: jokeURL) else {
            throw CNError.invalidURL
        }
        /// Here we are downloading the data from the URL, returns (data, response) tuple
        let (data, response) = try await URLSession.shared.data(from: url)
        /// 200 means everything was good
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw CNError.invalidResponse
        }
        /// we got the JSON back, now we can work with it
        do {
            let decodedResponse = try JSONDecoder().decode(Joke.self, from: data)
            self.joke = decodedResponse.value
        } catch {
            throw CNError.invalidData
        }
    }
}

struct ChuckNorrisView_Previews: PreviewProvider {
    static var previews: some View {
        ChuckNorrisView()
    }
}
