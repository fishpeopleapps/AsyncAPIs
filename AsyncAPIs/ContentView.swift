//
//  ContentView.swift
//  AsyncAPIs
//
//  Created by Kimberly Brewer on 7/26/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Chuck Norris Jokes") {
                    ChuckNorrisView()
                }
                Text("Hello, world!")
            }
            .padding()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
