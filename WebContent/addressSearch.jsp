<%@ page contentType="text/html; charset=utf-8"%>
<html>
<head>
    <meta charset="UTF-8">
    <title>주소 검색</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <style>
        #results {
            margin-top: 10px;
            border: 1px solid #ddd;
            padding: 10px;
            max-height: 200px;
            overflow-y: auto;
            font-family: Arial, sans-serif;
            white-space: pre-wrap; 
        }
    </style>
    <script>
        function stripHtmlTags(str) {
            const doc = new DOMParser().parseFromString(str, "text/html");
            return doc.body.textContent || ""; 
        }

        function searchAddress() {
            const query = document.getElementById("query").value.trim();  

            if (!query) {
                alert("검색어를 입력하세요.");
                return;
            }

            const encodedQuery = encodeURIComponent(query);

            $.ajax({
                url: "/JavaMapProject/searchAddress", 
                type: "GET",
                data: { query: encodedQuery },  
                success: function(response) {
                    console.log("응답 데이터:", response);  

                    const results = response.items ? response.items : []; 
                    const resultContainer = document.getElementById("results");
                    resultContainer.innerHTML = ""; 

                    if (results.length === 0) {
                        resultContainer.textContent = "검색 결과가 없습니다.";
                        return;
                    }

                    let resultText = "";
                    results.forEach(function(item) {
                        const title = stripHtmlTags(item.title).trim();  
                        let address = item.roadAddress || item.address || "주소 정보 없음";  
                        address = stripHtmlTags(address).trim();  

                        if (title && address) {
                            resultText += '<div onclick="selectAddress(\'' + address + '\')">' + title + ' (' + address + ')</div><br>';
                        } else {
                            console.log("title 또는 address가 비어 있음");
                        }

                    });

                    if (resultText) {
                        resultContainer.innerHTML = resultText;  
                    } else {
                        resultContainer.textContent = "검색 결과가 없습니다.";  
                    }

                },
                error: function() {
                    alert("주소 검색에 실패했습니다.");
                }
            });
        }

        function selectAddress(address) {
            console.log("선택한 주소:", address);
            if (window.opener && typeof window.opener.setAddress === "function") {
                window.opener.setAddress(address); 
                window.close(); 
            } else {
                alert("부모 창에서 setAddress 함수를 찾을 수 없습니다.");
            }
        }
    </script>
</head>
<body>
    <h1>주소 검색</h1>
    <div>
        <input type="text" id="query" placeholder="검색어 입력">
        <button type="button" onclick="searchAddress()">검색</button>
    </div>
    <div id="results"></div>
</body>
</html>
