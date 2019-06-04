//
//  ApiController.swift
//  pictureSearch
//
//  Created by Vladyslav Filipov on 6/4/19.
//  Copyright © 2019 Vladyslav Filipov. All rights reserved.
//

import Foundation

class ApiController {
    
    private let scheme = "https"
    private let host = "api.giphy.com"
    private let path = "/v1/gifs/search"
    
    private let apiKey = "aC4g9aEVPXOSfBvCj7KBeJZULFmHMYjE"
    
    private let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
    
    func getImages(by searchPhrase: String, with completion: @escaping ([ImagesCollection])->()) {
        var components = URLComponents()
        
        components.scheme = scheme
        components.host = host
        components.path = path
        
        let queryItemApi = URLQueryItem(name: "api_key", value: apiKey)
        let queryItemQuery = URLQueryItem(name: "q", value: searchPhrase)
        let queryItemLimit = URLQueryItem(name: "limit", value: "25")
        let queryItemOffset = URLQueryItem(name: "offset", value: "0")
        let queryItemRating = URLQueryItem(name: "rating", value: "G")
        
        components.queryItems = [queryItemApi ,queryItemQuery, queryItemLimit, queryItemOffset, queryItemRating]
        
        guard let url = components.url else { return }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data,
            let response = try? JSONDecoder().decode(ResponseData.self, from: data)  {
                completion(response.data)
            }
        })
        
        task.resume()
    }
}

class ResponseData: NSObject, Decodable {
    
    let data: [ImagesCollection]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([ImagesCollection].self, forKey: .data)
    }
}

class ImagesCollection: NSObject, Decodable {
    
    let jpeg: JPEGContainer
    
    enum CodingKeys: String, CodingKey {
        case jpeg = "images"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jpeg = try container.decode(JPEGContainer.self, forKey: .jpeg)
    }
}

class JPEGContainer: NSObject, Decodable {
    
    let image: Image
    
    enum CodingKeys: String, CodingKey {
        case image = "480w_still"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        image = try container.decode(Image.self, forKey: .image)
    }
}

class Image: NSObject, Decodable {

    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        urlString = try container.decode(String.self, forKey: .url)
    }
}
