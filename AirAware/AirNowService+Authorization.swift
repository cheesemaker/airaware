//
//  AirNowService+Authorization.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/28/21.
//

import Foundation
import UUSwiftNetworking
import WebKit

extension AirNowService : WKNavigationDelegate {

	public func needsLogin() -> Bool {
		return self.accessToken.count <= 0
	}

	public func login(username : String, password : String, _ completion : @escaping(Bool)->Void) {

		let path = AirNowService.loginPath
		let request = UUHttpRequest(url:path, method: .post)
		let body = "username=\(username)&password=\(password)&exec=Login"
		request.bodyContentType = "application/x-www-form-urlencoded"
		request.body = body.data(using: .utf8)

		_ = UUHttpSession.executeRequest(request, { response in

			if let cookies = HTTPCookieStorage.shared.cookies {
				let request = UUHttpRequest(url: AirNowService.webservicesPath)
				request.headerFields = HTTPCookie.requestHeaderFields(with: cookies)

				_ = UUHttpSession.executeRequest(request, { response in
					if let html = response.parsedResponse as? String {
						self.accessToken =  self.extractKey(html)
						
						DispatchQueue.main.async {
							completion(self.accessToken.count > 0)
						}
					}
				})
			}
		})
	}

	public func promptForUserLogin(viewController : UIViewController, _ completion : @escaping(Bool)->Void) {

		self.loginCompletion = completion

		let path = AirNowService.loginPath
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
		if let url = navigationAction.request.url
		{
			if url.path == "/about" {
				decisionHandler(.cancel)

				DispatchQueue.main.async {
					let request = URLRequest(url: URL(string: AirNowService.webservicesPath)!)
					webView.load(request)
					UIView.animate(withDuration: 0.35) {
						webView.alpha = 0.0001
					}
				}

				return
			}
		}

		decisionHandler(.allow)

	}

	public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

		if webView.url?.path == "/webservices" {
			webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { result, error in

				if let html = result as? String {
					self.accessToken =  self.extractKey(html)

					DispatchQueue.main.async {
						if let completion = self.loginCompletion {
							completion(true)
						}

						webView.removeFromSuperview()
					}
				}
			}
		}
	}

	private func extractKey(_ html : String) -> String {
		var string = html as NSString
		var range = string.range(of: "Your API Key:")
		string = string.substring(from: range.location + range.length + 1) as NSString
		range = string.range(of: "</span>")
		return string.substring(to: range.location)
	}

}
