<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@include file="connection_1.jsp"%>
<%
Class.forName("org.postgresql.Driver");
Connection CON = null;
ResultSet rs = null;
Statement stm = null;
ResultSet rs2 = null;
Statement stm2 = null;

StringBuffer sb = new StringBuffer("");
String SQL = "";
try{

  if(DB_URL==null || UN==null || PW==null){
  	throw new Exception("The session of the database connection was expired. Please, refresh the web page.");
  }
  CON = DriverManager.getConnection(DB_URL,UN,PW);
        
  String INDEX = request.getParameter("index");
  if(INDEX==null || "".equals(INDEX)){
    throw new Exception("index not found...");
  }else if(INDEX.equals("identify")){
    String x = request.getParameter("x");
    String y = request.getParameter("y");
    String utm_res = request.getParameter("utm_res");
    String geo_res = request.getParameter("geo_res");
    String dd = request.getParameter("dd");

    String pixels = "9";
    String point32647 = "st_transform(st_geomfromtext('POINT("+x+" "+y+")',4326),32647)";
    String point4326 = "st_geomfromtext('POINT("+x+" "+y+")',4326)";
    String hotspot_ass6 = "";

    //Hotspot
    SQL = "select *,st_distance("+point4326+",geom) as dist "+
    " from hotspot_ass6"+
    " where st_intersects(st_buffer("+point4326+","+geo_res+"*"+pixels+"),geom)=TRUE and acq_date='"+dd+"' "+
    " order by dist asc "+
    " limit 1 ";

    stm = CON.createStatement();
    rs = stm.executeQuery(SQL);
    JSONObject jo = new JSONObject();

    if(rs.next()){
      jo.put("frp",rs.getString("frp"));
      jo.put("brightness",rs.getString("bright_ti4"));
      jo.put("acq_date",rs.getString("acq_date"));
      jo.put("acq_time",rs.getString("acq_time"));
      out.print("{\"data\":"+jo.toJSONString()+",\"name\":\"hotspot\"}");

    }else{
      // Tambon
      SQL = "select *,st_distance("+point4326+",geom) as dist "+
      " from tambon"+
      " where st_intersects(st_buffer("+point4326+","+geo_res+"*"+pixels+"),geom)=TRUE"+
      " order by dist asc "+
      " limit 1 ";
      rs = stm.executeQuery(SQL);
      if(rs.next()){
        jo.put("province_name",rs.getString("pv_en"));
        jo.put("tambon_name",rs.getString("tb_en"));
        jo.put("amphoe_name",rs.getString("ap_en"));
        out.print("{\"data\":"+jo.toJSONString()+",\"name\":\"tambon\"}");
              
      }else{
        out.print("{\"data\":"+jo.toJSONString()+",\"name\":\"\"}");
      }
    }
    jo = null;
    rs.close();rs=null;
    stm.close();stm=null;


  
  }else if(INDEX.equals("get_date")){
   SQL = "select distinct acq_date"+
   " from hotspot_ass6"+
   " order by acq_date DESC";
  
  stm = CON.createStatement();
  rs = stm.executeQuery(SQL);
  JSONArray ja = new JSONArray();

  while(rs.next()){
    ja.add(rs.getString("acq_date"));
  }
  out.print("{\"data\":"+ja.toJSONString()+"}");


  }else{
    throw new Exception(INDEX+" do not match any function...");
  }

}catch(Exception ex){
	String er = ex.getMessage();
	if(er==null || er=="") er = "No applicable code";
	er = er.replaceAll("\"","").replaceAll("\\n","");
	out.print("{\"exception\":\""+er+"\"}");
}finally{
	if(CON!=null) CON.close();
  CON=null;
}
%>
