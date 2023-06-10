import Foundation
import Combine

protocol LoadFileInterface {
    func loadCodable<T>(of type: T.Type) -> AnyPublisher<T, Error> where T: Decodable
}

struct LoadFile: LoadFileInterface {
    private let url: URL
    init(url: URL) {
        self.url = url
    }
    
    func loadCodable<T>(of type: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        return Future<T, Error> { promise in
            do {
                let contents = try String(contentsOf: url)
                guard let jsonData = contents.data(using: .utf8) else {
                    return promise(.failure(LoadingFileError.failedParsing))
                }
                
                guard let result = try JSONDecoder().decode(T?.self, from: jsonData) else {
                    return promise(.failure(LoadingFileError.failedParsing))
                }
                promise(.success(result))
                
            } catch {
                print(error)
                promise(.failure(error))
                
            }
        }.eraseToAnyPublisher()
    }
    
}

struct LoadLocalFile: LoadFileInterface {
    private var fileName: String
    private var fileType: String
    
    init(fileName: String, fileType: String) {
        self.fileName = fileName
        self.fileType = fileType
    }
    
    func loadCodable<T>(of type: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        if let pathString = Bundle.main.path(forResource: fileName, ofType: fileType) {
            let url = URL(fileURLWithPath: pathString)
            do {
                let data = try Data(contentsOf: url)
                let result = try JSONDecoder().decode(T.self, from: data)
                return Just(result).setFailureType(to: Error.self).eraseToAnyPublisher()

            } catch {
                print("error: \(error)")
                return Fail(error: LoadingFileError.failedParsing).eraseToAnyPublisher()
            }
        }
        return Fail(error: LoadingFileError.failedReadingContent).eraseToAnyPublisher()
    }
    
    
}


enum LoadingFileError: Error {
    case failedParsing
    case failedReadingContent
}
