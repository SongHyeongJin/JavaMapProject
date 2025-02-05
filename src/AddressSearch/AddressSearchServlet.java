package AddressSearch;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/searchAddress")
public class AddressSearchServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String CLIENT_ID = "JoxriGzQDF3vTm4CogG9";

    private static final String CLIENT_SECRET = "K4e32vcPyc";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            java.io.IOException {

        String query = request.getParameter("query");

        if (query != null) {
            query = java.net.URLDecoder.decode(query, "UTF-8");
        }

        if (query == null || query.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"검색어를 입력하세요.\"}");
            return;
        }

        String apiUrl = "https://openapi.naver.com/v1/search/local.json?query="
                + java.net.URLEncoder.encode(query, "UTF-8") + "&display=5";

        URL url = new URL(apiUrl);
        HttpURLConnection connection = (HttpURLConnection)url.openConnection();
        connection.setRequestMethod("GET");
        connection.setRequestProperty("X-Naver-Client-Id", CLIENT_ID);
        connection.setRequestProperty("X-Naver-Client-Secret", CLIENT_SECRET);

        int responseCode = connection.getResponseCode();
        BufferedReader br;

        if (responseCode == 200) {
            br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
        } else {
            br = new BufferedReader(new InputStreamReader(connection.getErrorStream(), "UTF-8"));
        }

        StringBuilder result = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            result.append(line);
        }
        br.close();

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().write(result.toString());
    }
}
