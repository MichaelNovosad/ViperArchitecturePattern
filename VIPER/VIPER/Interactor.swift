//
//  Interactor.swift
//  VIPER
//
//  Created by Michael Novosad on 07.05.2022.
//

import Foundation

// Object
// We need a protocol for it
// Has reference to Presenter

// Main job of Interactor is to get some data, to interact with smth for some data and to provide it to Presenter

// Mock API for some data 
//https://jsonplaceholder.typicode.com/users

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    // Interactor will inform of getting users, so no completion
    func getUsers()
}

public class UserInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func getUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
                return
            }
            
            do {
                let entities = try JSONDecoder().decode([User].self, from: data)
                self?.presenter?.interactorDidFetchUsers(with: .success(entities))
            }
            catch {
                self?.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
            }
        }
        task.resume()
    }
}
