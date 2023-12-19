import UIKit

class QuackCollectionViewCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    private func setupLabel() {
        label = UILabel(frame: CGRect(x: 0, y: 160, width: 300, height: 40))
        label.textAlignment = .center
        contentView.addSubview(label)
    }
    
    func configure(with text: String, imageName: String) {
        label.text = text
        imageView.image = UIImage(named: imageName)
    }
}
