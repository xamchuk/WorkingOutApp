//
//  InfoViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 07/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController, WKUIDelegate {

    var portraitHeihtAnchor: NSLayoutConstraint?
    var landscapeHeihtAnchor: NSLayoutConstraint?
    var continerView: UIView?
    var webView: WKWebView!
    var item: ItemJson?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Name"
        return label
    }()

    let groupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Group"
        return label
    }()

    let descriotionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "this is long description this is long description this is long description this is long description this is long description this is long description this is long description this is long description this is long description this is long description this is long description"
        return label
    }()

    let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fillProportionally
        stackview.spacing = 8
        return stackview
    }()

    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.downloaded(from: item?.imageName ?? "")
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.fillSuperview()

        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.9
        imageView.addSubview(visualEffectView)
        visualEffectView.fillSuperview()


        navigationController?.navigationBar.prefersLargeTitles = false
        let backButton = UIBarButtonItem()
        backButton.tintColor = .textColor
        navigationController!.navigationBar.topItem!.backBarButtonItem = backButton

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true

        setUpContainerView()
        setupWebView()
        setupStackView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
        imageView.image = nil
    }

    fileprivate func configureWebView(videoString: String) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoString)?enablejsapi=0&rel=0&playsinline=1&autoplay=1") else { return }
        webView.load(URLRequest(url: url))
    }

    fileprivate func setUpContainerView() {
        continerView = UIView()
        continerView?.layer.masksToBounds = true
        view.addSubview(continerView!)
        continerView?.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: CGSize(width: 0, height: 0))
        portraitHeihtAnchor = continerView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        portraitHeihtAnchor?.isActive = true
    }

    fileprivate func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.javaScriptEnabled = true
        webConfiguration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        continerView?.addSubview(webView)
        webView.backgroundColor = .black
        webView.anchor(top: continerView?.topAnchor, leading: continerView?.leadingAnchor, bottom: continerView?.bottomAnchor, trailing: continerView?.trailingAnchor)
        guard let itemInfo = item else { return }
        guard let videoString = itemInfo.videoString else { return }
        navigationItem.title = itemInfo.name
        nameLabel.text = itemInfo.name
        groupLabel.text = itemInfo.group


        configureWebView(videoString: videoString)
    }

    fileprivate func setupStackView() {



        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.anchor(top: continerView?.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        scrollView.contentSize = CGSize(width: 0, height: 1000)
        scrollView.addSubview(stackView)
        //stackView.fillSuperview()
        stackView.anchor(top: scrollView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        [nameLabel, groupLabel, descriotionLabel].forEach { stackView.addArrangedSubview($0) }


//        someView.anchor(top: continerView?.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
//        someView.addSubview(stackView)
      //  stackView.anchor(top: someView.topAnchor, leading: webView.leadingAnchor, bottom: nil, trailing: someView.trailingAnchor, padding: .init(top: 16, left: 8, bottom: 8, right: 8), size: CGSize(width: 0, height: 0))
    }


}

