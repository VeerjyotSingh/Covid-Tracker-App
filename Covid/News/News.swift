//
//  News.swift
//  Covid
//
//  Created by Veerjyot Singh on 08/05/22.
//
import Foundation
import UIKit

final class APICaller{
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL=URL(string:"https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=a7c40948db6d454aa8ee3f7d5754234b")
    }
    
    
    private func intit() {}
    
    public func getTopStories(completion:@escaping (Result<[Article], Error>)->Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){data, _, error in
            if let error = error {
                completion(.failure(error))
            }else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse .self, from: data)
                    print(result.articles.count)
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

//models
struct APIResponse: Codable{
    let articles: [Article]
    let totalResults:Int
}

struct Article: Codable{
    let source: Source
    let title:String
    let description:String?
    let url:String
    let urlToImage: String?
    let publishedAt:String
}
struct Source:Codable{
    let name:String
}
