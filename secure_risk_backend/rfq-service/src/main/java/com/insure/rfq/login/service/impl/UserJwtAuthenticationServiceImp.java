package com.insure.rfq.login.service.impl;

import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import com.insure.rfq.login.service.LoginUserDetailsService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.insure.rfq.login.dto.AuthenticationDto;
import com.insure.rfq.login.dto.DepartmentInfo;
import com.insure.rfq.login.dto.DesignationBasedOperation;
import com.insure.rfq.login.dto.LocationInfo;
import com.insure.rfq.login.dto.OperationMapped;
import com.insure.rfq.login.dto.RefreshAuthDto;
import com.insure.rfq.login.dto.SubOperation;
import com.insure.rfq.login.dto.UserInfo;
import com.insure.rfq.login.entity.Department;
import com.insure.rfq.login.entity.Location;
import com.insure.rfq.login.entity.OperationTable;
import com.insure.rfq.login.entity.RefreshToken;
import com.insure.rfq.login.entity.UserRegisteration;
import com.insure.rfq.login.repository.DepartmentRepository;
import com.insure.rfq.login.repository.DesignationOperationRepository;
import com.insure.rfq.login.repository.DesignationRepository;
import com.insure.rfq.login.repository.LocationRepository;
import com.insure.rfq.login.repository.OperationRepository;
import com.insure.rfq.login.repository.RefreshTokenRepository;
import com.insure.rfq.login.repository.UserRepositiry;
import com.insure.rfq.login.service.JwtService;
import com.insure.rfq.login.service.UserJwtAuthenticationService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserJwtAuthenticationServiceImp implements UserJwtAuthenticationService {
	@Autowired
	private RefreshTokenRepository refreshTokenRepository;
	@Autowired
	private JwtService jwtService;
	@Autowired
	private OperationRepository operationRepository;
	@Autowired
	private UserRepositiry newRepositiry;
	@Autowired
	private DepartmentRepository departmentRepository;
	@Autowired
	private DesignationOperationRepository designationOperationRepository;
	@Autowired
	private ModelMapper mapper;
	@Autowired
	private AuthenticationManager authenticationManager;
	@Autowired
	private LocationRepository locationRepository;
	@Autowired
	private DesignationRepository designationRepository;
	@Autowired
	private UserRepositiry userRepositiry;
	@Autowired
	private LoginUserDetailsService loginUserDetailsService;
	public static final String INVALID = " invalid user";

	@Override
	public UserInfo getAuthenticated(AuthenticationDto authentication) {
		log.info("get authenticate methos executed");

		Authentication authenticat = authenticationManager.authenticate(
				new UsernamePasswordAuthenticationToken(authentication.getUsername(), authentication.getPassword()));

		if (authenticat.isAuthenticated()) {
			UserInfo info = new UserInfo();
			UserRegisteration userNew = newRepositiry.findByEmail(authentication.getUsername())
					.orElseThrow(() -> new UsernameNotFoundException(INVALID));

			info.setAccessToken(jwtService.generateToken(authentication.getUsername()));
			RefreshToken build = RefreshToken.builder().token(UUID.randomUUID().toString())
					.usersNew(newRepositiry.findByEmail(authentication.getUsername()).get())
					.expiration(Instant.now().plusMillis(600000 * 20)).build();
			RefreshToken refreshTokenObj = refreshTokenRepository.findByUsersNew(userNew);
			if (refreshTokenObj != null) {
				refreshTokenRepository.delete(refreshTokenObj);
				info.setRefreshToken(refreshTokenRepository.save(build).getToken());

			} else {
				info.setRefreshToken(refreshTokenRepository.save(build).getToken());

			}
			// creating location object and setting in the user info
			Set<String> allPermittedOperationType = new LinkedHashSet<>();
			Department department = departmentRepository.findById(userNew.getDepartment().getId()).get();
			info.setDepartmentInfo(DepartmentInfo.builder().departmentId(department.getId())
					.departmentName(department.getDepartmentName()).isDepartmentInfoPermitted(true).build());
			// getting location object
			Location location = locationRepository.findById(userNew.getLocation().getLocationId())
					.orElseThrow(() -> new UsernameNotFoundException(INVALID));

			info.setLocationInfo(LocationInfo.builder().locationId(location.getLocationId())
					.locationName(location.getLocationName()).isLocationInfoPermitted(true).build());
			// designation object created
			// Optional<Designation> designtaion =
			// designationRepository.findById(userNew.getDesignation().getId());
			List<Long> listOfOperationId = designationOperationRepository
					.findByOperationId(userNew.getDesignation().getId());
			log.info(" 1  :-" + listOfOperationId);

			Set<OperationMapped> listOfOperationMapped = new LinkedHashSet<>();
			Set<String> getAllPermissionUpdate = new LinkedHashSet<>();
			for (Long value : listOfOperationId) {
				// setting the menu permission

				Optional<OperationTable> oprationObj = operationRepository.findById(value);
				log.info("menutype : 2 _  " + oprationObj.get().getMenuType());

				List<Long> operationTable = operationRepository
						.getAllMenuNameBasedOnMenuTypeObj(oprationObj.get().getMenuType());

				List<Long> allPermittedOperationByDesignationId = designationOperationRepository
						.getAllPermittedOperationByDesignationId(userRepositiry
								.findByEmail(authentication.getUsername()).get().getDesignation().getId());
				List<SubOperation> subOperation = new LinkedList<>();

				for (Long id : operationTable) {
					int res = 0;
					SubOperation subOperationtable = new SubOperation();
					subOperationtable.setOperationName(operationRepository.findById(id).get().getMenuName());
					for (Long data : allPermittedOperationByDesignationId) {
						if (id == data) {
							subOperationtable.setOperationFlag(true);
							res++;
						}

					}
					if (res == 0) {
						subOperationtable.setOperationFlag(false);
					}
					subOperation.add(subOperationtable);

				}

				// currently working

				OperationMapped operation = OperationMapped.builder().operationType(oprationObj.get().getMenuType())
						.isOperationMapped(true).subOperation(subOperation).build();
				listOfOperationMapped.add(operation);
				getAllPermissionUpdate.add(oprationObj.get().getMenuType());

			}
			for (String data : operationRepository.allOPerationMenuType()) {
				log.info("{}", operationRepository.allOPerationMenuType());
				if (getAllPermissionUpdate.add(data)) {
					log.info("{}", getAllPermissionUpdate);
					OperationMapped operation = OperationMapped.builder().operationType(data).isOperationMapped(false)
							.subOperation(null).build();
					listOfOperationMapped.add(operation);

				}

			}
			DesignationBasedOperation build2 = DesignationBasedOperation.builder()
					.desginationId(userNew.getDesignation().getId())
					.designationName(userNew.getDesignation().getDesignationName())
					.operationMapped(listOfOperationMapped).isDesignationBasedOperationPermitted(true).build();

			info.setDesignationBasedOperation(build2);
			info.setLoginSession(5);
			info.setIsLogin(true);
			info.setUserId(userNew.getUserId());
			log.info(" valid token created sucessfully ");
			boolean clientInfo = loginUserDetailsService.saveClientDetails(authentication.getUsername());
			log.info("client info saved {} ",clientInfo);
			return info;
		} else {
			throw new UsernameNotFoundException(INVALID);
		}

	}

	@Override
	public Optional<RefreshToken> validateRefreshToken(String refreshToken) {
		return refreshTokenRepository.findByToken(refreshToken);
	}

	@Override
	public RefreshToken VerifyTokenExpiration(RefreshToken refreshToken) {
		if (refreshToken.getExpiration().compareTo(Instant.now()) < 0) {
			refreshTokenRepository.delete(refreshToken);
			throw new UsernameNotFoundException(INVALID);

		} else {
			return refreshToken;
		}
	}

	@Override
	public UserInfo getAuthenticatedRefreshToken(RefreshAuthDto refreshAuthDto) {

		return validateRefreshToken(refreshAuthDto.getToken()).map(obj -> VerifyTokenExpiration(obj))
				.map(RefreshToken::getUsersNew).map(usersNew -> {
					UserInfo info = new UserInfo();
					info.setAccessToken(jwtService.generateToken(usersNew.getEmail()));
					info.setRefreshToken(refreshAuthDto.getToken());
					String accessToken = jwtService.generateToken(usersNew.getEmail());
					UserInfo.builder().accessToken(accessToken).refreshToken(refreshAuthDto.getToken()).build();
					Department department = departmentRepository.findById(usersNew.getDepartment().getId()).get();
					info.setDepartmentInfo(DepartmentInfo.builder().departmentId(department.getId())
							.departmentName(department.getDepartmentName()).isDepartmentInfoPermitted(true).build());
					// getting location object
					Location location = locationRepository.findById(usersNew.getLocation().getLocationId())
							.orElseThrow(() -> new UsernameNotFoundException(INVALID));

					info.setLocationInfo(LocationInfo.builder().locationId(location.getLocationId())
							.locationName(location.getLocationName()).isLocationInfoPermitted(true).build());
					// designation object created

					List<Long> listOfOperationId = designationOperationRepository
							.findByOperationId(usersNew.getDesignation().getId());
					Set<OperationMapped> listOfOperationMapped = new LinkedHashSet<>();
					Set<String> getAllPermissionUpdate = new LinkedHashSet<>();
					for (Long value : listOfOperationId) {
						// setting the menu permission

						Optional<OperationTable> oprationObj = operationRepository.findById(value);
						log.info("menutype : 2 _  " + oprationObj.get().getMenuType());
						List<Long> operationTable = operationRepository
								.getAllMenuNameBasedOnMenuTypeObj(oprationObj.get().getMenuType());

						List<Long> allPermittedOperationByDesignationId = designationOperationRepository
								.getAllPermittedOperationByDesignationId(
										userRepositiry.findByEmail(usersNew.getEmail()).get().getDesignation().getId());
						List<SubOperation> subOperation = new LinkedList<>();

						for (Long id : operationTable) {
							int res = 0;
							SubOperation subOperationtable = new SubOperation();
							subOperationtable.setOperationName(operationRepository.findById(id).get().getMenuName());
							for (Long data : allPermittedOperationByDesignationId) {
								if (id == data) {
									subOperationtable.setOperationFlag(true);
									res++;
								}

							}
							if (res == 0) {
								subOperationtable.setOperationFlag(false);
							}
							subOperation.add(subOperationtable);

						}

						// currently working

						OperationMapped operation = OperationMapped.builder()
								.operationType(oprationObj.get().getMenuType()).isOperationMapped(true)
								.subOperation(subOperation).build();
						listOfOperationMapped.add(operation);
						getAllPermissionUpdate.add(oprationObj.get().getMenuType());

					}
					for (String data : operationRepository.allOPerationMenuType()) {
						log.info("{}", operationRepository.allOPerationMenuType());
						if (getAllPermissionUpdate.add(data)) {
							log.info("{}", getAllPermissionUpdate);
							OperationMapped operation = OperationMapped.builder().operationType(data)
									.isOperationMapped(false).subOperation(null).build();
							listOfOperationMapped.add(operation);

						}

					}

					DesignationBasedOperation build2 = DesignationBasedOperation.builder()
							.desginationId(usersNew.getDesignation().getId())
							.designationName(usersNew.getDesignation().getDesignationName())
							.isDesignationBasedOperationPermitted(true).operationMapped(listOfOperationMapped).build();

					info.setDesignationBasedOperation(build2);
					info.setIsLogin(true);
					info.setLoginSession(5);
					return info;
				}).orElseThrow();
	}

}
