//
//  NewsTableView.swift
//  Covid
//
//  Created by Veerjyot Singh on 10/05/22.
//

import UIKit

class NewsTableViewCellViewModel{
    let title:String
    let subtitle:String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init (
        title:String,
        subtitle:String,
        imageURL: URL?
    ){
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell{
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let subtitleLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private var newsImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(subtitleLable)
        contentView.addSubview(newsTitleLable)
    }
    required init?(coder:NSCoder){
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLable.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width-160, height: contentView.frame.size.height/2)
        
        subtitleLable.frame = CGRect(x: 10, y: 70, width:  contentView.frame.size.width-180, height: contentView.frame.size.height/2)
        
        newsImageView.frame = CGRect(x: contentView.frame.size.width-150, y: 5, width: 140, height: contentView.frame.size.height - 10)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLable.text = nil
        subtitleLable.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel){
        newsTitleLable.text = viewModel.title
        subtitleLable.text = viewModel.subtitle
        //image
        if let data = viewModel.imageData{
            newsImageView.image = UIImage(data:  data)
            
        }
        else if let url = viewModel.imageURL{
            //fetch the image
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
