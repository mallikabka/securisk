package com.insure.rfq.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Stream;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.insure.rfq.dto.AddProductClientDto;
import com.insure.rfq.dto.GetAllProductsByClientListIdDto;
import com.insure.rfq.dto.GetProductDropdownDto;
import com.insure.rfq.dto.ProductChildDto;
import com.insure.rfq.dto.ProductCreateDto;
import com.insure.rfq.dto.ProductDto;
import com.insure.rfq.dto.ProductIntermediaryDto;
import com.insure.rfq.entity.ClientList;
import com.insure.rfq.entity.InsureList;
import com.insure.rfq.entity.Product;
import com.insure.rfq.entity.ProductCategory;
import com.insure.rfq.entity.Tpa;
import com.insure.rfq.exception.InvalidClientList;
import com.insure.rfq.exception.InvalidProduct;
import com.insure.rfq.exception.InvalidUser;
import com.insure.rfq.repository.ClientListRepository;
import com.insure.rfq.repository.InsureListRepository;
import com.insure.rfq.repository.ProductCategoryRepository;
import com.insure.rfq.repository.ProductRepository;
import com.insure.rfq.repository.TpaRepository;
import com.insure.rfq.service.ProductService;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ProductServiceImpl implements ProductService {

	@Autowired
	private ProductRepository prodRepository;
	@Autowired
	private ProductCategoryRepository prodCategoryRepository;
	@Autowired
	private ClientListRepository clientListRepository;
	@Autowired
	private ModelMapper modelMapper;
	@Autowired
	private InsureListRepository insureListRepository;
	@Autowired
	private TpaRepository tpaRepository;

	private final ObjectMapper objectMapper = new ObjectMapper();

	@Override
	public ProductChildDto findProducts(Long productId) {
		ProductChildDto productChildDto = new ProductChildDto();
		Optional<Product> findProductNamesByCategory = prodRepository.findByProductId(productId);
		if (findProductNamesByCategory.isPresent()) {
			Product product = findProductNamesByCategory.get();
			productChildDto.setProductId(product.getProductId());
			productChildDto.setProductName(product.getProductName());
		}
		return productChildDto;
	}

	@Override
	public List<ProductChildDto> getProductsByCategory(Long productcategoryId) {
		List<Map<String, Object>> findProductNamesByCategory = prodRepository
				.findProductNamesByCategory(productcategoryId);
		List<ProductChildDto> products = new ArrayList<>();
		for (Map<String, Object> result : findProductNamesByCategory) {
			ProductChildDto dto = objectMapper.convertValue(result, ProductChildDto.class);
			products.add(dto);
		}
		return products;
	}

	@Override
	public ProductCreateDto addProduct(ProductCreateDto productDto) {
		log.info("ProductCategory From AddProduct ", productDto.getProductcategoryId());
		Optional<ProductCategory> prodcategory = prodCategoryRepository
				.findById(Long.parseLong(productDto.getProductcategoryId()));
		Product product = null;
		if (productDto != null && prodcategory.isPresent()) {
			product = new Product();
			product.setCreatedDate(new Date());
			product.setProductcategory(prodcategory.get());
			product.setProductName(productDto.getProductName());
			product.setStatus("ACTIVE");
			prodRepository.save(product);
		} else {
			System.out.println("No Category");
		}
		return productDto;
	}

	@Override
	public AddProductClientDto createProduct(AddProductClientDto productDto, Long clientListId) {
		log.info("{}", productDto.toString());
		if (productDto != null) {
			ClientList clientList = clientListRepository.findById(clientListId)
					.orElseThrow(() -> new InvalidClientList("ClientList Id is not Present"));
			log.info("ClientList From Create ClientList Product", clientList);

			Product productEntity = prodRepository.findById(Long.parseLong(productDto.getProductId()))
					.orElseThrow(() -> new InvalidProduct("Product Not Found"));
			log.info("Product From Create ClientList Product", productEntity);

			// Handle optional fields and set them to null in the response if not provided
			if (productDto.getPolicyType() != null) {
				clientList.setPolicyType(productDto.getPolicyType());
			} else {
				productDto.setPolicyType(null);
			}

			if (productDto.getTpaId() != null) {
				Optional<Tpa> tpa = tpaRepository.findById(Long.parseLong(productDto.getTpaId()));
				log.info("Tpa From Create ClientList Product", tpa);
				clientList.setTpaId(tpa.isPresent() ? tpa.get() : null);
			} else {
				productDto.setTpaId(null);
			}

			if (productDto.getInsurerCompanyId() != null) {
				Optional<InsureList> insurer = insureListRepository.findById(productDto.getInsurerCompanyId());
				log.info("Insurers From Create ClientList Product", insurer);
				clientList.setInsureCompanyId(insurer.get());
			} else {
				productDto.setInsurerCompanyId(null);
			}

			// Add the Product to the ClientList
			clientList.getProduct().add(productEntity);

			// Add the ClientList to the Product
			productEntity.getClientList().add(clientList);

			// Save only the ClientList entity
			clientListRepository.save(clientList);

			// Set additional fields in your DTO based on the relationships
			productDto.setInsurerCompanyId(clientList.getInsureCompanyId().getInsurerName());
			productDto.setProductId(prodRepository.findById(productEntity.getProductId()).get().getProductName());

			// Return null in the response for fields that were not provided
			if (productDto.getTpaId() != null) {
				productDto.setTpaId(clientList.getTpaId() != null ? clientList.getTpaId().getTpaName() : null);
			} else {
				productDto.setTpaId(null);
			}

			return productDto;
		}

		return null; // Return null if the request is null
	}

	@Override
	public List<ProductDto> getAllProducts(Long id) {
		return prodRepository.findAll().stream().filter(user -> {
			List<ClientList> clientList = user.getClientList();
			return clientList != null && clientList.stream().anyMatch(client -> client.getCid() == id)
					&& user.getStatus().equalsIgnoreCase("ACTIVE");
		}).map(users -> modelMapper.map(users, ProductDto.class)).toList();
	}

	@Override
	public ProductIntermediaryDto updatePoductById(Long productId, ProductIntermediaryDto productDto) {
		Product product = prodRepository.findById(productId).get();
		product.setProductName(productDto.getProductName());
		product.setUpdatedDate(new Date());
		log.info("Product From Update Product ",
				prodCategoryRepository.findByCategoryName(productDto.getCategoryName()).toString());
		product.setProductcategory(prodCategoryRepository.findByCategoryName(productDto.getCategoryName()));
		prodRepository.save(product);
		return productDto;
	}

	@Override
	public String deletePoductById(Long productId) {
		Product product = prodRepository.findById(productId).orElseThrow(() -> new InvalidUser("user Not Found"));
		product.setStatus("INACTIVE");
		prodRepository.save(product);
		return "Deleted Successfully";
	}

	@Override
	public List<GetProductDropdownDto> getAllProductsWithId() {
		List<Product> products = prodRepository.findAll();
		List<GetProductDropdownDto> productsWithId = new ArrayList<>();
		for (Product getProductWithIdDto : products) {
			if (getProductWithIdDto.getStatus().equalsIgnoreCase("ACTIVE")) {
				GetProductDropdownDto productWithIdDto = new GetProductDropdownDto();
				productWithIdDto.setProductId(getProductWithIdDto.getProductId());
				productWithIdDto.setProductName(getProductWithIdDto.getProductName());
				productsWithId.add(productWithIdDto);
			}
		}
		return productsWithId;
	}

	@Override
	public List<GetAllProductsByClientListIdDto> getAllProductsByClientListId(Long clientListId) {
		return prodRepository.findAll().stream().filter(products -> products.getClientList() != null
				&& products.getClientList().stream().anyMatch(id -> id.getCid() == clientListId)
				&& products.getClientList().stream().anyMatch(status -> status.getStatus().equalsIgnoreCase("ACTIVE"))
				&& products.getStatus().equalsIgnoreCase("ACTIVE")).map(listOfProducts -> {
			GetAllProductsByClientListIdDto allProductsByClientListIdDto = new GetAllProductsByClientListIdDto();
			allProductsByClientListIdDto.setProductId(String.valueOf(listOfProducts.getProductId()));
			// Check if insurerCompanyId is null
			if (listOfProducts.getInsureCompanyId() != null) {
				allProductsByClientListIdDto
						.setInsurerCompanyId(listOfProducts.getInsureCompanyId().getInsurerName());
			} else {
				allProductsByClientListIdDto.setInsurerCompanyId(null);
			}

			// Check if policyType is null
			if (listOfProducts.getPolicyType() != null) {
				allProductsByClientListIdDto.setPolicyType(listOfProducts.getPolicyType());
			} else {
				allProductsByClientListIdDto.setPolicyType(null);
			}

			// Check if productId is null
			if (listOfProducts.getProductName() != null) {
				allProductsByClientListIdDto.setProductName(listOfProducts.getProductName());
			} else {
				allProductsByClientListIdDto.setProductName(null);
			}

			// Check if tpaId is null
			if (listOfProducts.getTpaId() != null) {
				allProductsByClientListIdDto.setTpaId(listOfProducts.getTpaId().getTpaName());
			} else {
				allProductsByClientListIdDto.setTpaId(null);
			}

			return allProductsByClientListIdDto;
		}).toList();
	}

//  @Override
//  public AddProductClientDto updateClientListProduct(Long clientListId, AddProductClientDto addProductClientDto) {
//     Optional<Product> productOptional = prodRepository.findById(clientListId);
//     log.info("Product Before Update From Update ClientList Product", productOptional);
//
//     if (productOptional.isPresent()) {
//        Product product = productOptional.get();
//        product.setPolicyType(addProductClientDto.getPolicyType());
//        product.setUpdatedDate(new Date());
//
//        // Handle insurer
//        Optional<InsureList> insurer = insureListRepository.findById(addProductClientDto.getInsurerCompanyId());
//        log.info("Insurer From update ClientList Product", insurer);
//        product.setInsureCompanyId(insurer.orElse(null));
//
//        // Handle tpa
//        if (addProductClientDto.getTpaId() != null && !addProductClientDto.getTpaId().trim().isEmpty()) {
//           Optional<Tpa> tpa = tpaRepository.findById(Long.parseLong(addProductClientDto.getTpaId()));
//           log.info("Tpa From Update ClientList Product: {}", tpa.isPresent() ? tpa.get() : null);
//           product.setTpaId(tpa.orElse(null));
//        } else {
//           product.setTpaId(null);
//        }
//
//        // Save the updated product
//        Product updatedProduct = prodRepository.save(product);
//
//        // Update the DTO with the new values
//        addProductClientDto.setProductId(String.valueOf(updatedProduct.getProductName()));
//        addProductClientDto.setPolicyType(updatedProduct.getPolicyType());
//        addProductClientDto.setTpaId(
//              updatedProduct.getTpaId() != null ? String.valueOf(updatedProduct.getTpaId().getTpaName()) : null);
//        addProductClientDto.setInsurerCompanyId(updatedProduct.getInsureCompanyId() != null
//              ? String.valueOf(updatedProduct.getInsureCompanyId().getInsurerName())
//              : null);
//
//        return addProductClientDto;
//     }
//
//     return null;
//  }

	// update ClientList
	@Transactional
	public AddProductClientDto updateClientListProduct(Long clientId, Long productId, AddProductClientDto addProductClientDto) {
		if (clientId != null && productId != null) {
			Optional<ClientList> clientOptional = clientListRepository.findById(clientId);
			log.info("ClientList from Update ClientList Product:{}", clientOptional.orElse(null));

			Optional<Product> productOptional = prodRepository.findById(productId);
			log.info("Product from Update ClientList Product:{}", productOptional.orElse(null));

			if (clientOptional.isPresent() && productOptional.isPresent()) {
				// Update the product relationship within a transaction

				updateProductRelationship(Long.parseLong(addProductClientDto.getProductId()), clientId, productId);

				// Save the client (consider removing this if not necessary)
				// ClientList updatedClient = clientOptional.get();
				// clientListRepository.save(updatedClient);

				// Set values in DTO based on the retrieved entities
				if (addProductClientDto.getInsurerCompanyId() != null
						&& !addProductClientDto.getInsurerCompanyId().trim().isEmpty()) {
					Optional<InsureList> insurer = insureListRepository
							.findById(addProductClientDto.getInsurerCompanyId());
					addProductClientDto.setInsurerCompanyId(insurer.map(InsureList::getInsurerName).orElse(null));
				} else {
					addProductClientDto.setInsurerCompanyId(null);
				}

				if (addProductClientDto.getTpaId() != null && !addProductClientDto.getTpaId().trim().isEmpty()) {
					Optional<Tpa> tpa = tpaRepository.findById(Long.parseLong(addProductClientDto.getTpaId()));
					addProductClientDto.setTpaId(tpa.map(Tpa::getTpaName).orElse(null));
				} else {
					addProductClientDto.setTpaId(null);
				}

				if (addProductClientDto.getPolicyType() != null
						&& !addProductClientDto.getPolicyType().trim().isEmpty()) {
					addProductClientDto.setPolicyType(addProductClientDto.getPolicyType());
				} else {
					addProductClientDto.setPolicyType(null);
				}

				return addProductClientDto;
			}
		}

		return null;
	}
	@Transactional
	public void updateProductRelationship(Long newProductId, Long clientListId, Long oldProductId) {
		log.info("newProductId: {}, clientListId: {}, oldProductId: {}", newProductId, clientListId, oldProductId);
		clientListRepository.updateProductRelationship(newProductId, clientListId, oldProductId);
	}



	@Override
	@Transactional
	public String deleteProductRelationForClientList(Long productId, Long clientListId) {
		// TODO Auto-generated method stub
		clientListRepository.deleteProductRelationShip(productId, clientListId);

		return "Product relation deleted successfully for client list";
	}

}