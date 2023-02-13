//
//  StoredDataManager.swift
//  TestTask
//
//  Created by Дмитрий Олифиров on 09.02.2023.
//

import Foundation
import CoreData

class StoredDataManager {

    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
    var storedArticlesArray: [StoredArticle] = []
    
    static var shared = StoredDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "TestTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                    
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveArticle(article: Article) {
        
        let storedArticle = StoredArticle(context: viewContext)
        
        DispatchQueue.global().async {
            var imageData: Data? = nil
            var smallImageData: Data? = nil
            
            if !article.media.isEmpty,
               let imageUrl = URL(string: article.media[0].mediaMetadata[2].url),
               let dataFromURL = try? Data(contentsOf: imageUrl) {
                imageData = dataFromURL
            }
            
            if !article.media.isEmpty,
               let imageUrl = URL(string: article.media[0].mediaMetadata[0].url),
               let dataFromURL = try? Data(contentsOf: imageUrl) {
                smallImageData = dataFromURL
            }
            
            storedArticle.id = Int64(article.id)
            storedArticle.title = article.title
            storedArticle.abstract = article.abstract
            storedArticle.url = article.url
            storedArticle.subsection = article.subsection
            storedArticle.section = article.section
            storedArticle.publishedDate = article.publishedDate
            storedArticle.updatedDate = article.updated
            storedArticle.byline = article.byline
            storedArticle.type = article.type.rawValue
            storedArticle.source = article.source.rawValue
            storedArticle.adxKeywords = article.adxKeywords
            storedArticle.desFacet = self.getStringFromArray(article.desFacet)
            storedArticle.orgFacet = self.getStringFromArray(article.orgFacet)
            storedArticle.perFacet = self.getStringFromArray(article.perFacet)
            storedArticle.geoFacet = self.getStringFromArray(article.geoFacet)
            storedArticle.image = imageData
            storedArticle.smallImage = smallImageData
            
            self.storedArticlesArray.append(storedArticle)
            self.saveContext()
        }
    }
    
    func loadArticles() -> [StoredArticle]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredArticle")
        guard let storedArticles = try? viewContext.fetch(fetchRequest) as? [StoredArticle]
        else { return [] }
        return storedArticles
    }
    
    func deleteArticle(at index: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredArticle")
        
        if let articles = try? viewContext.fetch(fetchRequest) as? [StoredArticle], !articles.isEmpty {
            let article = articles[index]
            viewContext.delete(article)
            try? viewContext.save()
        }
    }
    
    
    private func getStringFromArray(_ array: [String]) -> String {
        if array.isEmpty {
            return "Empty"
        } else {
            return array.joined(separator: ", ")
        }
    }
    
    func isAllreadyContains(article: Article) -> Bool {
        for storedArticle in storedArticlesArray {
            if storedArticle.id == article.id {
                return true
            }
        }
        return false
    }
}
