import Foundation
import Combine

protocol CountriesLoaderInterface {
    func loadCountries() -> AnyPublisher<CountriesList, Error>
}

struct CountriesLoader: CountriesLoaderInterface {
    
    private let fileName: String
    private let fileType: String
    private let jsonFile: LoadLocalFile
    init(fileName: String, fileType: String) {
        self.fileName = fileName
        self.fileType = fileType
        self.jsonFile = LoadLocalFile(fileName: fileName, fileType: fileType) // LoadFile(url: url)
    }
    
    func loadCountries() -> AnyPublisher<CountriesList, Error> {
        jsonFile.loadCodable(of: CountriesList.self)
    }
    
}
