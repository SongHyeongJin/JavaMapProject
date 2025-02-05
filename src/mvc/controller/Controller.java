package mvc.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvc.model.MemberDAO;
import mvc.model.MemberDTO;
import mvc.model.RecordDAO;
import mvc.model.RecordDTO;

@WebServlet("*.do")
public class Controller extends HttpServlet {

    private static final long serialVersionUID = 1L;

    static final int LISTCOUNT = 5;

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String RequestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String command = RequestURI.substring(contextPath.length());
        response.setContentType("text/html; charset=utf-8");
        request.setCharacterEncoding("utf-8");
        RequestDispatcher rd = null;
        switch (command) {
            case "/Welcome.do":
                requestallRecordList(request);
                rd = request.getRequestDispatcher("/Welcome.jsp");
                rd.forward(request, response);
                break;
            case "/RecordListAction.do":
                requestRecordList(request);
                rd = request.getRequestDispatcher("/record/list.jsp");
                rd.forward(request, response);
                break;
            case "/RecordWriteAction.do":
                rd = request.getRequestDispatcher("/record/writeForm.jsp");
                rd.forward(request, response);
                break;
            case "/RecordAction.do":
                requestRecordWrite(request);
                rd = request.getRequestDispatcher("/RecordListAction.do");
                rd.forward(request, response);
                break;
            case "/RecordViewAction.do":
                requestRecordView(request);
                rd = request.getRequestDispatcher("/RecordView.do");
                rd.forward(request, response);
                break;
            case "/RecordView.do":
                rd = request.getRequestDispatcher("/record/view.jsp");
                rd.forward(request, response);
                break;
            case "/RecordUpdateAction.do":
                requestRecordUpdate(request);
                rd = request.getRequestDispatcher("/RecordListAction.do");
                rd.forward(request, response);
                break;
            case "/RecordDeleteAction.do":
                requestRecordDelete(request);
                rd = request.getRequestDispatcher("/RecordListAction.do");
                rd.forward(request, response);
                break;
            case "/member/AddMember.do":
                requestAddMember(request);
                rd = request.getRequestDispatcher("../member/resultMember.jsp?msg=1");
                rd.forward(request, response);
                break;
            case "/member/UpdateMember.do":
                requestUpdateMember(request);
                rd = request.getRequestDispatcher("../member/resultMember.jsp?msg=0");
                rd.forward(request, response);
                break;
            case "/member/LoginMember.do":
                if (requestLoginMember(request)) {
                    rd = request.getRequestDispatcher("../member/resultMember.jsp?msg=2");
                } else {
                    rd = request.getRequestDispatcher("../member/loginMember.jsp?error=1");
                }
                rd.forward(request, response);
                break;
            case "/member/LogoutMember.do":
                requestLogoutMember(request);
                rd = request.getRequestDispatcher("/member/loginMember.jsp");
                rd.forward(request, response);
                break;
            case "/member/deleteMember.do":
                requestDeleteMember(request);
                rd = request.getRequestDispatcher("../member/resultMember.jsp?msg=3");
                rd.forward(request, response);
                break;

        }
    }

    public void requestallRecordList(HttpServletRequest request) {
        RecordDAO dao = RecordDAO.getInstance();
        List<RecordDTO> allrecordlist = new ArrayList<RecordDTO>();
        String id = (String)request.getSession().getAttribute("sessionId");
        allrecordlist = dao.getAllRecordList(id);
        request.setAttribute("allrecordlist", allrecordlist);
        request.setAttribute("sessionId", id);
    }

    public void requestRecordList(HttpServletRequest request) {
        RecordDAO dao = RecordDAO.getInstance();
        List<RecordDTO> recordlist = new ArrayList<RecordDTO>();
        List<RecordDTO> allrecordlist = new ArrayList<RecordDTO>();

        int pageNum = 1;
        int limit = LISTCOUNT;

        if (request.getParameter("pageNum") != null)
            pageNum = Integer.parseInt(request.getParameter("pageNum"));

        String items = request.getParameter("items");
        String text = request.getParameter("text");

        String id = (String)request.getSession().getAttribute("sessionId");
        int total_record = dao.getListCount(items, text, id);
        recordlist = dao.getRecordList(pageNum, limit, items, text, id);
        allrecordlist = dao.getAllRecordList(id);

        int total_page;

        if (total_record % limit == 0) {
            total_page = total_record / limit;
        } else {
            total_page = total_record / limit + 1;
        }

        request.setAttribute("pageNum", pageNum);
        request.setAttribute("total_page", total_page);
        request.setAttribute("total_record", total_record);
        request.setAttribute("recordlist", recordlist);
        request.setAttribute("allrecordlist", allrecordlist);
        request.setAttribute("sessionId", id);
    }

    public void requestRecordWrite(HttpServletRequest request) {
        RecordDAO dao = RecordDAO.getInstance();

        RecordDTO record = new RecordDTO();
        record.setId(request.getParameter("id"));
        record.setAddress(request.getParameter("address"));
        record.setLat(Double.parseDouble(request.getParameter("lat")));
        record.setLng(Double.parseDouble(request.getParameter("lng")));
        record.setSubject(request.getParameter("subject"));
        record.setContext(request.getParameter("context"));
        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String Date = formatter.format(new java.util.Date());

        record.setDate(Date);

        dao.insertRecord(record);

    }

    public void requestRecordView(HttpServletRequest request) {

        RecordDAO dao = RecordDAO.getInstance();
        int num = Integer.parseInt(request.getParameter("num"));
        int pageNum = Integer.parseInt(request.getParameter("pageNum"));

        RecordDTO record = new RecordDTO();
        record = dao.getRecordByNum(num, pageNum);

        request.setAttribute("num", num);
        request.setAttribute("page", pageNum);
        request.setAttribute("record", record);
    }

    public void requestRecordUpdate(HttpServletRequest request) {

        int num = Integer.parseInt(request.getParameter("num"));

        RecordDAO dao = RecordDAO.getInstance();

        RecordDTO record = new RecordDTO();
        record.setNum(num);
        record.setAddress(request.getParameter("address"));
        record.setLat(Double.parseDouble(request.getParameter("lat")));
        record.setLng(Double.parseDouble(request.getParameter("lng")));
        record.setSubject(request.getParameter("subject"));
        record.setContext(request.getParameter("content"));

        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String Date = formatter.format(new java.util.Date());

        record.setDate(Date);

        dao.updateRecord(record);
    }

    public void requestRecordDelete(HttpServletRequest request) {

        int num = Integer.parseInt(request.getParameter("num"));

        RecordDAO dao = RecordDAO.getInstance();
        dao.deleteRecord(num);
    }

    public void requestAddMember(HttpServletRequest request) {
        MemberDAO dao = MemberDAO.getInstance();
        MemberDTO member = new MemberDTO();
        member.setId(request.getParameter("id"));
        member.setPassword(request.getParameter("password"));
        member.setName(request.getParameter("name"));
        dao.addMember(member);
    }

    public void requestUpdateMember(HttpServletRequest request) {
        String id = (String)request.getSession().getAttribute("sessionId");
        MemberDAO dao = MemberDAO.getInstance();
        MemberDTO member = new MemberDTO();
        member.setId(id);
        member.setPassword(request.getParameter("password"));
        member.setName(request.getParameter("name"));
        dao.updateMember(member);
    }

    public boolean requestLoginMember(HttpServletRequest request) {
        String id = request.getParameter("id");
        String password = request.getParameter("password");

        MemberDAO dao = MemberDAO.getInstance();
        boolean isValidUser = dao.LoginMember(id, password);

        if (isValidUser) {
            request.getSession().setAttribute("sessionId", id);
        }

        return isValidUser;
    }

    public void requestLogoutMember(HttpServletRequest request) {
        request.getSession().invalidate();
    }

    public void requestDeleteMember(HttpServletRequest request) {
        String id = (String)request.getSession().getAttribute("sessionId");
        MemberDAO dao = MemberDAO.getInstance();
        MemberDTO member = new MemberDTO();
        member.setId(id);
        dao.deleteMember(member);
        request.getSession().invalidate();
    }

}