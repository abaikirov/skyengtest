//
//  TranslateVC.swift
//  SkyEngTest
//
//  Created by Abai Abakirov on 6/12/20.
//  Copyright © 2020 Abaikirov. All rights reserved.
//

import UIKit
import SnapKit

protocol ITransalteVC: class {
  func updateWords()
  func showEmpty()
  func hideEmpty()
  func showError(_ message: String)
  func showLoading()
  func hideLoading()
  func showStartView()
}

class TranslateVC: BaseVC {
  private let viewModel: ITranslateVM
  private var wordsTable: UITableView!
  private var emptyView: EmptyView?
  private var search: UISearchController!
  
  private var keyboardHeight: CGFloat = 0
  
  init(_ viewModel: ITranslateVM) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  private func setupViews() {
    view.backgroundColor = .systemBackground
    setupKeyboardListener()
    setupNavigationController()
    setupWordsTable()
    showStartView()
  }
  
  private func setupKeyboardListener() {
    let center = NotificationCenter.default
    center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    let userInfo = notification.userInfo
    let frame  = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
    keyboardHeight = frame.height
    let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
    wordsTable.contentInset = contentInset
    UIView.animate(withDuration: 0.3) {
      self.emptyView?.snp.updateConstraints({ (maker) in
        maker.bottom.equalTo(self.wordsTable.snp.bottom).offset(-self.keyboardHeight + self.view.safeAreaInsets.bottom)
      })
      self.emptyView?.superview?.layoutIfNeeded()
    }
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    wordsTable.contentInset = UIEdgeInsets.zero
    UIView.animate(withDuration: 0.3) {
      self.emptyView?.snp.updateConstraints({ (maker) in
        maker.bottom.equalTo(self.wordsTable.snp.bottom).offset(0)
      })
      self.emptyView?.superview?.layoutIfNeeded()
    }
  }
  
  private func setupNavigationController() {
    navigationItem.title = "Translate"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationItem.largeTitleDisplayMode = .never
    navigationController?.navigationBar.backgroundColor = .systemGray6
    
    search = UISearchController(searchResultsController: nil)
    search.searchResultsUpdater = self
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.placeholder = "Search for translates..."
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
  
  private func addEmptyView(_ text: String) {
    if emptyView == nil {
      emptyView = EmptyView()
      view.addSubview(emptyView!)
      emptyView!.snp.makeConstraints { (maker) in
        maker.top.equalTo(wordsTable.snp.top)
        maker.leading.equalTo(wordsTable.snp.leading)
        maker.trailing.equalTo(wordsTable.snp.trailing)
        maker.bottom.equalTo(wordsTable.snp.bottom).offset(-keyboardHeight + self.view.safeAreaInsets.bottom)
      }
    }
    emptyView?.text = text
  }
}

extension TranslateVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.sectionsCount
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.itemsCount(for: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WordsTVC.reuseID) as? WordsTVC else {
      fatalError()
    }
    cell.onBind(viewModel.meaning(for: indexPath.section, item: indexPath.item))
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 72
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let meaningVC = MeaningVC.instance(viewModel.meaning(for: indexPath.section, item: indexPath.item))
    tableView.deselectRow(at: indexPath, animated: true)
    navigationController?.pushViewController(meaningVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    header.backgroundColor = .secondarySystemBackground
    let title = UILabel()
    title.font = UIFont.boldSystemFont(ofSize: 24)
    title.text = viewModel.title(for: section)
    header.addSubview(title)
    title.snp.makeConstraints { (maker) in
      maker.edges.equalToSuperview().inset(Constants.Offset.small)
    }
    return header
  }
}

extension TranslateVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    viewModel.search(searchController.searchBar.text)
  }
}

extension TranslateVC: ITransalteVC {
  func updateWords() {
    wordsTable.reloadData()
  }
  
  func showEmpty() {
    addEmptyView("Nothing found")
  }
  
  func hideEmpty() {
    emptyView?.removeFromSuperview()
    emptyView = nil
  }
  
  func showLoading() {
    search.searchBar.isLoading = true
  }
  
  func hideLoading() {
    search.searchBar.isLoading = false
  }
  
  func showError(_ message: String) {
    showErrorAlert(message)
  }
  
  func showStartView() {
    addEmptyView("Search for translates")
  }
}

extension TranslateVC {
  static func instance() -> TranslateVC {
    let vm = TranslateVM(NetworkManager())
    let vc = TranslateVC(vm)
    vm.translateVC = vc
    return vc
  }
}
