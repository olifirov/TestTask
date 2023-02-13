//
//  StoredArticle+CoreDataProperties.swift
//  
//
//  Created by Дмитрий Олифиров on 09.02.2023.
//
//

import Foundation
import CoreData


extension StoredArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredArticle> {
        return NSFetchRequest<StoredArticle>(entityName: "StoredArticle")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var abstract: String?
    @NSManaged public var url: String?
    @NSManaged public var subsection: String?
    @NSManaged public var section: String?
    @NSManaged public var publishedDate: String?
    @NSManaged public var updatedDate: String?
    @NSManaged public var byline: String?
    @NSManaged public var type: String?
    @NSManaged public var source: String?
    @NSManaged public var adxKeywords: String?
    @NSManaged public var desFacet: String?
    @NSManaged public var orgFacet: String?
    @NSManaged public var perFacet: String?
    @NSManaged public var geoFacet: String?
    @NSManaged public var image: Data?
    @NSManaged public var smallImage: Data?

}
