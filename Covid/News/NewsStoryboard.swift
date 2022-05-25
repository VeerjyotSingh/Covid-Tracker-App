//
//  NewsStoryboard.swift
//  Covid
//
//  Created by Veerjyot Singh on 12/05/22.
//


import UIKit
import SafariServices


class NewsViewController : UIViewController, UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier:NewsTableViewCell.identifier)
        return table
    }()
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article ]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.addSubview(self.tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getTopStories{[weak self] result in
            switch result{
            case.success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? "", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.sync {
                    self?.tableView.reloadData()
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else{
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at:indexPath,animated:true)
        let articles = articles[indexPath.row]
         
        guard let url = URL(string:articles.url ) else {
            return
        }
        let vc = SFSafariViewController(url:url)
        present(vc,animated:true)
     }
    
    func tableView(_ tableView:UITableView, heightForRowAt indexPath :IndexPath)->CGFloat{
        return 150
    }
    
}
