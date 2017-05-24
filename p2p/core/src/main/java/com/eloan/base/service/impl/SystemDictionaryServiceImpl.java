package com.eloan.base.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eloan.base.domain.SystemDictionary;
import com.eloan.base.domain.SystemDictionaryItem;
import com.eloan.base.mapper.SystemDictionaryItemMapper;
import com.eloan.base.mapper.SystemDictionaryMapper;
import com.eloan.base.query.PageResult;
import com.eloan.base.query.SystemDictionaryQueryObject;
import com.eloan.base.service.ISystemDictionaryService;

@Service
public class SystemDictionaryServiceImpl implements ISystemDictionaryService {
	@Autowired
	private SystemDictionaryMapper systemDictionaryMapper;

	@Autowired
	private SystemDictionaryItemMapper systemDictionaryItemMapper;

	@Override
	public List<SystemDictionary> listDics() {
		return systemDictionaryMapper.selectAll();
	}

	@Override
	public PageResult queryDic(SystemDictionaryQueryObject qo) {
		int count = this.systemDictionaryMapper.queryForCount(qo);
		if (count > 0) {
			List<SystemDictionary> list = this.systemDictionaryMapper.query(qo);
			return new PageResult(count, qo.getPageSize(), qo.getCurrentPage(),
					list);
		}
		return PageResult.empty(qo.getPageSize());
	}

	@Override
	public void saveOrUpdate(SystemDictionary sd) {
		if (sd.getId() != null) {
			this.systemDictionaryMapper.updateByPrimaryKey(sd);
		} else {
			this.systemDictionaryMapper.insert(sd);
		}
	}

	@Override
	public PageResult queryDicItem(SystemDictionaryQueryObject qo) {
		int count = this.systemDictionaryItemMapper.queryForCount(qo);
		if (count > 0) {
			List<SystemDictionaryItem> list = this.systemDictionaryItemMapper
					.query(qo);
			return new PageResult(count, qo.getPageSize(), qo.getCurrentPage(),
					list);
		}
		return PageResult.empty(qo.getPageSize());
	}

	@Override
	public void saveOrUpdateItem(SystemDictionaryItem item) {
		if (item.getId() != null) {
			this.systemDictionaryItemMapper.updateByPrimaryKey(item);
		} else {
			this.systemDictionaryItemMapper.insert(item);
		}
	}

	@Override
	public List<SystemDictionaryItem> queryBySn(String sn) {
		return this.systemDictionaryItemMapper.queryBySn(sn);
	}

}
