//
//  RoommateAPI.swift
//  Roommate App
//
//  Created by Logan Norman on 4/2/23.
//

import Foundation

class APIClient {
    
    static let baseURL = "http://localhost:4000/user/"
    
    static func login(body: [String : String], completion: @escaping (Bool, Error?) -> Void) {
        APIClient.post(to: "login", body: body, responseType: UserToken.self) { result in
            switch result {
            case .success(let json):
                print("User logged in successfully", json)
                completion(true, nil)
            case .failure(let error):
                print("Failed to login user", error)
                completion(false, error)
            }
        }
    }

    static func signup(body: [String : String], completion: @escaping (Bool, Error?) -> Void) {
        APIClient.post(to: "signup", body: body, responseType: UserToken.self) { result in
            switch result {
            case .success(let json):
                print("User created successfully", json)
                completion(true, nil)
            case .failure(let error):
                print("Failed to sign up user", error)
                completion(false, error)
            }
        }
    }
    
    static func get<T: Decodable>(from endpoint: String, parameters: [String: String] = [:], responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = baseURL + endpoint + "?" + parameters.map({ "\($0)=\($1)" }).joined(separator: "&")
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let payload = try JSONDecoder().decode(responseType, from: data)
                completion(.success(payload))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func post<T: Decodable>(to endpoint: String, parameters: [String: String] = [:], body: [String: Any], responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = baseURL + endpoint + "?" + parameters.map({ "\($0)=\($1)" }).joined(separator: "&")
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = bodyData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print(response as Any)
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            if let data = data {
                do {
                    let payload = try JSONDecoder().decode(responseType, from: data)
                    completion(.success(payload))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
            }
        }.resume()
    }
}
