package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Users;

public class UserDAO extends DBContext {

    public Users checkLogin(String username, String password) {
        if (connection == null) {
            return null;
        }

        String sql = "SELECT * FROM Users "
                + "WHERE username = ? "
                + "AND password = ? "
                + "AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Users user = new Users();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setRole(rs.getString("role"));
                user.setIsActive(rs.getBoolean("is_active"));
                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean checkDuplicate(String username, String email) {
        if (connection == null) {
            return false;
        }

        String sql = "SELECT username FROM Users "
                + "WHERE username = ? OR email = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertUser(Users user) {
        if (connection == null) {
            return false;
        }

        String sql = "INSERT INTO Users "
                + "(username, password, full_name, email, phone_number, role, is_active) "
                + "VALUES (?, ?, ?, ?, ?, 'student', 1)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());

            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}