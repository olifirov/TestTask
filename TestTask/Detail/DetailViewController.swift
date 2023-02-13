//
//  DetailViewController.swift
//  TestTask
//
//  Created by Дмитрий Олифиров on 09.02.2023.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    let article: Article?
    let storedArticle: StoredArticle?
    
    let scrollView = UIScrollView()
    let articleImageView = UIImageView()
    let titleLabel = UILabel()
    let abstractTitleLabel = UILabel()
    let addToFavoriteButton = UIButton(type: .system)
    let urlButton = UIButton()
    let articleIDLabel = UILabel()
    let subsectionLabel = UILabel()
    let sectionLabel = UILabel()
    let publishedDateLabel = UILabel()
    let updateDateLabel = UILabel()
    let bylineLabel = UILabel()
    let typeLabel = UILabel()
    let sourceLabel = UILabel()
    let keyWordsLabel = UILabel()
    let descriptionFacetsLabel = UILabel()
    let organizationFacetsLabel = UILabel()
    let personFacetsLabel = UILabel()
    let geographicFacetsLabel = UILabel()
    
    let id: Int
    let abstract: String
    let adxKeywords: String
    let beline: String
    let desFacets: String
    let orgFacets: String
    let perFacets: String
    let geoFacets: String
    let publishedDate: String
    let section: String
    let source: String
    let subsection: String
    let articleTitle: String
    let type: String
    let updatedDate: String
    let url: String

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
        overrideUserInterfaceStyle = .light
    }
    
    //MARK: - Init with stored article
    convenience init(storedArticle: StoredArticle) {
        
        let id = Int(storedArticle.id)
        let abstract = storedArticle.abstract ?? ""
        let adxKeywords = storedArticle.adxKeywords ?? ""
        let beline = storedArticle.byline ?? ""
        let desFacets = storedArticle.desFacet ?? ""
        let orgFacets = storedArticle.orgFacet ?? ""
        let perFacets = storedArticle.perFacet ?? ""
        let geoFacets = storedArticle.geoFacet ?? ""
        let publishedDate = storedArticle.publishedDate ?? ""
        let section = storedArticle.section ?? ""
        let source = storedArticle.source ?? ""
        let subsection = storedArticle.subsection ?? ""
        let articleTitle = storedArticle.title ?? ""
        let type = storedArticle.type ?? ""
        let updatedDate = storedArticle.updatedDate ?? ""
        let url = storedArticle.url ?? ""
        
        self.init(id: id, abstract: abstract, adxKeywords: adxKeywords, beline: beline, desFacets: desFacets, orgFacets: orgFacets, perFacets: perFacets, geoFacets: geoFacets, publishedDate: publishedDate, section: section, sorce: source, subsection: subsection, articleTitle: articleTitle, type: type, updatedDate: updatedDate, url: url, article: nil, storedArticle: storedArticle)
        
        guard let data = storedArticle.image else {
            self.articleImageView.image = UIImage(named: "imagePlaceholder")
            return
        }
        self.articleImageView.image = UIImage(data: data)
    }
    
    //MARK: - Init with article from API
    convenience init(article: Article) {
        
        let id = Int(article.id)
        let abstract = article.abstract
        let adxKeywords = article.adxKeywords
        let beline = article.byline
        let desFacets = getStringFromArray(article.desFacet)
        let orgFacets = getStringFromArray(article.orgFacet)
        let perFacets = getStringFromArray(article.perFacet)
        let geoFacets = getStringFromArray(article.geoFacet)
        let publishedDate = article.publishedDate
        let section = article.section
        let source = article.source.rawValue
        let subsection = article.subsection
        let articleTitle = article.title
        let type = article.type.rawValue
        let updatedDate = article.updated
        let url = article.url
        
        self.init(id: id, abstract: abstract, adxKeywords: adxKeywords, beline: beline, desFacets: desFacets, orgFacets: orgFacets, perFacets: perFacets, geoFacets: geoFacets, publishedDate: publishedDate, section: section, sorce: source, subsection: subsection, articleTitle: articleTitle, type: type, updatedDate: updatedDate, url: url, article: article, storedArticle: nil)
        
        guard !article.media.isEmpty, let imageUrl = URL(string: article.media[0].mediaMetadata[2].url) else {
            self.articleImageView.image = UIImage(named: "imagePlaceholder")
            return
        }

        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imageUrl),
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self.articleImageView.image = image
            }
        }
        
        func getStringFromArray(_ array: [String]) -> String {
            if array.isEmpty {
                return "Empty"
            } else {
                return array.joined(separator: ", ")
            }
        }
    }
    
    //MARK: - Designated init
    init(id: Int, abstract: String, adxKeywords: String, beline: String, desFacets: String, orgFacets: String, perFacets: String, geoFacets: String, publishedDate: String, section: String, sorce: String, subsection: String, articleTitle: String, type: String, updatedDate: String, url: String, article: Article?, storedArticle: StoredArticle?) {
        
        self.id = id
        self.abstract = abstract
        self.adxKeywords = adxKeywords
        self.beline = beline
        self.desFacets = desFacets
        self.orgFacets = orgFacets
        self.perFacets = perFacets
        self.geoFacets = geoFacets
        self.publishedDate = publishedDate
        self.section = section
        self.source = sorce
        self.subsection = subsection
        self.articleTitle = articleTitle
        self.type = type
        self.updatedDate = updatedDate
        self.url = url
        self.article = article
        self.storedArticle = storedArticle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure UI
    func setupInterface() {
        view.addSubview(scrollView)
        [articleImageView, titleLabel, abstractTitleLabel, addToFavoriteButton, urlButton, articleIDLabel, sectionLabel, subsectionLabel, publishedDateLabel, updateDateLabel, bylineLabel, typeLabel, sourceLabel, keyWordsLabel, descriptionFacetsLabel, organizationFacetsLabel, personFacetsLabel, geographicFacetsLabel].forEach { element in
            scrollView.addSubview(element)
            
            if element is UILabel {
                (element as! UILabel).lineBreakMode = .byWordWrapping
                (element as! UILabel).numberOfLines = 0
                (element as! UILabel).textAlignment = .center
            }
        }
        
        articleImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = articleTitle
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        
        abstractTitleLabel.text = abstract
        abstractTitleLabel.font = UIFont.systemFont(ofSize: 20)
        
        configureButtonTitle()
        addToFavoriteButton.addTarget(self, action: #selector(saveArticle), for: .touchUpInside)
        let buttonImage = UIImage(systemName: "star.fill")
        addToFavoriteButton.tintColor = .white
        addToFavoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addToFavoriteButton.setImage(buttonImage, for: .normal)
        addToFavoriteButton.backgroundColor = .systemBlue
        addToFavoriteButton.layer.borderColor = UIColor.lightGray.cgColor
        addToFavoriteButton.layer.borderWidth = 2
        
        urlButton.setTitle(url, for: .normal)
        urlButton.addTarget(self, action: #selector(followURL), for: .touchUpInside)
        urlButton.setTitleColor(.blue, for: .normal)
        urlButton.titleLabel?.numberOfLines = 0
        urlButton.titleLabel?.textAlignment = .center
        
        articleIDLabel.text = "Article id: \(id)"
        
        if subsection == "" {
            subsectionLabel.text = "Subsection: Empty"
        } else {
            subsectionLabel.text = "Subsection: \(subsection)"
        }
        
        sectionLabel.text = "Section: \(section)"
        publishedDateLabel.text = "Published: \(publishedDate)"
        updateDateLabel.text = "Updated: \(updatedDate)"
        bylineLabel.text = "Byline: \(beline)"
        typeLabel.text = "Type: \(type)"
        sourceLabel.text = "Source: \(source)"
        keyWordsLabel.text = "Keywords: \(adxKeywords)"
        descriptionFacetsLabel.text = "Description: " + desFacets
        organizationFacetsLabel.text = "Organizations: " + orgFacets
        personFacetsLabel.text = "Persons: " + perFacets
        geographicFacetsLabel.text = "Geographic: " + geoFacets
        
        //MARK: - layout
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        articleImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(articleImageView.snp.bottom).inset(-10)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        abstractTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        addToFavoriteButton.snp.makeConstraints { make in
            make.top.equalTo(abstractTitleLabel.snp.bottom).inset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        urlButton.snp.makeConstraints { make in
            make.top.equalTo(addToFavoriteButton.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        articleIDLabel.snp.makeConstraints { make in
            make.top.equalTo(urlButton.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(articleIDLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        subsectionLabel.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        publishedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(subsectionLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        updateDateLabel.snp.makeConstraints { make in
            make.top.equalTo(publishedDateLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        bylineLabel.snp.makeConstraints { make in
            make.top.equalTo(updateDateLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(bylineLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        keyWordsLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        descriptionFacetsLabel.snp.makeConstraints { make in
            make.top.equalTo(keyWordsLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        organizationFacetsLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionFacetsLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        personFacetsLabel.snp.makeConstraints { make in
            make.top.equalTo(organizationFacetsLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        geographicFacetsLabel.snp.makeConstraints { make in
            make.top.equalTo(personFacetsLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalTo(scrollView).inset(20)
        }
    }
    
    //MARK: - methods
    private func configureButtonTitle() {
        if let article = self.article {
            if StoredDataManager.shared.isAllreadyContains(article: article) {
                self.addToFavoriteButton.setTitle("In favorites", for: .normal)
                self.addToFavoriteButton.isUserInteractionEnabled = false
            } else {
                addToFavoriteButton.setTitle("Add to favorites", for: .normal)
            }
        } else {
            self.addToFavoriteButton.setTitle("In favorites", for: .normal)
            self.addToFavoriteButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func followURL() {
        if let urlString = urlButton.titleLabel?.text, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func saveArticle() {
        guard let article = self.article else { return }
        guard !StoredDataManager.shared.isAllreadyContains(article: article) else { return }
        StoredDataManager.shared.saveArticle(article: article)
        self.addToFavoriteButton.setTitle("In favorites", for: .normal)
        self.addToFavoriteButton.isUserInteractionEnabled = false
    }
}
