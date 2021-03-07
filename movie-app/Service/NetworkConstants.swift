//
//  NetworkConstants.swift
//  movie-app
//
//  Created by ismailyildirim on 6.03.2021.
//

import Foundation


enum NetworkConstants {
    
    var BASE_URL:String { "https://api.themoviedb.org/3/movie" }
    
    var LANGUAGE: String { "en-US" }
    var API_KEY: String { "fd2b04342048fa2d5f728561866ad52a" }
    
    
    case popularList(String)
    case detail(String)
    
    var endpoint: String {
        switch self {
        case .popularList(let page):
            return "/popular?language=\(LANGUAGE)&api_key=\(API_KEY)&page=\(String(describing: page))"
        case .detail(let id):
            return "/\(String(describing: id))?language=en-US&api_key=fd2b04342048fa2d5f728561866ad52a"
        }
    }
    
}
