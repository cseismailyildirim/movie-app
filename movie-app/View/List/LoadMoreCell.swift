//
//  LoadMoreCell.swift
//  movie-app
//
//  Created by ismailyildirim on 5.03.2021.
//

import UIKit
protocol LoadMoreCellDelegate {
    func onClickLoadMore()
}
class LoadMoreCell: UICollectionViewCell {

    private var delegate: LoadMoreCellDelegate?
    @IBOutlet weak var buttonLoadMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize(){
        buttonLoadMore.backgroundColor = .blue
        buttonLoadMore.setTitle("Load More", for: . normal)
        buttonLoadMore.setTitleColor(.white, for: .normal)
        buttonLoadMore.layer.cornerRadius = 4
    }
    
    func initialize(delegate: LoadMoreCellDelegate){
        self.delegate = delegate
    }
    @IBAction func actionLoadMore(_ sender: Any) {
        self.delegate?.onClickLoadMore()
    }
    
}
