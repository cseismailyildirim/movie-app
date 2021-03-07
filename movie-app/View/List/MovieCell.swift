//
//  MovieCell.swift
//  movie-app
//
//  Created by ismailyildirim on 5.03.2021.
//

import UIKit

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var imageViewFavorite: UIImageView!
    
    private var viewModel: MovieCellViewModelProtocol?
    private var gridPresentation: Bool!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(viewModel:MovieCellViewModel, gridPresentation: Bool){
        self.viewModel = viewModel
        
        if viewModel.isFavorite {
            self.imageViewFavorite.image = UIImage(named: "favoriteIcon")
        }else{
            self.imageViewFavorite.image = UIImage(named: "unfavoriteIcon")
        }
     
        if let url = self.viewModel!.getMovieImage(gridPresentation: gridPresentation) {
            self.imageView.load(url: url)
        }
        
        self.labelMovieTitle.text = self.viewModel!.movieTitle
        
    }
    

}
