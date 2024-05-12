//
//  Query+EXT.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 12/5/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        try await getDocumentsWithSnapshot(as: type).exercises
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (exercises: [T], lastDocument: DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        let exercises = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (exercises, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], any Error>, ListenerRegistration) where T: Decodable{
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let items: [T] = documents.compactMap({ try? $0.data(as: T.self) })
            publisher.send(items)
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
    
}
