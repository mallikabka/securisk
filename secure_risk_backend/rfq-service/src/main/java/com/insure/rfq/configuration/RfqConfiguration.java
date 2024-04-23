package com.insure.rfq.configuration;

import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.insure.rfq.repository.EmpDependentRepository;
import com.insure.rfq.utils.ExcelUtils;

@Configuration
public class RfqConfiguration {
    @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();
    }

    @Bean
    public ExcelUtils excelUtils() {
        return new ExcelUtils();
    }
}
