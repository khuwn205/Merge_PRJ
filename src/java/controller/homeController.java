package controller;

import dal.ItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Items;

public class homeController extends HttpServlet {

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String parseFirstImagePath(String imagesJson) {
        if (isBlank(imagesJson)) {
            return null;
        }

        String raw = imagesJson.trim();
        if (raw.startsWith("[")) {
            raw = raw.substring(1);
        }
        if (raw.endsWith("]")) {
            raw = raw.substring(0, raw.length() - 1);
        }

        if (isBlank(raw)) {
            return null;
        }

        String[] tokens = raw.split(",");
        if (tokens.length == 0) {
            return null;
        }

        String value = tokens[0] == null ? "" : tokens[0].trim();
        if (value.startsWith("\"")) {
            value = value.substring(1);
        }
        if (value.endsWith("\"")) {
            value = value.substring(0, value.length() - 1);
        }
        value = value.replace("\\\"", "\"").replace("\\\\", "\\");

        return isBlank(value) ? null : value;
    }

    private Map<Integer, String> buildImageMap(List<Items> items) {
        Map<Integer, String> imageMap = new HashMap<>();
        for (Items item : items) {
            imageMap.put(item.getItemId(), parseFirstImagePath(item.getImagesJSON()));
        }
        return imageMap;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }

        ItemDAO dao = new ItemDAO();
        List<Items> lostItems = dao.getItemsByType("lost");
        List<Items> foundItems = dao.getItemsByType("found");

        request.setAttribute("lostItems", lostItems);
        request.setAttribute("foundItems", foundItems);
        request.setAttribute("lostItemImages", buildImageMap(lostItems));
        request.setAttribute("foundItemImages", buildImageMap(foundItems));

        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}