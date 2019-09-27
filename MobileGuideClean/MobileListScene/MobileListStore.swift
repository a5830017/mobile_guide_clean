//
//  MobileListStore.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 23/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import Foundation

class MobileListStore: MobileListStoreProtocol {
    func getMobileList(url: String, _ completion: @escaping (Result<[MobileModel], Error>) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let apiError = error {
                DispatchQueue.main.async {
                    completion(Result.failure(apiError))
                }
                print("error")
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    do {
                        let mobile = try JSONDecoder().decode([MobileModel].self, from: data)
                        print(mobile)
                        DispatchQueue.main.async {
                            completion(Result.success(mobile))
                        }
                    } catch (let error) { // get error
                        print(error)
                        print("parse JSON failed")
                        DispatchQueue.main.async {
                            completion(Result.failure(error))
                        }
                    }
                }
            }
        }
        task.resume()
    }
}

