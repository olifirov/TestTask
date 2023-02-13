//
//  ViewController.swift
//  TestTask
//
//  Created by Дмитрий Олифиров on 08.02.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    let tabBar = UITabBar()
    let articlesTableView = UITableView()
    var isStoredModeOn = false
    var isEditingEnabled = false
    let netwrokManager = NetworkManager()
    var articles: [Article] = []
    var storedArticles: [StoredArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        setupTabBar()
        setupTableView()
        getArticlesFromAPI(tabBarItemTag: 0)
        self.title = "Articles"
    }
    
    private func setupTabBar() {
        let mostEmailedTabBarItem = UITabBarItem(title: ContentType.mostEmailed.rawValue, image: UIImage(systemName: "envelope.fill"), tag: 0)
        let mostSharedTabBarItem = UITabBarItem(title: ContentType.mostShared.rawValue, image: UIImage(systemName: "person.3.fill"), tag: 1)
        let mostViewedTabBarItem = UITabBarItem(title: ContentType.mostViewed.rawValue, image: UIImage(systemName: "eye.fill"), tag: 2)
        let tabBarItem4 = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 3)
        tabBar.items = [mostEmailedTabBarItem, mostSharedTabBarItem, mostViewedTabBarItem, tabBarItem4]
        tabBar.selectedItem = mostEmailedTabBarItem
        tabBar.delegate = self
        
        view.addSubview(tabBar)
        
        tabBar.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupTableView() {
        articlesTableView.dataSource = self
        articlesTableView.delegate = self
        articlesTableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        view.addSubview(articlesTableView)
        
        articlesTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(tabBar.snp.top)
            make.width.equalToSuperview()
        }
    }
    
    private func getArticlesFromAPI(tabBarItemTag: Int) {
        var contentType: ContentType = .mostEmailed
        switch tabBarItemTag {
        case 0: contentType = .mostEmailed
        case 1: contentType = .mostShared
        case 2: contentType = .mostViewed
        default:
            break
        }
        
        netwrokManager.getArticles(contentType: contentType) { articles in
            self.articles = articles
            self.articlesTableView.reloadData()
        }
    }
    
    private func getStoredArticles() {
        storedArticles = StoredDataManager.shared.loadArticles() ?? []
        self.articlesTableView.reloadData()
    }
}

//MARK: - TabBarDelegate
extension MainViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0, 1, 2:
            isStoredModeOn = false
            isEditingEnabled = false
            getArticlesFromAPI(tabBarItemTag: item.tag)
        case 3: getStoredArticles()
            isStoredModeOn = true
            isEditingEnabled = true
            getStoredArticles()
        default: break
        }
    }
}

//MARK: - TableViewDelegate & DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isStoredModeOn {
            return self.storedArticles.count
        } else {
           return self.articles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell else {
            fatalError()
        }
        if isStoredModeOn {
            cell.configureWithStoredArticle(article: storedArticles[indexPath.row])
        } else {
            cell.configureCell(article: articles[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch tabBar.selectedItem?.tag {
        case 0:
            return ContentType.mostEmailed.rawValue
        case 1:
            return ContentType.mostShared.rawValue
        case 2:
            return ContentType.mostViewed.rawValue
        case 3:
            return "Favorites"
        default:
            return ContentType.mostEmailed.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isStoredModeOn {
            let detailVC = DetailViewController(storedArticle: storedArticles[indexPath.row])
            navigationController?.pushViewController(detailVC, animated: false)
        } else {
            let detailVC = DetailViewController(article: articles[indexPath.row])
            navigationController?.pushViewController(detailVC, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditingEnabled
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            StoredDataManager.shared.deleteArticle(at: indexPath.row)
            storedArticles.remove(at: indexPath.row)
            StoredDataManager.shared.storedArticlesArray.remove(at: indexPath.row)
            articlesTableView.reloadData()
        }
    }
}

