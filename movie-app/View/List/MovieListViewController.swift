//
//  MovieListViewController.swift
//  movie-app
//
//  Created by ismailyildirim on 5.03.2021.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var viewModel: MovieListViewModelProtocol = {
        return MovieListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavorites()
    }
    
    private func initialize(){
        self.title = "Contents"
        var image = UIImage(named: "gridIcon")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
        
        searchBar.delegate = self
        collectionView.register(cellType: MovieCell.self)
        collectionView.register(cellType: LoadMoreCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        viewModel.reloadDataClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    @objc func addTapped(sender: UIBarButtonItem) {
        let style =  viewModel.changePresentation()
        var image = UIImage(named: style ? "listIcon" : "gridIcon" )
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image = image
    }
    
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //The last cell is reserved for the load more button.
        switch viewModel.getItem(index: indexPath.row) {
        case .movie(let item):
            let cell = self.collectionView.dequeueReusableCell(with: MovieCell.self, for: indexPath)
            cell.initialize(viewModel: item, gridPresentation: self.viewModel.gridPresentation)
            return cell
        case .loadMore:
            let cell = self.collectionView.dequeueReusableCell(with: LoadMoreCell.self, for: indexPath)
            cell.initialize(delegate: self)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //The last cell is reserved for the load more button.
        switch viewModel.getItem(index: indexPath.row) {
        case .movie(_):
            if self.viewModel.gridPresentation {
                return CGSize(width: (self.collectionView.frame.width - 10) / 2 , height: 200)
            }else{
                return CGSize(width: self.collectionView.frame.width , height: 200)
            }
            
        case .loadMore:
            return CGSize(width: self.collectionView.frame.width , height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc =   UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController")  as? MovieDetailViewController {
            vc.initialize(viewModel: self.viewModel.getDetailModel(index: indexPath.row))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension MovieListViewController: LoadMoreCellDelegate {
    func onClickLoadMore() {
        self.viewModel.loadMore()
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.search(text: searchText.lowercased())
    }
}

