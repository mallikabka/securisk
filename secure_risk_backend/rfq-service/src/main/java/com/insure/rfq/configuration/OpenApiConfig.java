package com.insure.rfq.configuration;


import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecurityScheme;

@OpenAPIDefinition(
        info = @Info(
                contact = @Contact(
                        name = "Balakrishna Jonnadula",
                        email = "myself.jbk@gmail.com",
                        url = "https://balakrishna-jonnadula.web.app"
                ),
                description = "OpenApi Documentation for spring security",
                title = "INSURE APPLICATION",
                version = "1.0",
                license = @License(
                        name = "Licence Name",
                        url = "https://jbk-url.com"
                ),
                termsOfService = "http://14.99.138.131:9980/Securisk/"


        ),
//        servers ={
//                @Server(
//                        description = "DEV",
//                        url = "http://192.168.5.67:9981/"
//                )
//                @Server(
//                        description = "Local dev",
//                        url = "http://localhost:8080/"
//                )
//        },
        security = {
                @SecurityRequirement(
                        name = "bearerAuth"
                )
        }
)
@SecurityScheme(
        name = "bearerAuth",
        description = "JWT auth description",
        type = SecuritySchemeType.HTTP,
        bearerFormat = "JWT",
        in = SecuritySchemeIn.HEADER,
        scheme = "bearer"


)
public class OpenApiConfig {

}
