package com.insure.rfq.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EmailFileDTo {
	private byte[] fileByteData;
	private String filename;
	
}
