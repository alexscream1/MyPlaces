//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Alexey Onoprienko on 04.03.2021.
//

import RealmSwift


class PlaceModel: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var country: String?
    @objc dynamic var city: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    
    
    convenience init(name: String, country: String?, city: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.country = country
        self.city = city
        self.imageData = imageData
    }
}
