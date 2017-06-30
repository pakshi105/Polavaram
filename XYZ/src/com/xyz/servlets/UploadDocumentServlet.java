package com.xyz.servlets;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;

/**
 * Servlet implementation class UploadDocumentServlet
 */
@WebServlet("/UploadDocumentServlet")
@MultipartConfig
public class UploadDocumentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String SAVE_DIR = "uploadFiles";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UploadDocumentServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// gets absolute path of the web applicatio
		System.out.println("servlet entered");
		String annotationId = null;
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		System.out.println(isMultipart);
		if (isMultipart) {
			System.out.println("is multipart");
			FileItemFactory factory = new DiskFileItemFactory();
			ServletFileUpload upload = new ServletFileUpload(factory);

			try {
				List items = upload.parseRequest(request);
				Iterator iterator = items.iterator();
				while (iterator.hasNext()) {
					FileItem item = (FileItem) iterator.next();
					if (!item.isFormField()) {
						String fileName = item.getName();

						String root = getServletContext().getRealPath("/");
						File path = new File(root + "/uploads/" + annotationId );
						if (!path.exists()) {
							boolean status = path.mkdirs();
						}
						System.out.println(path);
						File uploadedFile = new File(path + "/" + fileName);
						item.write(uploadedFile);
					} else {
						annotationId = item.getString();
						System.out.println(annotationId);
					}
				}
			} catch (FileUploadException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		/*
		 * String id = request.getParameter("hideId"); String appPath =
		 * request.getServletContext().getRealPath(""); // constructs path of
		 * the directory to save uploaded file
		 * 
		 * System.out.println(request.getParts()); String fileName = null; Part
		 * filePart = null; String annotationId = null; for (Part part :
		 * request.getParts()) {
		 * 
		 * if (part.getName().equals("hideId")) { // Normal field byte[] buffer
		 * = new byte[128]; part.getInputStream().read(buffer); annotationId =
		 * buffer.toString(); System.out.println(annotationId); } else { // File
		 * fileName = extractFileName(part); filePart = part; } } String
		 * savePath = appPath + File.separator + SAVE_DIR + File.separator +
		 * annotationId; System.out.println(savePath);
		 * 
		 * // creates the save directory if it does not exists File fileSaveDir
		 * = new File(savePath); if (!fileSaveDir.exists()) {
		 * fileSaveDir.mkdir(); } fileName = new File(fileName).getName();
		 * filePart.write(savePath + File.separator + fileName);
		 */
		request.setAttribute("message", "Upload has been done successfully!");
		/*
		 * getServletContext().getRequestDispatcher("/message.jsp").forward(
		 * request, response);
		 */
	}

	/**
	 * Extracts file name from HTTP header content-disposition
	 */
	private String extractFileName(Part part) {
		String contentDisp = part.getHeader("content-disposition");
		String[] items = contentDisp.split(";");
		for (String s : items) {
			if (s.trim().startsWith("filename")) {
				return s.substring(s.indexOf("=") + 2, s.length() - 1);
			}
		}
		return "";
	}

}
