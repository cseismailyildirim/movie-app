//
//  MovieDetailViewController.swift
//  movie-app
//
//  Created by ismailyildirim on 5.03.2021.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelVoteCount: UILabel!
    
    private var viewModel: MovieDetailViewModelProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize(viewModel: MovieDetailViewModelProtocol){
        self.viewModel = viewModel
    }
    
    private func initialize(){
        viewModel?.getData()
        self.title = "Content Details"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(onClickFavorite))
        
        self.labelTitle.font = UIFont.boldSystemFont(ofSize: 20)
        self.labelDescription.numberOfLines = 0
        
        viewModel?.updateUI = { [weak self] () in
            guard self != nil else {
                return
            }
            DispatchQueue.main.async {
                if let url = self!.viewModel?.movieImage {
                    self!.imageView.load(url: url)
                }
                self!.labelTitle.text = self!.viewModel!.name
                self!.labelDescription.text = self!.viewModel!.description
                self!.labelVoteCount.text = "Vote Count : \(self!.viewModel!.voteCount!)"
                var image = UIImage(named: (self!.viewModel?.isFavorite ?? false) ? "favoriteIcon" : "unfavoriteIcon" )
                image = image?.withRenderingMode(.alwaysOriginal)
                self!.navigationItem.rightBarButtonItem?.image = image
            }
        }
    }
    
    @objc func onClickFavorite(){
        viewModel?.addFavorite()
    }
    
   
}
