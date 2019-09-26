//
//  DetailStore.swift
//  MobileGuideClean
//
//  Created by Jiratip Hemwutthipan on 25/9/2562 BE.
//  Copyright (c) 2562 Jiratip. All rights reserved.
//

import Foundation

/*

 The DetailStore class implements the DetailStoreProtocol.

 The source for the data could be a database, cache, or a web service.

 You may remove these comments from the file.

 */

class DetailStore: DetailStoreProtocol {
//  func getData(_ completion: @escaping (Result<ImageModel>) -> Void) {
    // Simulates an asynchronous background thread that calls back on the main thread after 2 seconds
//    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//      completion(Result.success(ImageModel()))
//    }
//  }
    func getImgList(url: String, _ completion: @escaping (Result<[ImageModel], Error>) -> Void) {
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
                        let mobile = try JSONDecoder().decode([ImageModel].self, from: data)
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
