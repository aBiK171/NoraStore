import UIKit

class ProductsCell: UICollectionViewCell {

    static let productID = "ProductID"
    var onLikeTapped: (() -> Void)?

    private var product: Product?

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.layer.borderWidth = 0.5
        iv.backgroundColor = UIColor(named: "colorWhite")
        iv.layer.borderColor = UIColor.systemGray.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let badgeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "buttonFav")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor(named: "colorBlack")
        btn.translatesAutoresizingMaskIntoConstraints = false

        return btn
    }()
    
    

    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.textColor = UIColor(named: "colorBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let brandLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "colorBg")
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "colorBg")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        imageView.addSubview(badgeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(brandLabel)
        contentView.addSubview(priceLabel)
        imageView.isUserInteractionEnabled = true
        badgeButton.addTarget(self, action: #selector(onLiked), for: .touchUpInside)

        NSLayoutConstraint.activate([
           
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            badgeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            badgeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            badgeButton.widthAnchor.constraint(equalToConstant: 28),
            badgeButton.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            brandLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            priceLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        product = nil
    }


    func configure(with product: Product) {
        self.product = product

        titleLabel.text = product.title
        brandLabel.text = product.description
        priceLabel.text = "$\(product.price)"

        if let url = URL(string: product.thumbnail) {
            imageView.kf.setImage(with: url)
        }

        updateHeart()
    }

    private func updateHeart() {
        guard let product = product else { return }

        if FavoritesManager.shared.isFavorite(product.id) {
            badgeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            badgeButton.tintColor = .systemRed
        } else {
            badgeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            badgeButton.tintColor = UIColor(named: "colorBlack")
        }
    }



    @objc private func onLiked() {
        onLikeTapped?()
    }


}
