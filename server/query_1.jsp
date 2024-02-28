<%@page contentType="text/html" pageEncoing="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@include file="connection_1.jsp"%>
<%
Class.forName("org.postgresql.Driver");
Connection CON = null;
ResultSet rs = null;
Statement stm = null;

String DB_URL = "jdbc:postgresql://localhost:5432";
String UN = "postgres"
String PW = "fernkus42"

StringBuffer sb = new StringBuffer("");
String SQL ="";
try{

  if(DB_URL==null || UN==null || PW==null){
  	throw new Exception("The session of the database connection was expired. Please, refresh the web page.");
  }
CON = DriverManager.getConnection(DB_URL,UN,PW);

String acq_date = request.getParameter("acq_date")

stm = CON.createStatement();
rs = stm.execteQuery(
"select latitude from hotspot_ass6 where frp>30 '%" +acq_date+"%'"
);
if(rs.next()){
	out.print("{'latitude':"+rs.getString("latitude")+"}");
}else{
	out.print("{}");
}
rs.close();rs=null;
stm.close();stm=null;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
