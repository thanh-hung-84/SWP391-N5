package tool;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Small helper used by every interview-scheduling servlet to make sure the
 * caller is a logged-in Staff member (HR Staff or Manager). Admin/Candidate
 * accounts are not allowed to use these internal HR tools because Interview,
 * InterviewBarem, etc. all reference Staff(StaffID) via foreign keys.
 */
public class SessionUtil {

    public static Integer getStaffId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Object v = session.getAttribute("staffId");
        return (v instanceof Integer) ? (Integer) v : null;
    }

    public static String getStaffName(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (String) session.getAttribute("staffName");
    }

    public static String getRoleName(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (String) session.getAttribute("roleName");
    }

    /**
     * Returns true and lets the caller continue if the user is a logged-in
     * HR Staff or Manager. Otherwise redirects to login (or shows 403) and
     * returns false - the calling servlet must stop processing in that case.
     */
    public static boolean requireStaffAccess(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer staffId = getStaffId(request);
        if (staffId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }

        String roleName = getRoleName(request);
        if (!"HR Staff".equals(roleName) && !"Manager".equals(roleName)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Chỉ HR Staff hoặc Manager mới được truy cập chức năng này.");
            return false;
        }
        return true;
    }
}
