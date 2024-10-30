//
//  ModalViewController.swift
//  MyCuisineData
//
//  Created by sokolli on 10/19/24.
//

import UIKit
import WebKit

/// A modal view controller that presents a web page with a close button and loading indicator.

class ModalViewController: BaseViewController {
    /// MARK: - Properties
    var urlString = ""

    /// MARK: - UI Elements
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.isHidden = false
        activityIndicator.color = Constants.mintGreenColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.accessibilityIdentifier = Constants.activityIndicator
        return activityIndicator
    }()

    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.frame)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.accessibilityIdentifier = Constants.webView
        return webView
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.accessibilityIdentifier = Constants.closeButton
        button.setImage(UIImage(systemName: Constants.xmarkIcon), for: .normal)
        button.tintColor = Constants.mintGreenColor
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// MARK: - Initializers
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// MARK: - Lifecycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if webView.canGoBack {
            webView.goBack()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(webView)
        view.addSubview(closeButton)
        view.addSubview(activityIndicator)

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }

        addConstraints()
    }

    /// MARK: - Layout Constraints
    func addConstraints() {
        var customConstraints = [NSLayoutConstraint]()
        customConstraints.append(webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        customConstraints.append(webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        customConstraints.append(webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        customConstraints.append(webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        customConstraints.append(closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16))
        customConstraints.append(closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16))
        customConstraints.append(closeButton.widthAnchor.constraint(equalToConstant: 44))
        customConstraints.append(closeButton.heightAnchor.constraint(equalToConstant: 44))
        NSLayoutConstraint.activate(customConstraints)
    }

    /// MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension ModalViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
