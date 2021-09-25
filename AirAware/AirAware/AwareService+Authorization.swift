//
//  AwareService+Login.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/22/21.
//

import Foundation
import UUSwiftNetworking
import WebKit

extension AwareService : WKNavigationDelegate {

	public func needsLogin() -> Bool {
		return self.accessToken.count <= 0
	}

	public func promptForUserLogin(viewController : UIViewController, _ completion : @escaping(Bool)->Void) {

		self.loginCompletion = completion

		let path = AwareService.loginPath + "?state=12345678&response_type=code&client_id=\(self.clientID)&redirect_uri=\(self.redirectURL)"
		let webView = WKWebView()
		webView.translatesAutoresizingMaskIntoConstraints = false
		viewController.view.addSubview(webView)
		webView.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
		webView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
		webView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
		webView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
		webView.navigationDelegate = self
		webView.load(URLRequest(url: URL(string: path)!))
	}

	public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
	{
		if let url = navigationAction.request.url,
		   let queryParameters = url.queryParameters,
		   let code = queryParameters["code"] {
			self.exchangeAuthCode(code) { success in
				if let completion = self.loginCompletion {
					DispatchQueue.main.async {
						webView.removeFromSuperview()
						completion(success)
					}
				}
			}
		}
		decisionHandler(.allow)
	}

	static func needsTokenRefresh(_ response : HTTPURLResponse?) -> Bool {
		if let response = response {
			return response.statusCode >= 403
		}

		return false
	}

	func refreshAuthToken(_ completion: @escaping(Bool)->Void) {

		let code = savedRefreshToken
		let bodyString = "grant_type=refresh_token&refresh_token=\(code)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)"
		let request = UUHttpRequest(url: AwareService.tokenExchangePath)
		request.httpMethod = .post
		request.bodyContentType = "application/x-www-form-urlencoded"
		request.body = bodyString.data(using: .utf8)

		_ = UUHttpSession.executeRequest(request) { response in

			var success = false
			if let dictionary = response.parsedResponse as? [String : Any] {
				if let accessToken = dictionary["access_token"] as? String,
				   let refreshToken = dictionary["refresh_token"] as? String {
					self.accessToken = accessToken
					self.saveTokens(accessToken: accessToken, refreshToken: refreshToken)

					success = true
				}
			}

			completion(success)
		}

	}

	func exchangeAuthCode(_ code : String, _ completion: @escaping (Bool)->Void) {

		let bodyString = "grant_type=authorization_code&code=\(code)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)"
		let request = UUHttpRequest(url: AwareService.tokenExchangePath)
		request.httpMethod = .post
		request.bodyContentType = "application/x-www-form-urlencoded"
		request.body = bodyString.data(using: .utf8)
		_ = UUHttpSession.executeRequest(request) { response in

			var success = false
			if let dictionary = response.parsedResponse as? [String : Any] {
				if let accessToken = dictionary["access_token"] as? String,
				   let refreshToken = dictionary["refresh_token"] as? String {
					self.accessToken = accessToken
					self.saveTokens(accessToken: accessToken, refreshToken: refreshToken)

					success = true
				}
			}

			completion(success)
		}
	}
}

extension URL {
	public var queryParameters: [String: String]? {
		guard
			let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
			let queryItems = components.queryItems else { return nil }
		return queryItems.reduce(into: [String: String]()) { (result, item) in
			result[item.name] = item.value
		}
	}
}
