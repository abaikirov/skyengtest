//
//  TranslateVC.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit
import SnapKit

class TranslateVC: UIViewController {
  private let networkManager: INetworkManager
  private var wordsTable: UITableView!
  
  private var searchTimer: Timer?
  
  private var words: [Word] = [] {
    didSet {
      wordsTable.reloadData()
    }
  }
  
  init(_ networkManager: INetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    fetchWords("Слово")
  }
  
  private func setupViews() {
    view.backgroundColor = .systemBackground
    setupKeyboardListener()
    setupNavigationController()
    setupWordsTable()
  }
  
  private func setupKeyboardListener() {
    let center = NotificationCenter.default
    center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    let userInfo = notification.userInfo
    let frame  = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
    wordsTable.contentInset = contentInset
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    wordsTable.contentInset = UIEdgeInsets.zero
  }
  
  private func setupNavigationController() {
    navigationItem.title = "Translate"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationItem.largeTitleDisplayMode = .never
    navigationController?.navigationBar.backgroundColor = .systemGray6
    
    let search = UISearchController(searchResultsController: nil)
    search.searchResultsUpdater = self
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.placeholder = "Search word translate..."
    navigationItem.searchController = search
    
    definesPresentationContext = true
  }
  
  private func setupWordsTable() {
    wordsTable = UITableView()
    wordsTable.dataSource = self
    wordsTable.delegate = self
    wordsTable.register(WordsTVC.self, forCellReuseIdentifier: WordsTVC.reuseID)
    view.addSubview(wordsTable)
    wordsTable.snp.makeConstraints { (maker) in
      maker.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
    }
  }
  
  private func fetchWords(_ search: String) {
    networkManager.words(search, page: nil, pageSize: nil) { (result) in
      switch result {
      case .success(let words):
        self.words = words
      case .failure(let error):
        print(error)
      }
    }
  }
}

extension TranslateVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    words.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    words[section].meanings.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WordsTVC.reuseID) as? WordsTVC else {
      fatalError()
    }
    
    cell.onBind(words[indexPath.section].meanings[indexPath.item])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let meaningVC = MeaningVC(words[indexPath.section].meanings[indexPath.item], networkManager: networkManager)
    tableView.deselectRow(at: indexPath, animated: true)
    navigationController?.pushViewController(meaningVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    header.backgroundColor = .secondarySystemBackground
    let title = UILabel()
    title.font = UIFont.boldSystemFont(ofSize: 24)
    title.text = words[section].text
    header.addSubview(title)
    title.snp.makeConstraints { (maker) in
      maker.edges.equalToSuperview().inset(Constants.Offset.small)
    }
    
    return header
  }
}

extension TranslateVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let text = searchController.searchBar.text, !text.isEmpty {
      searchTimer?.invalidate()
      searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
        self.fetchWords(text)
      })
    } else {
      words.removeAll()
    }
  }
}
