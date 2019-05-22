//
//  REST.swift
//  Carangas
//
//  Created by Mauro Augusto Diniz on 20/05/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case save
    case update
    case delete
    
}

class REST {
    
    
    // configurando a sessão
    private static let basePath = "https://carangas.herokuapp.com/cars"
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    // criando a sessão
    private static let session = URLSession(configuration: configuration)
    
    // criando o GET
    // loadCars é um metodo de classe. São usados para permitir o acesso sem eu precisar instanciar a classe REST
    // criando Closures de parametro para que eu possa acessar o array [Car] em outras outras classes e para que eu possa tratar possiveis erros
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        // criando um objeto URL baseada na string dentro da variavel basePath
        guard let url = URL(string: basePath) else {
            onError(.url)
            return}
        
        // criando uma tarefa que vai executar a requisição.
        // quando o datatask é chamado, é criada uma tarefa, que nesse caso foi criada usando somente a URL. o datatask não executa a tarefa, apenas cria!
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // o erro aqui é do lado do aplicativo e não do servidor, nesse momento a requisição ainda nem foi feita.
            if error == nil {
                // tratando response como HTTPURLResponse para ter mais informações do que eu teria se tratasse como o padrão URLResponse
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return}
                // statuscode 200 significa que a solicitação teve alguma resposta do servidor
                if response.statusCode == 200 {
                    //desembrulhando o data retornado do servidor
                    guard let data = data else {return}
                    
                    do{
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        
                        onComplete(cars)
                    } catch {
                        print(error.localizedDescription)
                        onError(.invalidJSON)
                    }
                    
                } else {
                    print("Algum status inválido pelo servidor!")
                    onError(.responseStatusCode(code: response.statusCode))
                }
            } else {
                onError(.taskError(error: error!))
            }
            }
        // o metodo resume() que executa a tarefa criada acima, mandando a solicitação para o servidor
        dataTask.resume()
    }
    
    // criando o POST
    class func saveCar(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .save, onComplete: onComplete)
    }
    
    // criando o UPDATE
    class func update(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .update, onComplete: onComplete)
    }
    
    // criando o DELETE
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete)
    }
    
    private class func applyOperation(car: Car, operation: RESTOperation, onComplete: @escaping (Bool) -> Void) {
        // criando um objeto URL baseada na string dentro da variavel basePath
        let urlString = basePath+"/"+(car._id ?? "")
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return}
        
        var request = URLRequest(url: url)
        
        var httpMethod: String = ""
        switch operation {
        case .save:
            httpMethod = "POST"
        case .update:
            httpMethod = "PUT"
        case .delete:
            httpMethod = "DELETE"
        }
        
        request.httpMethod = httpMethod
        do {
            let json = try JSONEncoder().encode(car)
            request.httpBody = json
        } catch {
            print(error.localizedDescription)
            onComplete(false)
        }
        
        
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                // fazendo 3 verificações em um unico statement
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return}
                
                onComplete(true)
            } else{
                onComplete(false)
            }
        }
        dataTask.resume()
    }
}
