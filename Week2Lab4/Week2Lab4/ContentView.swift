//
//  ContentView.swift
//  Week2Lab4
//
//  Created by Sara Sd on 15/01/1445 AH.
//

import SwiftUI

enum CardCategory {
    case countries
    case food
    case cultures
}
struct CardData: Identifiable {
    let id: UUID = UUID()
    let title: String
    let category:CardCategory
    let imageURL: URL?
}

func makeCardData()->Array<CardData> {
    return Array (
        countriesList.map { countries in
            CardData(
                title: countries,
                category: .countries,
                imageURL: URL(string: "https://source.unsplash.com/500x300/?\(countries)"))
        } +
        foodList.map { food in
            CardData(
                title: food,
                category: .food,
                imageURL: URL(string: "https://source.unsplash.com/500x300/?\(food)"))
        }
        +
        culturesList.map { cultures in
            CardData(
                title: cultures,
                category: .cultures,
                imageURL: URL(string: "https://source.unsplash.com/500x300/?\(cultures)"))
        })
}

struct CardView: View {
    let data: CardData
    
    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                AsyncImage(url: data.imageURL) { result in
                    if let image = result.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        ProgressView()
                    }
                }
                .frame(
                    width: geometryProxy.size.width,
                    height: geometryProxy.size.height
                )
                
                .padding(8)
                .foregroundColor(.white)
                .background(
                    Gradient(
                        colors: [
                            Color.clear,
                            Color.clear,
                            Color.clear,
                            Color.black
                        ]
                    )
                )
            }
            .cornerRadius(12)
            .frame(
                width: geometryProxy.size.width,
                height: geometryProxy.size.height
            )
        }
    }
}
struct ContentView: View {
    let categories: Array<String> = [
        "countries",
        "food",
        "cultures"
    ]
    
    let cards: Array<CardData> = makeCardData()
    @State var filteCardsData: Array<CardData> = []
    @State var searchText: String = ""
    
    var countriesCardData: Array<CardData> {
        cards.filter({ card in card.category == .countries })
    }
    
    var foodCardData: Array<CardData> {
        cards.filter({ card in card.category == .food })
    }
    
    var culturesCardData: Array<CardData> {
        cards.filter({ card in card.category == .cultures })
    }
    var body: some View {
        
        
        
        
        VStack {
            HStack {
                Image(systemName: "swift")
                TextField("Search", text: $searchText)
                    .frame(height: 40)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(12)
            
            ScrollView {
                HStack {
                    Text("cultures")
                    Spacer()
                    
                    NavigationLink(
                        destination: {
                            List(culturesCardData) { card in
                                
                                NavigationLink(destination: {
                                    Text("Details of Cultures!")
                                        .foregroundColor(.blue)
                                }, label:{ Text(card.title)}
                                )
                                
                            }
                        },
                        label: {
                            Text("See All >")
                        }
                    )
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(filteCardsData) {
                            card in
                            if card.category == .cultures{
                                CardView(data: card
                                )
                                
                                
                                .frame(width: 300, height: 150)
                            }
                        }
                    }
                }
                HStack {
                    Text("countries")
                    Spacer()
                    NavigationLink(
                        destination: {
                            List(countriesCardData) { card in
                                
                                NavigationLink(destination: {
                                    Text("Details of Countries!")
                                        .foregroundColor(.blue)
                                }, label:{ Text(card.title)}
                                )
                                
                            }
                        },
                        label: {
                            Text("See All >")
                        }
                    )
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(filteCardsData) {
                            card in
                            if card.category == .countries {
                                CardView(data: card
                                )
                                .frame(width: 300, height: 150)
                            }
                        }
                    }
                }
                HStack {
                    Text("food")
                    Spacer()
                    NavigationLink(
                        destination: {
                            List(foodCardData) { card in
                                
                                NavigationLink(destination: {
                                    Text("Details of Food!")
                                        .foregroundColor(.blue)
                                }, label:{ Text(card.title)}
                                )
                                
                            }
                        },
                        label: {
                            Text("See All >")
                        }
                    )
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(filteCardsData) {
                            card in
                            if card.category == .food{
                                CardView(data: card
                                )
                                .frame(width: 300, height: 150)
                            }}
                    }
                }
                Spacer()
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .onAppear() {
            prepareData()
        }
        .onChange(of: searchText) {newValue in
            filterCardBasedOn(newValue)
        }
    }
    func prepareData() {
        filteCardsData = cards
    }
    
    func filterCardBasedOn(_ value: String) {
        if value.isEmpty {
            filteCardsData = cards
        } else {let lowercasedValue = value.lowercased()
            filteCardsData = cards.filter({card in
                return card.title.lowercased().contains(lowercasedValue)}
                                          
            )}
    }
}
struct ProfileView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @State var showAlert:Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        Form {
            Section() {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            Section {
                SecureField("Password", text: $password)
                
                SecureField("Confirm Password", text: $confirmPassword)
                alert(isPresented: $showAlert) {
                    Alert(title: Text(alertMessage))
                }
            }
            
            Section {
                Button(action: {
                    validateInput()
                }) {
                    Text("Sign Up")
                }
                .disabled(!isValidInput())
            }
        }
    }
    
    private func isValidInput() -> Bool {
        return isValidEmail && isValidPassword
    }
    
    private func validateInput() {
        validateEmail()
        validatePassword()
    }
    
    private func validateEmail() {
        isValidEmail = email.isValidEmail()
    }
    
    private func validatePassword() {
        isValidPassword = password.isValidPassword() && password == confirmPassword
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        return count > 8
        
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Discovery",  systemImage: "doc")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                
            }
        }
    }
}

var foodList : Array<String> = """

Arepa
Biscuits
Cookie
Cracker
Bread
Croissant
Burrito
Cabbage roll
Cake
Pancake
Cheese
Donuts
Dumplings
Fun guo
Har gow
Pierogi
Wonton
French fries
Poutine
Grains
Cereal
Popcorn
Rice
Ice cream
Mashed potatoes
Meats
Beef
Steak
Eggs
Pork
Bacon
Ham
Poultry
Buffalo wing
Chicken balls
Chicken nuggets
Chicken steak
Chicken strips
"""
    .components(separatedBy: "\n")

var countriesList : Array<String> = """
Bhutan
Brunei
Oman
Qatar
Saudi Arabia
Swaziland
Tonga
United Arab Emirates
Vatican City State
Andorra
Belgium
Cambodia
Denmark
Japan
Lesotho
Luxembourg
Malaysia
Netherlands
Norway
Samoa
Spain
Sweden
"""
    .components(separatedBy:"\n")

var culturesList : Array<String> = """
Norms
Values
Language
Symbols
Artifacts
Material Culture
Non-Material Culture
Symbol Culture
Regional culture
Corporate Culture
"""
    .components(separatedBy:"\n")


