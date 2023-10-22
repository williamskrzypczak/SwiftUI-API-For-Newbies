//
//  ContentView.swift
//  Swift API Calls for Newbies Github Open API
//
//  Created by Bill Skrzypczak on 10/22/23.
//

import SwiftUI

//---------------------------------------------------
// Step 1 build a UI based on the data you will
// be getting back from the API
//---------------------------------------------------

struct ContentView: View {
    
    // Use an optional to handle the Github User
    @State private var user: GitHubUser?
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Create a placeholder for the Github user Avatar
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
                    .frame(width: 120, height: 120)
                
                // Create a placeholder for the Github user Name
                 Text(user?.login ?? "Where the GitHub users name will go")
                    .bold()
                    .font(.title3)
                
                // Create a placeholder for the Github users Bio
                Text(user?.bio ?? "Where the GitHub users Bio will go")
                    .padding()
                
                Spacer()
                
            }
            .padding()
            
            // Handle any errors you may get
            .task {
                do {
                    user = try await getUser()
                } catch GHError.invalidURL {
                    print("invalid URL")
                } catch GHError.invalidData {
                    print("invalid Data")
                } catch GHError.invalidResponse {
                    print("invalid Response")
                } catch {
                    print("unexpected error")
                }
            }
            
        }
    }

//------------------------------------------------------------
// Step 3 Build your network call and GET the data (POST/PUT/DELETE)
//------------------------------------------------------------
    
    func getUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/"
        
        // Error catch if URL is bad
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Error catch if data reponse is bad
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }

//----------------------------------------------------------------
// Step 4 Get the data and catch the error if something goes wrong
//----------------------------------------------------------------
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
//-------------------------------------------------------------
// Step 2 Build the Data Model
//-------------------------------------------------------------
    
    struct GitHubUser: Codable {
        let login: String
        let avatarUrl: String //*** Snake Case is a NO NO hand
        let bio: String
    }
    
    // Setup error handling cases
    
    enum GHError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }

