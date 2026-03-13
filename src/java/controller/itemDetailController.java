package controller;

import dal.ClaimDAO;
import dal.ItemDAO;
import dal.MessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Claims;
import model.Items;
import model.Message;
import model.Users;

public class itemDetailController extends HttpServlet {

    private boolean isBlank(String value) { return value == null || value.trim().isEmpty(); }

    private List<String> parseImagePaths(String imagesJson) {
        List<String> paths = new ArrayList<>();
        if (isBlank(imagesJson)) return paths;
        String raw = imagesJson.trim();
        if (raw.startsWith("[")) raw = raw.substring(1);
        if (raw.endsWith("]")) raw = raw.substring(0, raw.length() - 1);
        if (isBlank(raw)) return paths;
        String[] tokens = raw.split(",");
        for (String token : tokens) {
            String value = token == null ? "" : token.trim();
            if (value.startsWith("\"")) value = value.substring(1);
            if (value.endsWith("\"")) value = value.substring(0, value.length() - 1);
            value = value.replace("\\\"", "\"").replace("\\\\", "\\");
            if (!isBlank(value)) paths.add(value);
        }
        return paths;
    }

    private void forwardDetail(int itemId, HttpServletRequest request, HttpServletResponse response, Users currentUser)
            throws ServletException, IOException {
        ItemDAO itemDAO = new ItemDAO();
        Items itemDetail = itemDAO.getItemById(itemId);
        if (itemDetail == null) {
            response.sendRedirect("my_items"); return;
        }

        MessageDAO messageDAO = new MessageDAO();
        List<Message> allMessages = messageDAO.getMessagesByItemId(itemId);
        List<Message> itemMessages = new ArrayList<>();
        boolean isItemOwner = currentUser.getUserId() == itemDetail.getUserId();

        if (isItemOwner) {
            itemMessages = allMessages;
        } else {
            for (Message msg : allMessages) {
                if (msg.getUserId() == currentUser.getUserId()) itemMessages.add(msg);
            }
        }

        ClaimDAO claimDAO = new ClaimDAO();
        List<Claims> claims = claimDAO.getClaimsByItemId(itemId);
        Map<Integer, Claims> claimByClaimer = new HashMap<>();
        for (Claims claim : claims) claimByClaimer.put(claim.getClaimerId(), claim);

        request.setAttribute("itemDetail", itemDetail);
        request.setAttribute("itemMessages", itemMessages);
        request.setAttribute("senderNames", messageDAO.getSenderNamesByItemId(itemId));
        request.setAttribute("imagePaths", parseImagePaths(itemDetail.getImagesJSON()));
        request.setAttribute("claimByClaimer", claimByClaimer);
        request.setAttribute("isItemOwner", isItemOwner);
        // THÊM MỚI: truyền itemType để JSP phân biệt found / lost
        request.setAttribute("itemType", itemDetail.getType());
        request.getRequestDispatcher("item_detail.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login"); return;
        }
        try {
            int itemId = Integer.parseInt(request.getParameter("id"));
            forwardDetail(itemId, request, response, (Users) session.getAttribute("currentUser"));
        } catch (Exception e) { response.sendRedirect("my_items"); }
    }

    private void handleSendMessage(HttpServletRequest request, HttpServletResponse response, Users currentUser) throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        Items itemDetail = new ItemDAO().getItemById(itemId);

        if (currentUser.getUserId() == itemDetail.getUserId()) {
            request.setAttribute("ERROR", "Bạn không thể gửi tin nhắn cho bài đăng của chính mình.");
            forwardDetail(itemId, request, response, currentUser);
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("message");
        MessageDAO messageDAO = new MessageDAO();

        if (messageDAO.insertMessage(currentUser.getUserId(), itemId, title, content)) {
            if ("found".equalsIgnoreCase(itemDetail.getType())) {
                // Bài nhặt được đồ: giữ nguyên flow cũ — tạo Claim pending ngay
                ClaimDAO claimDAO = new ClaimDAO();
                if (claimDAO.getClaimByItemAndClaimer(itemId, currentUser.getUserId()) == null) {
                    claimDAO.insertClaim(itemId, currentUser.getUserId(), itemDetail.getUserId(), content);
                }
                request.getSession().setAttribute("message", "Đã gửi tin nhắn và Yêu cầu thành công!");
            } else {
                // Bài báo mất đồ: KHÔNG tạo Claim — chờ chủ bài xác nhận đây có phải đồ của họ không
                request.getSession().setAttribute("message", "Đã gửi tin nhắn! Chờ chủ bài xác nhận.");
            }
            response.sendRedirect("item_detail?id=" + itemId);
        } else {
            request.setAttribute("ERROR", "Lỗi khi gửi tin nhắn.");
            forwardDetail(itemId, request, response, currentUser);
        }
    }

    // KHÔNG SỬA — giữ nguyên cho flow "found"
    private void handleRespondClaim(HttpServletRequest request, HttpServletResponse response, Users currentUser) throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int claimId = Integer.parseInt(request.getParameter("claim_id"));
        String decision = request.getParameter("decision");

        ItemDAO itemDAO = new ItemDAO();
        Items item = itemDAO.getItemById(itemId);

        ClaimDAO claimDAO = new ClaimDAO();
        Claims claim = claimDAO.getClaimById(claimId);

        // ĐÃ FIX: Chỉ cần là Chủ bài đăng (item.getUserId) là có quyền duyệt, bỏ qua cái respondedBy ảo ma của DB cũ
        if (item != null && claim != null && currentUser.getUserId() == item.getUserId() && "pending".equals(claim.getStatus())) {
            String newStatus = "accept".equals(decision) ? "approved" : "rejected";
            String msg = "accept".equals(decision) ? "Đã duyệt trả đồ" : "Đã từ chối";

            if (claimDAO.updateClaimStatus(claimId, newStatus, msg, currentUser.getUserId())) {
                itemDAO.updateItemStatus(itemId, "approved".equals(newStatus) ? "completed" : "processing");
                request.getSession().setAttribute("message", "Đã phản hồi yêu cầu thành công!");
            }
        } else {
            request.getSession().setAttribute("message", "Lỗi: Bạn không có quyền duyệt hoặc yêu cầu đã được xử lý.");
        }
        response.sendRedirect("item_detail?id=" + itemId);
    }

    // THÊM MỚI: chủ bài "lost" (A) bấm "Yêu cầu nhận lại đồ" hoặc "Đây không phải đồ của tôi"
    // → Tạo Claim với status pending hoặc rejected (đều nằm trong constraint DB)
    private void handleOwnerRequestLost(HttpServletRequest request, HttpServletResponse response, Users currentUser) throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int claimerId = Integer.parseInt(request.getParameter("claimer_id")); // userId của B (người gửi tin)
        String decision = request.getParameter("decision");

        ItemDAO itemDAO = new ItemDAO();
        Items item = itemDAO.getItemById(itemId);

        ClaimDAO claimDAO = new ClaimDAO();

        // Kiểm tra: phải là chủ bài và chưa có Claim nào cho người này
        if (item != null && currentUser.getUserId() == item.getUserId()
                && claimDAO.getClaimByItemAndClaimer(itemId, claimerId) == null) {
            if ("request".equals(decision)) {
                // Xác nhận đây là đồ của mình → tạo Claim pending, chờ B xác nhận trả
                claimDAO.insertClaimWithStatus(itemId, claimerId, currentUser.getUserId(),
                        "Chủ bài yêu cầu nhận lại đồ", "pending");
                request.getSession().setAttribute("message", "Đã gửi Yêu cầu nhận lại đồ! Chờ người tìm thấy xác nhận.");
            } else if ("reject".equals(decision)) {
                // Xác nhận không phải đồ của mình → tạo Claim rejected ngay
                claimDAO.insertClaimWithStatus(itemId, claimerId, currentUser.getUserId(),
                        "Chủ bài xác nhận đây không phải đồ của họ", "rejected");
                request.getSession().setAttribute("message", "Đã xác nhận đây không phải đồ của bạn.");
            } else {
                request.getSession().setAttribute("message", "Lỗi: Hành động không hợp lệ.");
            }
        } else {
            request.getSession().setAttribute("message", "Lỗi: Bạn không có quyền hoặc yêu cầu đã được xử lý.");
        }
        response.sendRedirect("item_detail?id=" + itemId);
    }

    // THÊM MỚI: người tìm thấy (B) bấm Accept / Reject sau khi A đã gửi "Yêu cầu nhận lại đồ"
    private void handleFinderRespondLost(HttpServletRequest request, HttpServletResponse response, Users currentUser) throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int claimId = Integer.parseInt(request.getParameter("claim_id"));
        String decision = request.getParameter("decision");

        ItemDAO itemDAO = new ItemDAO();
        Items item = itemDAO.getItemById(itemId);

        ClaimDAO claimDAO = new ClaimDAO();
        Claims claim = claimDAO.getClaimById(claimId);

        // Kiểm tra: phải là người được claim (B) và claim đang pending
        if (item != null && claim != null
                && currentUser.getUserId() == claim.getClaimerId()
                && "pending".equals(claim.getStatus())) {
            if ("accept".equals(decision)) {
                // B đồng ý trả đồ → approved, bài hoàn thành
                claimDAO.updateClaimStatus(claimId, "approved", "Người tìm thấy đồng ý trả lại đồ", currentUser.getUserId());
                itemDAO.updateItemStatus(itemId, "completed");
                request.getSession().setAttribute("message", "Đã chấp nhận! Liên hệ với chủ đồ để sắp xếp trả lại.");
            } else if ("reject".equals(decision)) {
                // B từ chối → rejected
                claimDAO.updateClaimStatus(claimId, "rejected", "Người tìm thấy từ chối trả lại đồ", currentUser.getUserId());
                itemDAO.updateItemStatus(itemId, "processing");
                request.getSession().setAttribute("message", "Đã từ chối yêu cầu.");
            } else {
                request.getSession().setAttribute("message", "Lỗi: Hành động không hợp lệ.");
            }
        } else {
            request.getSession().setAttribute("message", "Lỗi: Bạn không có quyền hoặc yêu cầu đã được xử lý.");
        }
        response.sendRedirect("item_detail?id=" + itemId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) { response.sendRedirect("login"); return; }

        Users currentUser = (Users) session.getAttribute("currentUser");
        if ("respond_claim".equals(request.getParameter("action"))) {
            handleRespondClaim(request, response, currentUser);
        } else if ("owner_request_lost".equals(request.getParameter("action"))) {
            // THÊM MỚI: chủ bài "lost" xác nhận / từ chối
            handleOwnerRequestLost(request, response, currentUser);
        } else if ("finder_respond_lost".equals(request.getParameter("action"))) {
            // THÊM MỚI: người tìm thấy Accept / Reject yêu cầu nhận lại
            handleFinderRespondLost(request, response, currentUser);
        } else {
            handleSendMessage(request, response, currentUser);
        }
    }
}
