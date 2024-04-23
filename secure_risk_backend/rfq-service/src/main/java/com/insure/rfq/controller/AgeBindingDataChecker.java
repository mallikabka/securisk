package com.insure.rfq.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.insure.rfq.generator.AgeBindingData;

@RestController
@RequestMapping("/rfq")
@CrossOrigin("*")
public class AgeBindingDataChecker {
	@Autowired
	private AgeBindingData ageBindingData;
//	@GetMapping("/getRelationn")
//	@ResponseStatus(value = HttpStatus.OK)
//public Set<String>getData(@RequestParam("rfdId")  String rfdId)
//{
//	//return ageBindingData.getAllSetOfRelationOfOnePlusThree(rfdId);
//		return ageBindingData.onePlusFive(rfdId);
//}
//	@GetMapping("/data")
//	@ResponseStatus(value = HttpStatus.OK)
//	public Set<String> getAgeData(@RequestParam int minAge,@RequestParam int maxAge,@RequestParam String relation,@RequestParam String rfqId )
//	{
//		return ageBindingData.getAllSetOfRelationOfOnePlusFive(rfqId);
//		
//		
//	}
//	@GetMapping("/relation")
//	@ResponseStatus(value = HttpStatus.OK)
//	public Set<String >getOnePlusThreeData(@RequestParam("rfdId")  String rfdId)
//	{
//		return ageBindingData.getAllSetOfRelationOfOnePlusThree(rfdId);
//	}
	
	
}
