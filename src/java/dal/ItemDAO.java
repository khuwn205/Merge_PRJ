/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Items;

/**
 *
 * @author phant
 */
public class ItemDAO extends DBContext {

    public List<Items> getAllItems() {

        List<Items> list = new ArrayList<>();

        String sql = "SELECT * FROM Items";

        try {

            PreparedStatement st = connection.prepareStatement(sql);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {

                Items i = new Items(
                        rs.getInt("item_id"),
                        rs.getInt("user_id"),
                        rs.getInt("category_id"),
                        rs.getInt("location_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("type"),
                        rs.getString("status"),
                        rs.getString("images_json"),
                        rs.getDate("date_incident"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );

                list.add(i);

            }

        } catch (SQLException e) {
            System.out.println(e);
        }

        return list;
    }

    public void deleteItem(int id) {

        String sql = "DELETE FROM Items WHERE item_id = ?";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
