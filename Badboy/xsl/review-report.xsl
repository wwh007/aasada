<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes" encoding="US-ASCII" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/DTD/strict.dtd"  />
<xsl:variable name="fileName" select="translate( /WebScript/Variables/name[string()  = 'badboy.saveItemRelFileName' ]/following-sibling::*[1],'\','/') " />	
<xsl:variable name="scriptFileName" select="translate( /WebScript/Variables/name[string()  = 'badboy.scriptFileName' ]/following-sibling::*[1],'\','/') " />	
<xsl:variable name="saveDateTime" select="/WebScript/Variables/name[string()  = 'badboy.saveDateTime' ]/following-sibling::*[1]" />	
<xsl:param name="imagesPath"><xsl:value-of select="$fileName"/>-images</xsl:param>

  <xsl:template match="/">
  <xsl:variable name="failureCount" select="number(concat('0',/WebScript/Script/Summary/failed))" />
	<xsl:variable name="totalPlayed" select="number(concat('0',/WebScript/Script/Summary/played))" />	
	<xsl:variable name="successCount" select="number(concat('0',/WebScript/Script/Summary/succeeded))" />	
	<xsl:variable name="assertionCount" select="number(concat('0',/WebScript/Script/Summary/assertions))" />	
  <xsl:variable name="warningsCount" select="number(concat('0',/WebScript/Script/Summary/warnings))"/>
	<xsl:variable name="successPercentage" select="$successCount div $totalPlayed" />	
  <xsl:variable name="allFailureCount" select="count(descendant::Response[Summary/failed != '0'])"/>
  <!--
  <xsl:variable name="warningsCount" select="count(descendant::ResponseError)"/>
  <xsl:variable name="assertionCount" select="count(descendant::AssertionFailure)"/>
  -->
  <xsl:variable name="screenShotCount" select="count(descendant::CaptureItem[../../flagForReview='true'])"/>
	<html> 
		<head>
		<META http-equiv="Content-Type" content="text/html; charset=US-ASCII"/>
		<title>Badboy Test Results</title>		
		<style type="text/css">
						body {
							font:normal 68% verdana,arial,helvetica;
							color:#000000;
						}

            .reviewBox {
              border: solid 1px #777;
              margin: 4px 4px 10px 4px;
              padding: 0px 5px 5px 5px;
              background-color: #f6f6f6;
            }
            .reviewTitle {
              margin: 0px -5px 0px -5px;
              padding: 1px 4px;
              background-color: #bba;
              color: white;
            }

						table tr td, table tr th {
							font-size: 88%;
						}
						table.details tr th{
							font-weight: bold;
							text-align:left;
							background: #f0f0f0;
							white-space: nowrap;
						}

						table.details tr td{
							background: white;
							white-space: nowrap;
						}

						table.detailsRowHighlight tr {
							background:#ffeee0;
						}

						table.detailsRowNormal tr {
							background:#eeeee0;
						}

						table.detailsCentered tr td{
              text-align: center;
						}

            #treeCellInner {
              background-color: white;
              float: left;
            }
 
            table#overviewTable tr td.warnings {
              color: #b50;
            }
            table#overviewTable tr td.warnings.leaf {
              color: #c50;
              background-color: #ffeeaa;
            }

            table#overviewTable tr:hover td.total {
							background-color:#f5f5f0;
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
						.Failure {
							font-weight:bold; color:red;
						}
            .Centered {
              text-align: center;
            }

            a:link.FailureLink {
              color: red;
            }
	          a:visited.FailureLink {
              color: red;
            }


            .summaryBlock {
              position: absolute;
              right: 0px; file:///C:/Users/ssadedin/Desktop/deleteme.html
              top: 0px;
            }

            .stepImage {
              position: relative;  
              margin-right: 3px;
            }

            .bigSuccess {
              color: green;
              font-size: 20px;
            }

            .bigFailure {
              color: red;
              font-size: 20px;
            }

            .bigWarning {
              color: orange;
              font-size: 20px;
            }
            .hidden {
              display: none;
            }
            .highlighted {
              font-weight: bold;
              color: red;
            }
            .highlighted td {
              background-color: #fff0e8 !important;
            }

      </style>
			<script language="javacript" type="text/javascript">
        var imagesPath='<xsl:value-of select="translate($fileName,'\','/')"/>-images';
      <![CDATA[
      function init() {
      }

      function hide(id) { if($(id)) $(id).style.display = 'none'; }
      function show(id) { if($(id)) $(id).style.display = 'block'; }

        ]]>
      </script>		
      </head>
			<body onload='init();'>
        <h1>Review Report for <xsl:value-of select="$scriptFileName"/></h1>
        Report created <xsl:value-of select="$saveDateTime"/>
				<hr size="1"/>				
				<table width="95%" cellspacing="2" cellpadding="5" border="0" class="details detailsCentered">
					<tr valign="top">
						<th>Total Played</th>
						<th>Succeeded</th>
						<th>Failed</th>
            <th>Warnings</th>
						<th>Assertions</th>
						<th>Average Time</th>
						<th>Max Time</th>
					</tr>
					<tr valign="top" class="">
						<td><xsl:value-of select="$totalPlayed"/></td>
						<td><xsl:value-of select="$successCount"/></td>						
						<td><xsl:value-of select="$failureCount"/></td>						
						<td><xsl:value-of select="$warningsCount"/></td>						
						<td><xsl:value-of select="$assertionCount"/></td>						
						<td><xsl:value-of select="round(/WebScript/Script/Summary/averageResponseTime)"/></td>
						<td><xsl:value-of select="/WebScript/Script/Summary/maxResponseTime"/></td>
					</tr>
				</table>

        <xsl:choose>
          <xsl:when test='count(//CaptureItem[number(concat("0",Summary/reviews)) >= 1])'>
          <p class="bigWarning">Items Flagged for Review</p>

          <p>The following items require manual review to ensure they performed correctly.</p>

          <table width="95%" cellspacing="2" cellpadding="5" border="0" class="details">
              <tr valign="top">
                <th width="10%">Path</th>
                <th width="60%">Details and Screen Shot</th>
              </tr>
              <xsl:for-each select='//CaptureItem[number(concat("0",Summary/reviews)) >= 1]'>
                  <xsl:call-template name="ScreenShotLineItem"/>
              </xsl:for-each>					
            </table>
          </xsl:when>
          <xsl:otherwise>
          <p class="bigSuccess">No Items Flagged for Review</p>
          </xsl:otherwise>
      </xsl:choose>
      <hr/>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="ScreenShotLineItem">
      <tr valign="top" class="">
      <td>
        <b>Id</b> &#160; <xsl:value-of select="id"/>
        <p>
        <img>
          <xsl:attribute name='src'><xsl:value-of select="$imagesPath"/>/testitemicon.gif</xsl:attribute>
        </img>
        &#160;
          <xsl:value-of select="ancestor::TestItem/title"/> <xsl:value-of select="ancestor::TestItem/itemName"/> </p>
          <p><b>Path</b></p>
        <p><xsl:call-template name='ItemPath'/></p>
      </td>
      <td class='reviewCell'>

        <div class='reviewBox'>
          <div class='reviewTitle'>
          <xsl:choose>
            <xsl:when test='../../itemName != ""'>
              <xsl:value-of select="../../itemName"/>
            </xsl:when>
            <xsl:otherwise>
              Screen Shot for Review
            </xsl:otherwise>
          </xsl:choose>
        </div>
          <xsl:value-of select="../../documentation" disable-output-escaping="yes"/>
          <br/>
          <img border="0">
            <xsl:attribute name="src"><xsl:value-of select="$imagesPath"/>/badboy-<xsl:value-of select="id"/>.png</xsl:attribute>
          </img>
        </div>
      </td>				
    </tr>		
	</xsl:template>

  <xsl:template name="ItemPath">
     <xsl:param name="depth">0</xsl:param>
     <xsl:param name="n" select="../.."/>

     <xsl:if test='$n/id != "" '>
       <xsl:call-template name="ItemPath">
         <xsl:with-param name="n" select="$n/../.."/>
         <xsl:with-param name="depth" select="$depth + 1"/>
       </xsl:call-template> 
     </xsl:if>

     <xsl:variable name='label'><xsl:choose>
             <xsl:when test='$n/name'><xsl:value-of select="$n/name"/></xsl:when>
             <xsl:when test='$n/title'><xsl:value-of select="$n/title"/></xsl:when>
             <xsl:when test='$n/itemName != ""'><xsl:value-of select="$n/itemName"/></xsl:when>
             <xsl:otherwise>
               <xsl:if test='local-name($n) = "SuiteItem"'>
                 Test Suite
               </xsl:if>
             </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>


     <xsl:variable name='parents' select='count($n/ancestor::*)-3'/>

     <xsl:if test='$n/id != "" '>
       <xsl:if test='$label != ""'>
       <ul style='margin-left: {$parents*10 - 10}px;'>
         <li>
           <xsl:value-of select='$label'/> 
         </li>
       </ul>
       </xsl:if>
     </xsl:if>

     <xsl:if test='$n/id != "" '>

     </xsl:if>
  </xsl:template>

  <!-- Utility function -->
  <xsl:template name="wrap_text">
  <xsl:param name="text"/>
  <xsl:param name="width" select="40"/>

  <xsl:if test="string-length($text)">
    <xsl:value-of select="substring($text, 1, $width)"/>
    <xsl:if test="string-length($text)>$width"><br/></xsl:if>
    <xsl:call-template name="wrap_text">
      <xsl:with-param name="text"
       select="substring($text, $width + 1)"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
  </xsl:if>  	
  </xsl:template>

  <xsl:template name="trunc">
    <xsl:param name="text"/>
    <xsl:param name='width' select='20'/>
    <xsl:choose>
      <xsl:when test="string-length($text)>$width">
        <xsl:value-of select="concat(substring($text,0,$width - 4),'...')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>  	
  </xsl:template>

</xsl:stylesheet>
