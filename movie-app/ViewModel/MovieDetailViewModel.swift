//
//  MovieDetailViewModel.swift
//  movie-app
//
//  Created by ismailyildirim on 6.03.2021.
//

import Foundation
protocol MovieDetailViewModelProtocol {
    var updateUI: (() -> ())? { get set }
    var movieImage: URL? { get }
    var name : String! { get }
    var description : String! { get }
    var voteCount : String! { get }
    var isFavorite:Bool! { get }
    func getData()
    func addFavorite()
    func updateFavorite()
}
class MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    private var id: Int!
    
    var updateUI: (() -> ())?
    
    var movieImage: URL?
    var name: String!
    var description: String!
    var voteCount: String!
    var isFavorite:Bool!
    
    private var IMAGE_PREFIX = "https://image.tmdb.org/t/p/w500"
    
    private var responseModel: MovieDetailResponseModel?{
        didSet{
            setData()
        }
    }
    
    init(id:Int) {
        self.id = id
    }
    
    func getData(){
        NetworkManager().request(model: .detail(String(describing: id!))) { (response: MovieDetailResponseModel ) in
            self.responseModel = response
        } onError: { (err) in
            print(err)
        }
    }
    
    private func setData(){
        self.movieImage = URL(string: "\(IMAGE_PREFIX)\(responseModel?.posterPath ?? "")")
        self.name = responseModel?.title ?? ""
        self.description = responseModel?.overview
        self.voteCount = String(describing: responseModel?.voteCount ?? 0)
        getFavoriteData()
    }
    
    func updateFavorite() {
        
    }
    
    func getFavoriteData(){
        DispatchQueue.main.async {
            DatabaseManager.shared.get(id: self.id) { (result) in
                self.isFavorite = result
                self.updateUI?()
            }
        }
    }
    
    func addFavorite(){
        DispatchQueue.main.async {
            DatabaseManager.shared.add(id: self.id, isFavorite: self.isFavorite) { (result) in
                self.isFavorite = !self.isFavorite
                self.updateUI?()
            }
        }
        
    }
    
    
}
