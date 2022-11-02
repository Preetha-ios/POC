import Foundation

public class PlanetaryAPOD: NSObject, Decodable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool {
        return false
    }
    
    public var date: String
    public var explanation: String
    public var hdurl: String
    public var title: String
    public var url: String
    
    init(date: String, explanation: String, hdurl: String, title: String, url: String) {
        self.date = date
        self.explanation = explanation
        self.hdurl = hdurl
        self.title = title
        self.url = url
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: "date") as! String
        let explanation = aDecoder.decodeObject(forKey: "explanation") as! String
        let hdurl = aDecoder.decodeObject(forKey: "hdurl") as! String
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let url = aDecoder.decodeObject(forKey: "url") as! String
        
        self.init(date: date, explanation: explanation, hdurl: hdurl, title: title, url: url)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(explanation, forKey: "explanation")
        aCoder.encode(hdurl, forKey: "hdurl")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(url, forKey: "url")
    }
}
