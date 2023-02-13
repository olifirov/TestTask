//
//  ArticleTableViewCell.swift
//  TestTask
//
//  Created by Дмитрий Олифиров on 09.02.2023.
//

import UIKit
import SnapKit

class ArticleCell: UITableViewCell {
    
    let articleImageView = UIImageView()
    let articleTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(articleImageView)
        contentView.addSubview(articleTitleLabel)
        
        articleImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(10)
            make.height.width.equalTo(80)
        }
        
        articleTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalTo(articleImageView.snp.right).inset(-10)
            make.right.equalToSuperview().inset(10)
        }
    }
    
    func configureCell(article: Article) {
        articleTitleLabel.text = article.title
        articleTitleLabel.lineBreakMode = .byWordWrapping
        articleTitleLabel.numberOfLines = 0
        articleImageView.contentMode = .scaleAspectFit
        
        guard !article.media.isEmpty else {
            self.articleImageView.image = UIImage(named: "imagePlaceholder")
            return
        }
        guard let imageUrl = URL(string: article.media[0].mediaMetadata[0].url) else { return }

        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imageUrl),
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self.articleImageView.image = image
            }
        }
    }
    
    func configureWithStoredArticle(article: StoredArticle) {
        articleTitleLabel.text = article.title
        articleTitleLabel.lineBreakMode = .byWordWrapping
        articleTitleLabel.numberOfLines = 0
        articleImageView.contentMode = .scaleAspectFit
        
        guard let data = article.smallImage else {
            self.articleImageView.image = UIImage(named: "imagePlaceholder")
            return
        }
        let image = UIImage(data: data)
        self.articleImageView.image = image
    }
}
