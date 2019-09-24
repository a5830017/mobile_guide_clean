//
//  MobileListStore.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 23/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import Foundation

/*
 
 The MobileListStore class implements the MobileListStoreProtocol.
 
 The source for the data could be a database, cache, or a web service.
 
 You may remove these comments from the file.
 
 */

class MobileListStore: MobileListStoreProtocol {
    func getMobileList(url: String, _ completion: @escaping (Result<[MobileModel], Error>) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                print("error")
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    do {
                        let mobile = try JSONDecoder().decode([MobileModel].self, from: data)
                        print(mobile)
                        completion(Result.success(mobile))
                    } catch (let error) { // get error
                        print(error)
                        print("parse JSON failed")
                    }
                }
            }
        }
        task.resume()
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        ////                completion(Result.success([MobileModel]()))
        //            }
    }
}

