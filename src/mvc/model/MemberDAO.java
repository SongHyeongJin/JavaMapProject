package mvc.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import mvc.database.DBConnection;

public class MemberDAO {

    private static MemberDAO instance;

    private MemberDAO() {}

    public static MemberDAO getInstance() {
        if (instance == null)
            instance = new MemberDAO();
        return instance;
    }

    public void addMember(MemberDTO member) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "insert into member values(?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, member.getId());
            pstmt.setString(2, member.getName());
            pstmt.setString(3, member.getPassword());
            pstmt.executeUpdate();
        } catch (Exception ex) {
            System.out.println("addMember() 오류: " + ex);
        } finally {
            try {
                if (pstmt != null)
                    pstmt.close();
                if (conn != null)
                    conn.close();
            } catch (Exception ex) {
                throw new RuntimeException(ex.getMessage());
            }
        }
    }

    public void updateMember(MemberDTO member) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            String sql = "update member set password = ?, name =? where binary id = ?";
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            conn.setAutoCommit(false);
            pstmt.setString(1, member.getPassword());
            pstmt.setString(2, member.getName());
            pstmt.setString(3, member.getId());
            pstmt.executeUpdate();
            conn.commit();
        } catch (Exception ex) {
            System.out.println("updateMember() 오류: " + ex);
        } finally {
            try {
                if (pstmt != null)
                    pstmt.close();
                if (conn != null)
                    conn.close();
            } catch (Exception ex) {
                throw new RuntimeException(ex.getMessage());
            }
        }
    }

    public boolean LoginMember(String id, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isValidUser = false;

        try {
            String sql = "SELECT * FROM member WHERE binary id = ? AND binary password = ?";
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                isValidUser = true;
            }
        } catch (Exception ex) {
            System.out.println("LoginMember() 오류: " + ex);
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (pstmt != null)
                    pstmt.close();
                if (conn != null)
                    conn.close();
            } catch (Exception ex) {
                throw new RuntimeException(ex.getMessage());
            }
        }
        return isValidUser;
    }

    public void deleteMember(MemberDTO member) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            String sql = "delete from member where binary id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, member.getId());
            pstmt.executeUpdate();
            conn.commit();
        } catch (Exception ex) {
            System.out.println("deleteMember() 오류: " + ex);
        } finally {
            try {
                if (pstmt != null)
                    pstmt.close();
                if (conn != null)
                    conn.close();
            } catch (Exception ex) {
                throw new RuntimeException(ex.getMessage());
            }
        }
    }
}
