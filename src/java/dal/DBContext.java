package dal;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author FPT University - PRJ30X
 */
public class DBContext {

    protected Connection connection;

    private static final String DEFAULT_URL = "jdbc:sqlserver://localhost:1433;databaseName=Project_PRJ301_DB;trustServerCertificate=true";
    private static final String DEFAULT_USER = "SA";
    private static final String DEFAULT_PASSWORD = "123";

    public DBContext() {
        try {
            Properties properties = loadDbProperties();

            String url = firstNonBlank(
                    properties.getProperty("url"),
                    DEFAULT_URL
            );
            String user = firstNonBlank(
                    properties.getProperty("userID"),
                    properties.getProperty("user"),
                    properties.getProperty("username"),
                    DEFAULT_USER
            );
            String pass = firstNonBlank(
                    properties.getProperty("password"),
                    properties.getProperty("pass"),
                    DEFAULT_PASSWORD
            );

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Khong ket noi duoc SQL Server.", ex);
        } catch (Exception ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Loi khoi tao DBContext.", ex);
        }
    }

    private Properties loadDbProperties() {
        Properties properties = new Properties();

        try (InputStream classpathStream = getClass().getClassLoader().getResourceAsStream("ConnectDB.properties")) {
            if (classpathStream != null) {
                properties.load(classpathStream);
                return properties;
            }
        } catch (IOException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.WARNING, "Doc ConnectDB.properties tren classpath that bai.", ex);
        }

        String[] fallbackPaths = new String[]{
            System.getProperty("user.dir") + File.separator + "src" + File.separator + "java" + File.separator + "ConnectDB.properties",
            System.getProperty("user.dir") + File.separator + "build" + File.separator + "web" + File.separator + "WEB-INF" + File.separator + "classes" + File.separator + "ConnectDB.properties"
        };

        for (String path : fallbackPaths) {
            File f = new File(path);
            if (!f.exists()) {
                continue;
            }

            try (InputStream fs = new FileInputStream(f)) {
                properties.load(fs);
                return properties;
            } catch (IOException ex) {
                Logger.getLogger(DBContext.class.getName()).log(Level.WARNING, "Doc ConnectDB.properties that bai tai: " + path, ex);
            }
        }

        Logger.getLogger(DBContext.class.getName()).log(Level.WARNING,
                "Khong tim thay ConnectDB.properties. Su dung cau hinh DB mac dinh.");
        return properties;
    }

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
        }
        return null;
    }
}