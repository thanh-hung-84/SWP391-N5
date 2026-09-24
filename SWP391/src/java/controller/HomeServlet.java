/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.JobPostDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import jakarta.servlet.ServletException;
import java.util.List;
import model.JobPostModel;

/**
 *
 * @author admin
 */

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods. Builds the company careers homepage: a handful of "featured"
     * openings for the top slider, plus the full open-position list for the
     * grid further down the page.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        JobPostDAO jobPostDAO = new JobPostDAO();
        List<JobPostModel> openJobs = jobPostDAO.getOpenJobPosts();
        jobPostDAO.closeConnection();

        int featuredCount = Math.min(openJobs.size(), 4);

        request.setAttribute("jobs", openJobs);
        request.setAttribute("featuredJobs", openJobs.subList(0, featuredCount));
        request.setAttribute("openJobCount", openJobs.size());

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
