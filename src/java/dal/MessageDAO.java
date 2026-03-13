package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Message;

public class MessageDAO extends DBContext {

    public List<Message> getMessagesByItemId(int itemId) {
        List<Message> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT message_id, user_id, title, message, is_read, related_item_id, created_at "
                + "FROM Message "
                + "WHERE related_item_id = ? "
                + "ORDER BY created_at ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message msg = new Message();
                    msg.setMessageId(rs.getInt("message_id"));
                    msg.setUserId(rs.getInt("user_id"));
                    msg.setTitle(rs.getString("title"));
                    msg.setMessage(rs.getString("message"));
                    msg.setIsRead(rs.getBoolean("is_read"));
                    msg.setRelatedItemId(rs.getInt("related_item_id"));
                    msg.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(msg);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Map<Integer, String> getSenderNamesByItemId(int itemId) {
        Map<Integer, String> map = new HashMap<>();
        if (connection == null) {
            return map;
        }

        String sql = "SELECT DISTINCT m.user_id, u.full_name "
                + "FROM Message m "
                + "INNER JOIN Users u ON m.user_id = u.user_id "
                + "WHERE m.related_item_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt("user_id"), rs.getString("full_name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }

    public boolean hasUserMessagedItem(int userId, int itemId) {
        if (connection == null) {
            return false;
        }

        String sql = "SELECT TOP 1 message_id FROM Message WHERE user_id = ? AND related_item_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, itemId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertMessage(int userId, int itemId, String title, String content) {
        if (connection == null) {
            return false;
        }

        String sql = "INSERT INTO Message (user_id, title, message, is_read, related_item_id) VALUES (?, ?, ?, 0, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, content);
            ps.setInt(4, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================================================
    // 2 HÀM MỚI THÊM CHO TÍNH NĂNG HÒM THƯ (INBOX)
    // =========================================================

    // 1. Lấy danh sách Tin nhắn đến (Inbox)
    public List<Map<String, Object>> getInbox(int receiverId) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (connection == null) return list;
        
        String sql = "SELECT m.message_id, m.title, m.message, m.is_read, m.created_at, "
                   + "u.full_name AS sender_name, i.title AS item_title, i.item_id "
                   + "FROM Message m "
                   + "INNER JOIN Items i ON m.related_item_id = i.item_id "
                   + "INNER JOIN Users u ON m.user_id = u.user_id "
                   + "WHERE i.user_id = ? "
                   + "ORDER BY m.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, receiverId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("messageId", rs.getInt("message_id"));
                    map.put("title", rs.getString("title"));
                    map.put("message", rs.getString("message"));
                    map.put("isRead", rs.getBoolean("is_read"));
                    map.put("createdAt", rs.getTimestamp("created_at"));
                    map.put("senderName", rs.getString("sender_name"));
                    map.put("itemTitle", rs.getString("item_title"));
                    map.put("itemId", rs.getInt("item_id"));
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Lấy danh sách Tin nhắn đã gửi (Outbox)
    public List<Map<String, Object>> getOutbox(int senderId) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (connection == null) return list;
        
        String sql = "SELECT m.message_id, m.title, m.message, m.is_read, m.created_at, "
                   + "i.title AS item_title, i.item_id "
                   + "FROM Message m "
                   + "LEFT JOIN Items i ON m.related_item_id = i.item_id "
                   + "WHERE m.user_id = ? "
                   + "ORDER BY m.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, senderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("messageId", rs.getInt("message_id"));
                    map.put("title", rs.getString("title"));
                    map.put("message", rs.getString("message"));
                    map.put("isRead", rs.getBoolean("is_read"));
                    map.put("createdAt", rs.getTimestamp("created_at"));
                    map.put("itemTitle", rs.getString("item_title"));
                    map.put("itemId", rs.getInt("item_id"));
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}