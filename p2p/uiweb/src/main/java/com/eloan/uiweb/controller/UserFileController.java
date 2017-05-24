package com.eloan.uiweb.controller;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.eloan.base.util.UserContext;
import com.eloan.business.domain.Userfile;
import com.eloan.business.service.IUserFileService;
import com.eloan.uiweb.interceptor.RequiredLogin;
import com.eloan.uiweb.util.UploadUtil;

@Controller
public class UserFileController extends BaseController {

	@Autowired
	private IUserFileService userFileService;

	@Autowired
	private ServletContext servletContext;

	@RequiredLogin
	@RequestMapping("userFile")
	public String userFile(Model model, HttpSession session) {
		List<Userfile> unSetFileTypes = this.userFileService
				.listUnSetTypeFiles(UserContext.getCurrent().getId(), true);
		if (unSetFileTypes.size() > 0) {
			model.addAttribute("userFiles", unSetFileTypes);
			return "userFiles_commit";
		} else {
			unSetFileTypes = this.userFileService.listUnSetTypeFiles(
					UserContext.getCurrent().getId(), false);
			model.addAttribute("userFiles", unSetFileTypes);
			model.addAttribute("sessionid", session.getId());
			return "userFiles";
		}
	}

	@RequestMapping("userFileUpload")
	@ResponseBody
	public String userFileUpload(MultipartFile file) {
		String filePath = servletContext.getRealPath("/upload");
		String fileName = UploadUtil.upload(file, filePath);
		String path = "/upload/" + fileName;
		this.userFileService.applyFile(path);
		return path;
	}

	@RequestMapping("userFile_selectType")
	public String selectType(Long[] id, Long[] fileType) {
		if (id.length == fileType.length) {
			this.userFileService.applyTypes(id, fileType);
		}
		return "redirect:userFile.do";
	}

}
