package com.insure.rfq.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.insure.rfq.dto.ProductCategoryChildDto;
import com.insure.rfq.service.ProductCategoryService;

@RestController
@RequestMapping("/rfq/category")
@CrossOrigin(origins = "*")
public class ProductCategoryController {
	@Autowired
	private ProductCategoryService service;

	@GetMapping("/prodCategory")
	public List<ProductCategoryChildDto> prodCategory() {
		return service.findCategory();
	}
}
