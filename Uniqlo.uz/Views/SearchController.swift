import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    private let headerView = UIView()
    private let logoImageView = UIImageView()
    private let searchButton = UIButton()
    private let backButton = UIButton()
    private let searchTextField = UITextField()
    
    private var searchWidthConstraint: NSLayoutConstraint!
    
    private let searchTable = UITableView()
    private var products: [Product] = []
    private var searchTask: Task<Void, Never>?
    
    let productService = ProductService(network: NetworkService())
    
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "colorWhite")
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupHeader()
        setupTable()
    }
    private func setupHeader() {
        
        headerView.backgroundColor = UIColor(named: "colorBg")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(logoImageView)
        
        // SEARCH BUTTON
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = UIColor(named: "colorWhite")
        searchButton.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        searchButton.layer.cornerRadius = 20
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        headerView.addSubview(searchButton)
        
        // BACK BUTTON
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.alpha = 0
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(closeSearch), for: .touchUpInside)
        headerView.addSubview(backButton)
        
        // TEXTFIELD
        searchTextField.placeholder = "Search"
        searchTextField.textColor = UIColor(named: "colorWhite")
        searchTextField.tintColor = UIColor(named: "colorWhite")
        searchTextField.backgroundColor = UIColor(named: "colorWhite")?.withAlphaComponent(0.15)
        searchTextField.layer.cornerRadius = 12
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.alpha = 0
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 40))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor(named: "colorWhite")?.withAlphaComponent(0.8) ?? .white
            ]
        )

        headerView.addSubview(searchTextField)
        
        searchTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        // Constraints
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            logoImageView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.4),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            searchButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            searchTextField.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        searchWidthConstraint = searchTextField.widthAnchor.constraint(equalToConstant: 0)
        searchWidthConstraint.isActive = true
    }
    
    private func setupTable() {
        searchTable.dataSource = self
        searchTable.delegate = self
        searchTable.register(SearchCell.self, forCellReuseIdentifier: SearchCell.searchID)
        searchTable.separatorColor = UIColor(named: "colorBg")
        searchTable.backgroundColor = UIColor(named: "colorWhite")
        searchTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTable)
        
        NSLayoutConstraint.activate([
            searchTable.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            searchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTable.dequeueReusableCell(withIdentifier: SearchCell.searchID) as! SearchCell
        cell.configure(with: products[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        let detail = ProductDetailController(product: product)
        self.navigationController?.pushViewController(detail, animated: true)
        if let tab = self.tabBarController as? CustomTabBarController {
            tab.setTabBarHidden(true)
        }
    }
    
    @objc private func openSearch() {
        guard !isSearching else { return }
        isSearching = true
        
        logoImageView.alpha = 0
        searchButton.alpha = 0
        
        backButton.alpha = 1
        searchTextField.alpha = 1
        
        searchWidthConstraint.constant = view.frame.width - 100
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        searchTextField.becomeFirstResponder()
    }

    @objc private func closeSearch() {
        isSearching = false
        
        searchTextField.resignFirstResponder()
        searchTextField.text = ""
        
        searchWidthConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.logoImageView.alpha = 1
            self.searchButton.alpha = 1
            self.backButton.alpha = 0
            self.searchTextField.alpha = 0
        }
    }
    
    
    @objc private func textChanged() {
        guard let text = searchTextField.text,
              !text.isEmpty else {
            products.removeAll()
            searchTable.reloadData()
            return
        }
        
        searchTask?.cancel()
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000)
            let result = try? await productService.searchProducts(text)
            await MainActor.run {
                self.products = result ?? []
                self.searchTable.reloadData()
            }
        }
    }

}
