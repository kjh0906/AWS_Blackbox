<%@page import="vo.PostVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.PostDAO"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
	String search = request.getParameter("address") == null ? "뷁" : request.getParameter("address");

	PostDAO dao = new PostDAO();
	ArrayList<PostVO> list = dao.getAddress(search);
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>주소검색</title>
<style>
        .wrapper {
    z-index:1;
        position:relative;
        border-radius:5px;
        }
        .wrapper:after{
    margin-left: auto;
        width:1800px;
        height:700px;
        z-index:-1;
        position:absolute;
        content:"";
        background-image: url('/police.jpg') ;
        background-repeat:no-repeat;
        background-position:center;
        background-attachment:fixed;
        opacity: 0.2!important; filter:alpha(opacity=30);       }
    </style>
</head>
<body>
           <a href="Main.jsp"><img style="position: absolute; top: 0; left: 50; border: 0;" src="\police.jpg" width="100" height="80" alt="main"></a>
      <h1 style="margin: 20px 0; text-align: center">영상 정보 조회</h1>
      <hr>
        <div class="wrapper">
        <div class="po">

<body>
	<form action="postsearch.jsp" method="get">
		주소검색 : 
		<input type="text" name="address" />
		<input type="submit" value="검색" />
		<br>
		<br>
		<table border="1">
			<tr>
				<td width="120">블랙박스 번호</td>
				<td width="150">날짜</td>
				<td width="150">시간</td>
				<td width="400">주소</td>
				<td width="150">소유주</td>
				<td width="150">연락처</td>
				
			</tr>
			<% for(int i=0; i <list.size(); i++){ %>
			<tr>
				<td><%=list.get(i).getCname() %></td>
				<td><%=list.get(i).getDate() %></td>
				<td><%=list.get(i).getGtime() %></td>
				<td><%=list.get(i).getAddress() %></td>
				<td><%=list.get(i).getName() %></td>
				<td><%=list.get(i).getPhone() %></td>
			</tr>

			<% } %>
		</table>
	</form>
</body>
</html>