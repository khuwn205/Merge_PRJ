/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Claims;
/**
 *
 * @author phant
 */
public class ClaimDAO extends DBContext{

    public List<Claims> getAllClaims() {

        List<Claims> list = new ArrayList<>();

        String sql = "SELECT * FROM Claims";

        try {

            PreparedStatement st = connection.prepareStatement(sql);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {

                Claims c = new Claims(
                        rs.getInt("claim_id"),
                        rs.getInt("item_id"),
                        rs.getInt("claimer_id"),
                        rs.getString("status"),
                        rs.getString("proof_description"),
                        rs.getString("response_message"),
                        rs.getInt("responded_by"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );

                list.add(c);
            }

        } catch (SQLException e) {
            System.out.println(e);
        }

        return list;
    }

    public void deleteClaim(int id) {

        String sql = "DELETE FROM Claims WHERE claim_id = ?";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
