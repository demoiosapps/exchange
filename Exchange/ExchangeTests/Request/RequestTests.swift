//
// RequestTests.swift
//
// Created by R on 20.09.2019.
// Copyright © 2019 R. All rights reserved.
//
// simple tests, can add additional tests for every param
//

import XCTest

final class RequestTests: XCTestCase {
    
    override func setUp() {
        Request.session = URLSessionMock()
    }
    
    override func tearDown() {
        Request.session = nil
    }
    
    func testGet() {
        let content = "Test".data(using: .utf8)
        (Request.session as! URLSessionMock).data = content
        Request.get("http://apple.com") { response in
            switch response {
            case .success(let data):
                if let data = data as? Data {
                    XCTAssertEqual(data, content)
                } else {
                    XCTFail()
                }
            case .error(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testPost() {
        let content = "Test".data(using: .utf8)
        (Request.session as! URLSessionMock).data = content
        Request.post("http://apple.com") { response in
            switch response {
            case .success(let data):
                if let data = data as? Data {
                    XCTAssertEqual(data, content)
                } else {
                    XCTFail()
                }
            case .error(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testDelete() {
        let content = "Test".data(using: .utf8)
        (Request.session as! URLSessionMock).data = content
        Request.delete("http://apple.com") { response in
            switch response {
            case .success(let data):
                if let data = data as? Data {
                    XCTAssertEqual(data, content)
                } else {
                    XCTFail()
                }
            case .error(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testPut() {
        let content = "Test".data(using: .utf8)
        (Request.session as! URLSessionMock).data = content
        Request.put("http://apple.com") { response in
            switch response {
            case .success(let data):
                if let data = data as? Data {
                    XCTAssertEqual(data, content)
                } else {
                    XCTFail()
                }
            case .error(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testPatch() {
        let content = "Test".data(using: .utf8)
        (Request.session as! URLSessionMock).data = content
        Request.patch("http://apple.com") { response in
            switch response {
            case .success(let data):
                if let data = data as? Data {
                    XCTAssertEqual(data, content)
                } else {
                    XCTFail()
                }
            case .error(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testRequest() {
        let content = "Test".data(using: .utf8)
        (Request.session as! URLSessionMock).data = content
        Request.request("http://apple.com") { response in
            switch response {
            case .success(let data):
                if let data = data as? Data {
                    XCTAssertEqual(data, content)
                } else {
                    XCTFail()
                }
            case .error(let error):
                XCTAssertNil(error)
            }
        }
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    
    var data: Data?
    var error: Error?
    var response: URLResponse?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock { [weak self] in
            if self?.response == nil,
                let url = request.url {
                self?.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            }
            completionHandler(self?.data, self?.response, self?.error)
        }
    }
}
