//
//  PayRequest.swift
//  Pikassa
//
//  Created by pikassa.io on 29.06.2020.
//

import Foundation


public struct PayResponse: Decodable {
    public let uuid: String
    public let requestId: String
    public let redirect: Redirect?

    public struct Redirect: Decodable {
        public let url: String
        public let method: String
        public let params: [[String: String]]
    }
}


internal class PayRequest: Request<PayResponse> {
    let encodedBody: Data
    let invoiceId: String

    init(
        encodedBody: Data,
        invoiceId: String) {
        self.encodedBody = encodedBody
        self.invoiceId = invoiceId
        
        super.init()
        
        self.method = .put
    }

    override func path() -> String {
        return "merchant-api/api/v2/invoices/\(self.invoiceId)/pay"
    }

    override func headers() -> [AnyHashable : Any]? {
        return [
            "x-api-key": Pikassa.apiKey!,
            "content-Type": "application/json; charset=utf-8"
        ]
    }

    override func body() -> Data? {
        return self.encodedBody
    }

    struct Body<T: Codable>: Codable {
        let requestId: String
        let paymentMethod: String
        let details: T
    }
}
