package com.insure.rfq.service.impl;

import java.util.List;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.insure.rfq.dto.ProductClientDto;
import com.insure.rfq.entity.ClientList;
import com.insure.rfq.repository.ClientListRepository;
import com.insure.rfq.repository.ProductRepository;
import com.insure.rfq.service.ProductClientService;

@Service
public class ProductClientServiceImp implements ProductClientService {

	@Autowired
	private ModelMapper modelMapper;
	@Autowired
	private ClientListRepository clientListRepository;

	@Autowired
	private ProductRepository productRepository;

	@Override
	public List<ProductClientDto> getProductsBasedonClientId(Long clientId) {
		ClientList clientList = clientListRepository.findById(clientId).get();
		return clientList.getProduct().stream().map(client -> {
			ProductClientDto clientDto = new ProductClientDto();
			clientDto.setPid(client.getProductId());
			clientDto.setProductType(client.getProductName());
//			clientDto.setInsurerCompany(client.getInsureCompany());
			clientDto.setPolicyType(client.getPolicyType());
//			clientDto.setTpaList(client.getTpaList());
			return clientDto;
		}).toList();
	}
}
