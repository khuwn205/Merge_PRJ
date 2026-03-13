package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Categories;
import model.Items;
import model.Locations;

/**
 *
 * @author HungKNHE194779
 */
public class ItemDAO extends DBContext {

    public List<Categories> getAllCategories() {
        List<Categories> list = new ArrayList<>();
        String sql = "SELECT category_id, name, description FROM Categories ORDER BY name";

        if (connection == null) {
            return list;
        }

        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Categories category = new Categories();
                category.setCategoryId(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                list.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (list.isEmpty()) {
            seedDefaultCategories();

            try (PreparedStatement ps = connection.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Categories category = new Categories();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setName(rs.getString("name"));
                    category.setDescription(rs.getString("description"));
                    list.add(category);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return list;
    }

    public List<Locations> getAllLocations() {
        List<Locations> list = new ArrayList<>();
        String sql = "SELECT location_id, name FROM Locations ORDER BY name";

        if (connection == null) {
            return list;
        }

        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Locations location = new Locations();
                location.setLocationId(rs.getInt("location_id"));
                location.setName(rs.getString("name"));
                list.add(location);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (list.isEmpty()) {
            seedDefaultLocations();

            try (PreparedStatement ps = connection.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Locations location = new Locations();
                    location.setLocationId(rs.getInt("location_id"));
                    location.setName(rs.getString("name"));
                    list.add(location);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return list;
    }

    public boolean insertLostItem(Items item) {
        return insertItemByType(item, "lost");
    }

    public boolean insertItemByType(Items item, String type) {
        if (connection == null) {
            System.out.println("insertItemByType failed: DB connection is null.");
            return false;
        }

        String normalizedType = "found".equalsIgnoreCase(type) ? "found" : "lost";

        String sql = "INSERT INTO Items "
                + "(user_id, category_id, location_id, title, description, type, status, date_incident, images_json) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'processing', ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, item.getUserId());
            ps.setInt(2, item.getCategoryId());
            ps.setInt(3, item.getLocationId());
            ps.setString(4, item.getTitle());
            ps.setString(5, item.getDescription());
            ps.setString(6, normalizedType);
            ps.setTimestamp(7, new Timestamp(item.getDateIncident().getTime()));

            if (item.getImagesJSON() == null || item.getImagesJSON().trim().isEmpty()) {
                ps.setNull(8, Types.NVARCHAR);
            } else {
                ps.setString(8, item.getImagesJSON().trim());
            }

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("insertItemByType SQL error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Items> getItemsByUserId(int userId) {
        List<Items> list = new ArrayList<>();
        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.user_id = ? "
                + "ORDER BY i.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Items getItemById(int itemId) {
        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.item_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapItem(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Items getItemByIdAndUser(int itemId, int userId) {
        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.item_id = ? AND i.user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapItem(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Items> getItemsByType(String type) {
        List<Items> list = new ArrayList<>();
        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.type = ? "
                + "ORDER BY i.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, type);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateItemByOwner(Items item) {
        String sql = "UPDATE Items SET category_id = ?, location_id = ?, title = ?, description = ?, "
                + "date_incident = ?, images_json = ?, updated_at = GETDATE() "
                + "WHERE item_id = ? AND user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, item.getCategoryId());
            ps.setInt(2, item.getLocationId());
            ps.setString(3, item.getTitle());
            ps.setString(4, item.getDescription());
            ps.setTimestamp(5, new Timestamp(item.getDateIncident().getTime()));

            if (item.getImagesJSON() == null || item.getImagesJSON().trim().isEmpty()) {
                ps.setNull(6, Types.NVARCHAR);
            } else {
                ps.setString(6, item.getImagesJSON().trim());
            }

            ps.setInt(7, item.getItemId());
            ps.setInt(8, item.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteItemByIdAndUser(int itemId, int userId) {
        if (connection == null) {
            return false;
        }

        boolean oldAutoCommit = true;
        try {
            oldAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

            try (PreparedStatement deleteClaims = connection.prepareStatement("DELETE FROM Claims WHERE item_id = ?")) {
                deleteClaims.setInt(1, itemId);
                deleteClaims.executeUpdate();
            }

            int deletedRows;
            try (PreparedStatement deleteItem = connection.prepareStatement("DELETE FROM Items WHERE item_id = ? AND user_id = ?")) {
                deleteItem.setInt(1, itemId);
                deleteItem.setInt(2, userId);
                deletedRows = deleteItem.executeUpdate();
            }

            if (deletedRows <= 0) {
                connection.rollback();
                connection.setAutoCommit(oldAutoCommit);
                return false;
            }

            connection.commit();
            connection.setAutoCommit(oldAutoCommit);
            return true;
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            try {
                connection.setAutoCommit(oldAutoCommit);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateItemStatus(int itemId, String status) {
        String sql = "UPDATE Items SET status = ?, updated_at = GETDATE() WHERE item_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private void seedDefaultCategories() {
        if (connection == null) {
            return;
        }

        String sql = "IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL "
                + "AND NOT EXISTS (SELECT 1 FROM Categories) "
                + "BEGIN "
                + "INSERT INTO Categories (name, description) VALUES "
                + "(N'Thiet bi hoc tap', N'Do dung hoc tap, sach vo, USB'),"
                + "(N'Thiet bi dien tu', N'Dien thoai, tai nghe, may tinh'),"
                + "(N'Giay to ca nhan', N'The sinh vien, CCCD, bang lai'),"
                + "(N'Phu kien', N'Vi, chia khoa, dong ho, day deo') "
                + "END";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void seedDefaultLocations() {
        if (connection == null) {
            return;
        }

        String sql = "IF OBJECT_ID('dbo.Locations', 'U') IS NOT NULL "
                + "AND NOT EXISTS (SELECT 1 FROM Locations) "
                + "BEGIN "
                + "INSERT INTO Locations (name) VALUES "
                + "(N'Can tin'),"
                + "(N'Thu vien'),"
                + "(N'Khu giang duong A'),"
                + "(N'Khu giang duong B'),"
                + "(N'Bai gui xe') "
                + "END";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Items mapItem(ResultSet rs) throws SQLException {
        Items item = new Items();
        item.setItemId(rs.getInt("item_id"));
        item.setUserId(rs.getInt("user_id"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setLocationId(rs.getInt("location_id"));
        item.setTitle(rs.getString("title"));
        item.setDescription(rs.getString("description"));
        item.setType(rs.getString("type"));
        item.setStatus(rs.getString("status"));
        item.setDateIncident(rs.getTimestamp("date_incident"));
        item.setImagesJSON(rs.getString("images_json"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        item.setUpdatedAt(rs.getTimestamp("updated_at"));
        item.setCategoryName(rs.getString("category_name"));
        item.setLocationName(rs.getString("location_name"));
        item.setOwnerFullName(rs.getString("owner_full_name"));
        return item;
    }
}