<?xml version="1.0"?>
  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd" />
  <xsl:template match="/">
    <xsl:variable name="totalTimeMs" select="/Requests/@totalTimeMs" />	
	<html>
		<head>
		<title>Badboy Timing Report</title>		
		<style type="text/css">
						body {
							font:normal 68% verdana,arial,helvetica;
							color:#000000;
              padding: 10px;
						}
						table tr td, table tr th {
							font-size: 9px;
						}
						h1 {
							margin: 0px 0px 5px; font: 165% verdana,arial,helvetica
						}
						h2 {
							margin-top: 1em; margin-bottom: 0.5em; font: bold 125% verdana,arial,helvetica
						}
						h3 {
							margin-bottom: 0.5em; font: bold 115% verdana,arial,helvetica
						}
            #timingTable {
              width: 90%;
            }
            #timingTable tr td a {
              text-decoration: none;
              color: black;
            }

            td.percTd,td.sizeTd,td.timeTd {
              text-align: center;
            }
            
            #timingTable tr td a:hover {
              color: red;
            }
            #timingTable div, .fullRequest {
              background-color: #ff9999;
            }

            #timingTable div {
              position: relative;
              font-size: 8px;
              padding-top:2px;
              padding-bottom:2px;
              text-align: center;
            }

            #timingTable div.fromCache, .fromCache {
              background-color: #bbffbb;
            }
            #timingTable div.notModified, .notModified {
              background-color: #ffdd99;
            }
      </style>
			<script language="javacript" type="text/javascript">
        <![CDATA[

        ]]>
      </script>		
      </head>
			<body>
        <h1>Badboy Timing Report</h1>
				<hr size="1"/>				
        <div style="float: right; margin-right: 40px;">
          <span class="fullRequest">&#160;&#160;&#160;</span> Full Request
          <span class="notModified">&#160;&#160;&#160;</span> Synchronized
          <span class="fromCache">&#160;&#160;&#160;</span> From Cache
        </div>
        <h2>HTTP Transactions </h2>
        <div id="timingTable" >
          <table width="100%" border='1' cellpadding="2">
            <tr><th>URL</th><th>%</th><th>ms</th><th>Size</th><th width="50%">Sequence</th></tr>
          <xsl:for-each select="//RequestInfo">
            <xsl:variable name="begin" select="begin" />	
            <xsl:variable name="end" select="end" />	
            <xsl:variable name="sizeKb" select="format-number((size div 1024),'#0.#')" />	
            <xsl:variable name="percentTimeMs" select="(($end - $begin) div $totalTimeMs) * 100"/>
            <xsl:variable name="prevHost" select="preceding-sibling::RequestInfo[1]/host" />	
            <xsl:variable name="prettyUrl">
              <xsl:choose>
                <xsl:when test='string-length(url) > 80'><xsl:value-of select="concat(substring(url,1,80),' ...')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="url"/></xsl:otherwise>
              </xsl:choose>
              </xsl:variable>
            <tr>
              <td>
                <a href="{url}" title="{url}">
                <xsl:choose>
                  <xsl:when test='$prevHost = host'>
                   ... <xsl:value-of select="substring-after($prettyUrl,$prevHost)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$prettyUrl"/>
                  </xsl:otherwise>
                </xsl:choose>
                </a>
              </td> 
              <td class="percTd"><xsl:value-of select="format-number($percentTimeMs,'#0.#')"/>%</td>
              <td class="timeTd"><xsl:value-of select="$end - $begin"/></td>
              <td class="sizeTd"><xsl:value-of select="$sizeKb"/>k</td>
              <td class="seqTd">
                <div title="{url} {$begin} ms to {$end} ms ({format-number($percentTimeMs,'#0.#')}%, {responseCode}, {$sizeKb} kb)" 
                     style="width: {$percentTimeMs * 0.95}%; left: { ($begin div $totalTimeMs ) * 95 }%;"
                     >
                     <xsl:choose>
                       <xsl:when test='responseCode = "304"'><xsl:attribute name="class">notModified</xsl:attribute></xsl:when>
                       <xsl:when test='fromCache = "true"'><xsl:attribute name="class">fromCache</xsl:attribute></xsl:when>
                     </xsl:choose>
                  <xsl:value-of select="$end -$begin"/> ms
                </div>
              </td>
            </tr>
          </xsl:for-each>        
        </table>
        </div>
      <br/>
			</body>
		</html>
  </xsl:template>

  <xsl:template name="row">
  </xsl:template>
</xsl:stylesheet>
