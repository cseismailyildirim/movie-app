//
//  MovieListViewModel.swift
//  movie-app
//
//  Created by ismailyildirim on 5.03.2021.
//

import Foundation

protocol MovieListViewModelProtocol {
    var gridPresentation: Bool! { get }
    var reloadDataClosure: (() -> ())? { get set } 
    func numberOfItems() -> Int
    func getItem(index: Int) -> MovieListViewModel.CellType
    func loadMore()
    func changePresentation() -> Bool
    func getDetailModel(index: Int) -> MovieDetailViewModelProtocol
  
    func search(text:String)
    
    func getFavorites()
    
}
class MovieListViewModel: MovieListViewModelProtocol {
    
    var gridPresentation: Bool!
    
    private var currentPageIndex: Int = 1
    private var responseModel: MovieListResponseModel?{
        didSet{
            setData()
        }
    }
    private var dataSource: [CellType] = []
    private var backup: [CellType] = []
    private var favorites: [Int] = []{
        didSet{
            setData()
        }
    }
    
    var reloadDataClosure: (() -> ())?
    
    init() {
        getFavorites()
        gridPresentation = false
    }
    
    enum CellType {
        case movie(MovieCellViewModel)
        case loadMore
    }
    
    func numberOfItems() -> Int {
        dataSource.count
    }
    
    func getItem(index: Int) -> CellType {
        return self.dataSource[index]
    }
    
    func loadMore(){
        self.getData(page: self.currentPageIndex)
    }
    
    func changePresentation() -> Bool{
        gridPresentation = !gridPresentation
        self.reloadDataClosure?()
        return gridPresentation
    }
    
    func getDetailModel(index: Int) -> MovieDetailViewModelProtocol {
        switch self.dataSource[index] {
        case .movie(let item):
            return MovieDetailViewModel(id: item.id)
        default:
            return MovieDetailViewModel(id: 0)
            
        }
    }
    
    func search(text: String) {
        if text.isEmpty {
            if self.backup.count < 1{
                return
            }
            self.dataSource = self.backup
            self.backup = []
            self.reloadDataClosure?()
            return
        }
        
        if backup.count < 1 {
            backup = dataSource
        }
      
        
        self.dataSource = self.backup.filter { (type) -> Bool in
            switch type {
            case .movie(let item):
                return item.movieTitle.lowercased().contains(text)
            case .loadMore:
                return false
            }
        }
        self.reloadDataClosure?()
    }
    
    
    private func getData(page:Int? = 1){
        if page == 1 && self.responseModel != nil {
            NetworkManager().request(model: .popularList(String(describing: page!))) { (response:MovieListResponseModel) in
                self.backup = []
                self.dataSource = []
                self.responseModel = response
                self.currentPageIndex += 1
            } onError: { (err) in
                print(err)
            }
        }else{
            NetworkManager().request(model: .popularList(String(describing: page!))) { (response:MovieListResponseModel) in
                self.responseModel = response
                self.currentPageIndex += 1
            } onError: { (err) in
                print(err)
            }
        }
       
    }
    
    private func setData(){
        if let movieList = responseModel?.results {
            if dataSource.count > 0 {
                dataSource.removeLast()
            }
            for item in movieList {
                dataSource.append(.movie(MovieCellViewModel(model: item, isFavorite: favorites.contains(item.id ?? 0))))
            }
            if currentPageIndex < (self.responseModel?.totalPages ?? 1) {
                dataSource.append(.loadMore)
            }
            self.reloadDataClosure?()
        }else{
            //TODO
        }
    }
    
    func getFavorites(){
        DatabaseManager.shared.getAll { (result) in
            self.favorites = result
            getData()
        }
    }
    

}
