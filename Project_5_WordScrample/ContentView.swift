//
//  ContentView.swift
//  Project_5_WordScrample
//
//  Created by Aziz Baubaid on 01.07.23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = "" //randomly chosen word from 10000 words
    @State private var newWord = "" //will bind to textfield as user types em
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                    //binds newWord to a free typed-in text. not value: like before
                        .autocapitalization(.none)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle") //shows number of letters
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            //onSubmit modifier is used with form elements to handle the submission of a form. When the user taps the submit button or presses the enter key while focused on an input field, the onSubmit closure is executed.
            //it works only with func that accepts no parameters and return void
            .onSubmit (addNewWord)
            //onAppear modifier is used to perform actions when a view appears on the screen. It is commonly used to initialize data, fetch remote data, or update the view based on the current state.
            .onAppear(perform: startGame)
        }
    }
    
    //we need a function to lowercase and removes whitespace from entered words
    //to avoid hello and Hello being counted as different entries.
    //then we make sure there is at least 1 letter in the string
    //add it to list and clear text field for new entry
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        //a guard statement in programming allows for an early exit from a function or closure if a condition is not met. It is commonly used to validate input parameters and handle error conditions
        guard answer.count > 0 else { return }
        
        // Extra validation to come
        
        withAnimation {
            usedWords.insert(answer, at: 0) //inserts word at beginning of list
        }
        
            newWord = ""
    }
    
    func startGame() {
        //fetches txt file start, where our words are stored
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            //try? in case file is not found (return nil instead) otherwise load file contents as string
            if let startWords = try? String(contentsOf: startWordsURL) {
                //creates a list with elements cut at each newline start
                let allWords = startWords.components(separatedBy: "\n")
                //returns a random list element. this is an optional. nil-coalescing is a must
                rootWord = allWords.randomElement() ?? "silkworm"
                //exits
                return
            }
        }
        //if file cannot be located (i forgot to include it etc), the app crashes immediately
        fatalError("Could not load start.txt from bundle.")
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
