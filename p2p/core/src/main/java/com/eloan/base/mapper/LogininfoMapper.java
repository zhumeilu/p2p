package com.eloan.base.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.eloan.base.domain.Logininfo;

public interface LogininfoMapper {

	int deleteByPrimaryKey(Long id);

	int insert(Logininfo record);

	Logininfo selectByPrimaryKey(Long id);

	List<Logininfo> selectAll();

	int updateByPrimaryKey(Logininfo record);

	int getCountByUsername(@Param("username") String username,
			@Param("userType") int userType);

	Logininfo login(@Param("name") String name,
			@Param("password") String password, @Param("userType") int userType);

	List<Map<String, Object>> autoComplate(@Param("word")String word, @Param("userType")int userType);
}