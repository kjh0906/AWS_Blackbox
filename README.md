# AWS_Blackbox

본 프로젝트는 블랙박스통합관제 서비스 구현 프로젝트입니다.
로그인 로그아웃의 서비스 구현은 팀원과 분배하였고 블랙박스의 GPS정보와 소유주의 정보를 검색할 수 있는 DB 검색 웹페이지를 구현하였습니다.

PostDAO.java 파일은 RDS(DB)와 연동하여 검색 기능을 위한 java 파일입니다
JNDI 방식을 통해 WAS단에 데이터 풀을 생성하여 DB에 접속이 유지되도록 구현 하였습니다. 

PostVO.java 파일은 블랙박스 데이터 값을 저장하기 위한 java 파일입니다
postsearch.jsp 파일은 블랙박스 데이터 정보를 제공하는 페이지입니다.

==============================================================
해당 웹페이지를 구현 하기 위하여 우분투 기반의 AWS EC2 인스턴스에 각각 아파치 톰캣을 설치 하였습니다.
이후 mod_jk 모듈을 사용하여 워커파일을 생성하였으며 

=======================================

worker.list=tomcat
worker.tomcat.port = 8009
worker.tomcat.host = 192.168.40.4
worker.tomcat.type = ajp13
worker.tomcat.lbfactor = 1

=======================================

위와 같이 구현 하였습니다. 아파치가 "tomcat"이라는 워커의 8009번 포트로 접속하여 Tomcat의 private IP(192.168.40.4)로 연결 되도록 설정하였습니다.


이후 jk.conf에서 워커파일 적용 코드를 다음과 같이 설정하였습니다

=================================================================================

#JkWorkersFile /etc/libapache2-mod-jk/workers.properties(기존 워커파일 주석처리)
JkWorkersFile /etc/apache2/workers.properties

=================================================================================

아파치 모듈을 설정한 이후 톰캣 WAS단에 데이터베이스 커넥션 객체를 미리 네이밍 해주는 JNDI방식을 사용하기 위해
server.xml 파일을 다음과 같이 설정해 주었습니다.

=================================================================================

<Resource auth="Container"
        driverClassName="com.mysql.jdbc.Driver" maxTotal="100" maxIdle="30"
        maxWait="10000" name="jdbc/gpsdb" password="qwer1234"
        type="javax.sql.DataSource"
    url="jdbc:mysql://gps-db.cmaaxaikkra9.ap-northeast-2.rds.amazonaws.com/gpsdb?useUnicode=true&amp;characterEncoding=utf8&amp;autoReconnect=true"
        username="admin" validationInterval="30000"
        validationQuery="SELECT 1" />

=================================================================================

그리고 context.xml 파일도 다음과 같이 수정해주었습니다.

=================================================================================

<Resource name="jdbc/gpsdb" auth="Container"
            type="javax.sql.DataSource" username="admin" password="qwer1234"
        driverClassName="com.mysql.jdbc.Driver"
        url="jdbc:mysql://gps-db.cmaaxaikkra9.ap-northeast-2.rds.amazonaws.com/gpsdb?useUnicode=true&amp;characterEncoding=utf8&amp;autoReconnect=true"
        maxTotal="100" maxIdle="30" maxWait="-1" />

=================================================================================

마지막으로 web.xml 파일을 다음과 같이 수정 한 후 Apache & Tomcat & RDS 연동을 끝마쳤습니다.

=================================================================================

<resource-ref>
        <description>DB Connection</description>
        <res-ref-name>jdbc/gpsdb</res-ref-name>
        <res-type>javax.sql.DataSource</res-type>
        <res-auth>Container</res-auth>
</resource-ref>

=================================================================================
