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
    private let categoryLabel = UILabel()
    private let categoryPicker = UIPickerView()
    private var selectedCategory: String?
    
    private let categories = ["Tazas", "Ropa", "Luces", "Juguetes"]

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
        
        // Fondo navideño suave
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Título navideño
        title = productToEdit == nil ? "🎁 New Product" : "🎄 Edit Product"
        
        // Botón Back personalizado
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "⛄ Back",
            style: .plain,
            target: nil,
            action: nil
        )

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

        // Sombra y borde navideño para contentView
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.systemRed.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4

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

        // Campos de texto con borde rojo navideño
        [nameTextField, priceTextField, stockTextField].forEach { tf in
            tf.borderStyle = .roundedRect
            tf.layer.borderColor = UIColor.systemRed.cgColor
            tf.layer.borderWidth = 1
            tf.layer.cornerRadius = 8
            contentView.addSubview(tf)
            tf.translatesAutoresizingMaskIntoConstraints = false
        }

        nameTextField.placeholder = "Name"
        priceTextField.placeholder = "Price"
        priceTextField.keyboardType = .decimalPad
        stockTextField.placeholder = "Stock"
        stockTextField.keyboardType = .numberPad

        // Imagen de producto
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 60
        productImageView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        productImageView.layer.borderWidth = 1
        productImageView.layer.borderColor = UIColor.systemRed.cgColor
        contentView.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false

        // Select Image Button
        selectImageButton.setTitle("Select Image", for: .normal)
        selectImageButton.setTitleColor(.systemRed, for: .normal)
        selectImageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(selectImageButton)
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false

        // Save Button
        saveButton.setTitle(productToEdit == nil ? "Save" : "Update", for: .normal)
        saveButton.backgroundColor = .systemRed
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.layer.shadowColor = UIColor.systemGreen.cgColor
        saveButton.layer.shadowOpacity = 0.4
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        saveButton.layer.shadowRadius = 5
        contentView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Category Label
        categoryLabel.text = "Select Category"
        categoryLabel.textAlignment = .center
        categoryLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        categoryLabel.textColor = .systemRed
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        categoryLabel.layer.cornerRadius = 8
        categoryLabel.clipsToBounds = true
        contentView.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false

        // Category Picker
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.backgroundColor = UIColor.systemRed.withAlphaComponent(0.05)
        contentView.addSubview(categoryPicker)
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false

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
            
            categoryLabel.topAnchor.constraint(equalTo: stockTextField.bottomAnchor, constant: padding),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            categoryLabel.heightAnchor.constraint(equalToConstant: 44),

            categoryPicker.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            categoryPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryPicker.heightAnchor.constraint(equalToConstant: 120),

            productImageView.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: padding),
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
        stockTextField.text = String(product.stock)
        if let category = product.category,
           let index = categories.firstIndex(of: category) {
            categoryPicker.selectRow(index, inComponent: 0, animated: false)
            categoryLabel.text = category
            selectedCategory = category
        }
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
              let category = selectedCategory,
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
        navigationController?.popViewController(animated: true)
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

// MARK: - UIPickerViewDelegate & DataSource
extension ProductFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        categoryLabel.text = selectedCategory
    }
}
