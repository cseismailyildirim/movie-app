//
//  MovieCellViewModel.swift
//  movie-app
//
//  Created by ismailyildirim on 6.03.2021.
//

import Foundation
protocol MovieCellViewModelProtocol {
    var id: Int { get }
    var movieTitle: String { get }
    func getMovieImage(gridPresentation:Bool) -> URL?
}
class MovieCellViewModel: MovieCellViewModelProtocol {
    var id: Int
    var movieTitle: String
    var isFavorite: Bool
    
    private var IMAGE_LIST_PREFIX = "https://image.tmdb.org/t/p/w200"
    private var IMAGE_GRID_PREFIX = "https://image.tmdb.org/t/p/w500"

    private var model: MovieListItemModel
    
    init(model: MovieListItemModel, isFavorite:Bool){
        self.isFavorite = isFavorite
        self.model = model
        self.id = model.id ?? 0
        movieTitle = model.title ?? ""
    }
    
    func getMovieImage(gridPresentation: Bool) -> URL? {
        if gridPresentation {
            return URL(string: "\(IMAGE_GRID_PREFIX)\(model.posterPath ?? "")")
        }else{
            return URL(string: "\(IMAGE_LIST_PREFIX)\(model.posterPath ?? "")")
        }
    }
    
}
