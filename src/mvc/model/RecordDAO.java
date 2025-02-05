package mvc.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import mvc.database.DBConnection;

public class RecordDAO {

    private static RecordDAO instance;

    private RecordDAO() {}

    public static RecordDAO getInstance() {
        if (instance == null)
            instance = new RecordDAO();
        return instance;
    }

    public int getListCount(String items, String text, String id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int x = 0;
        String sql;
        if (items == null && text == null) {
            sql = "SELECT count(*) FROM record WHERE binary id = ?";
        } else {
            sql = "SELECT count(*) FROM record WHERE binary id = ? AND " + items + " LIKE ?";
        }
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            if (items != null && text != null) {
                pstmt.setString(2, "%" + text + "%");
            }

            rs = pstmt.executeQuery();

            if (rs.next()) {
                x = rs.getInt(1);
            }
        } catch (Exception ex) {
            System.out.println("getListCount() 오류: " + ex);
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
        return x;
    }

    public ArrayList<RecordDTO> getRecordList(int page, int limit, String items, String text, String id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int total_record = getListCount(items, text, id);
        int start = (page - 1) * limit;
        int index = start + 1;
        String sql;
        if (items == null && text == null) {
            sql = "SELECT * FROM record WHERE binary id = ? ORDER BY num DESC LIMIT ?, ?";
        } else {
            sql = "SELECT * FROM record WHERE binary id = ? AND " + items + " LIKE ? ORDER BY num DESC LIMIT ?, ?";
        }
        ArrayList<RecordDTO> list = new ArrayList<RecordDTO>();
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            if (items != null && text != null) {
                pstmt.setString(2, "%" + text + "%");
                pstmt.setInt(3, start);
                pstmt.setInt(4, limit);
            } else {
                pstmt.setInt(2, start);
                pstmt.setInt(3, limit);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                RecordDTO record = new RecordDTO();
                record.setNum(rs.getInt("num"));
                record.setId(rs.getString("id"));
                record.setAddress(rs.getString("address"));
                record.setLat(rs.getDouble("lat"));
                record.setLng(rs.getDouble("lng"));
                record.setDate(rs.getString("Date"));
                record.setSubject(rs.getString("subject"));
                record.setContext(rs.getString("context"));
                list.add(record);
                if (index < (start + limit) && index <= total_record)
                    index++;
                else
                    break;
            }
            return list;
        } catch (Exception ex) {
            System.out.println("getRecordList() 오류: " + ex);
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
        return null;
    }

    public ArrayList<RecordDTO> getAllRecordList(String id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM record WHERE binary id = ? ORDER BY num DESC";
        ArrayList<RecordDTO> list = new ArrayList<RecordDTO>();
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                RecordDTO record = new RecordDTO();
                record.setNum(rs.getInt("num"));
                record.setId(rs.getString("id"));
                record.setAddress(rs.getString("address"));
                record.setLat(rs.getDouble("lat"));
                record.setLng(rs.getDouble("lng"));
                record.setDate(rs.getString("Date"));
                record.setSubject(rs.getString("subject"));
                record.setContext(rs.getString("context"));
                list.add(record);
            }
            return list;
        } catch (Exception ex) {
            System.out.println("getRecordList() 오류: " + ex);
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
        return null;
    }

    public void insertRecord(RecordDTO record) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "insert into record values (?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, record.getNum());
            pstmt.setString(2, record.getId());
            pstmt.setString(3, record.getAddress());
            pstmt.setDouble(4, record.getLat());
            pstmt.setDouble(5, record.getLng());
            pstmt.setString(6, record.getDate());
            pstmt.setString(7, record.getSubject());
            pstmt.setString(8, record.getContext());
            pstmt.executeUpdate();
        } catch (Exception ex) {
            System.out.println("insertRecord() 오류: " + ex);
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

    public RecordDTO getRecordByNum(int num, int page) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        RecordDTO record = null;
        String sql = "select * from record where num = ?";
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                record = new RecordDTO();
                record.setNum(rs.getInt("num"));
                record.setId(rs.getString("id"));
                record.setAddress(rs.getString("address"));
                record.setLat(rs.getDouble("lat"));
                record.setLng(rs.getDouble("lng"));
                record.setDate(rs.getString("Date"));
                record.setSubject(rs.getString("subject"));
                record.setContext(rs.getString("context"));
            }
            return record;
        } catch (Exception ex) {
            System.out.println("getRecordByNum() 오류: " + ex);
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
        return null;
    }

    public void updateRecord(RecordDTO record) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            String sql = "update record set address = ?, lat =? , lng= ?, subject = ?, context = ?, Date=? where num = ?";
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            conn.setAutoCommit(false);
            pstmt.setString(1, record.getAddress());
            pstmt.setDouble(2, record.getLat());
            pstmt.setDouble(3, record.getLng());
            pstmt.setString(4, record.getSubject());
            pstmt.setString(5, record.getContext());
            pstmt.setString(6, record.getDate());
            pstmt.setInt(7, record.getNum());
            pstmt.executeUpdate();
            conn.commit();
        } catch (Exception ex) {
            System.out.println("updateRecord() 오류: " + ex);
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

    public void deleteRecord(int num) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "delete from record where num = ?";
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            pstmt.executeUpdate();
        } catch (Exception ex) {
            System.out.println("deleteRecord() 오류: " + ex);
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
