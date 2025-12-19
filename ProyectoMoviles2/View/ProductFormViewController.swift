//
//  ProductFormViewController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 17/12/25.
//

import UIKit

protocol ProductFormDelegate: AnyObject {
    func didUpdateProducts()
}

class ProductFormViewController: UIViewController {

    // MARK: - Propiedades
    private let vm: ProductViewModel
    private var productToEdit: ProductEntity?

    weak var delegate: ProductFormDelegate?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let nameTextField = UITextField()
    private let priceTextField = UITextField()
    private let stockTextField = UITextField()
    private let productImageView = UIImageView()
    private let selectImageButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private let categoryTextField = UITextField()

    private var selectedImage: UIImage?

    // MARK: - Init
    init(vm: ProductViewModel, productToEdit: ProductEntity? = nil) {
        self.vm = vm
        self.productToEdit = productToEdit
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = productToEdit == nil ? "New Product" : "Edit Product"

        setupScrollView()
        setupUI()
        setupActions()
        populateFieldsIfEditing()
    }

    // MARK: - Setup UI
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupUI() {
        let padding: CGFloat = 16

        // Name TextField
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        contentView.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        // Price TextField
        priceTextField.placeholder = "Price"
        priceTextField.borderStyle = .roundedRect
        priceTextField.keyboardType = .decimalPad
        contentView.addSubview(priceTextField)
        priceTextField.translatesAutoresizingMaskIntoConstraints = false

        // Stock TextField
        stockTextField.placeholder = "Stock"
        stockTextField.borderStyle = .roundedRect
        stockTextField.keyboardType = .numberPad
        contentView.addSubview(stockTextField)
        stockTextField.translatesAutoresizingMaskIntoConstraints = false

        // Product Image View
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        productImageView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false

        // Select Image Button
        selectImageButton.setTitle("Select Image", for: .normal)
        contentView.addSubview(selectImageButton)
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false

        // Save Button
        saveButton.setTitle(productToEdit == nil ? "Save" : "Update", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        contentView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Category TextField
        categoryTextField.placeholder = "Category"
        categoryTextField.borderStyle = .roundedRect
        contentView.addSubview(categoryTextField)
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            priceTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: padding),
            priceTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            priceTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            stockTextField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: padding),
            stockTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stockTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            categoryTextField.topAnchor.constraint(equalTo: stockTextField.bottomAnchor, constant: padding),
            categoryTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            categoryTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
                
            productImageView.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: padding),
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 120),
            productImageView.heightAnchor.constraint(equalToConstant: 120),

            selectImageButton.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            selectImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            saveButton.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: padding),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }

    private func setupActions() {
        selectImageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    private func populateFieldsIfEditing() {
        guard let product = productToEdit else { return }
        nameTextField.text = product.name
        priceTextField.text = String(product.price)
        categoryTextField.text = product.category
        stockTextField.text = String(product.stock)
        if let data = product.image, let uiImage = UIImage(data: data) {
            productImageView.image = uiImage
            selectedImage = uiImage
        }
    }

    // MARK: - Actions
    @objc private func selectImageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let priceText = priceTextField.text, let price = Double(priceText),
              let stockText = stockTextField.text, let stock = Int16(stockText),
              let category = categoryTextField.text, !category.isEmpty,
              let image = selectedImage else {
            showAlert(message: "Please fill all fields and select an image.")
            return
        }

        if let product = productToEdit {
            vm.updateProduct(product: product, name: name, image: image, price: price, stock: stock, category: category)
        } else {
            vm.addProduct(name: name, image: image, price: price, stock: stock, category: category)
        }

        delegate?.didUpdateProducts()
        dismiss(animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProductFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            productImageView.image = image
            selectedImage = image
        }
    }
}
