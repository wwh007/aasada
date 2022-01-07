<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes" encoding="US-ASCII" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/DTD/strict.dtd"  />
<xsl:variable name="fileName" select="translate( /WebScript/Variables/name[string()  = 'badboy.saveItemRelFileName' ]/following-sibling::*[1],'\','/') " />	
<xsl:variable name="saveDateTime" select="/WebScript/Variables/name[string()  = 'badboy.saveDateTime' ]/following-sibling::*[1]" />	

  <xsl:template match="/">
  <xsl:variable name="failureCount" select="number(concat('0',/WebScript/Script/Summary/failed))" />
	<xsl:variable name="totalPlayed" select="number(concat('0',/WebScript/Script/Summary/played))" />	
	<xsl:variable name="successCount" select="number(concat('0',/WebScript/Script/Summary/succeeded))" />	
	<xsl:variable name="assertionCount" select="number(concat('0',/WebScript/Script/Summary/assertions))" />	
  <xsl:variable name="warningsCount" select="number(concat('0',/WebScript/Script/Summary/warnings))"/>
	<xsl:variable name="successPercentage" select="$successCount div $totalPlayed" />	
  <xsl:variable name="allFailureCount" select="count(descendant::Response[Summary/failed != '0'])"/>
	<html>
		<head>
		<META http-equiv="Content-Type" content="text/html; charset=US-ASCII"/>
		<title>Badboy Test Summary</title>		
		<style type="text/css">
						body {
							font:normal 68% verdana,arial,helvetica;
							color:#000000;
						}
						table tr td, table tr th {
							font-size: 88%;
						}
						table.details tr th{
							font-weight: bold;
							text-align:left;
							background:#a6caf0;
							white-space: nowrap;
						}

						table.details tr td{
							background:#eeeee0;
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

            table tr td.treeCell {
              padding: 0px;
              background: url("<xsl:value-of select='$fileName'/>-images/dot.gif") repeat-x right 80%;
            }

            table#overviewTable tr td.failed {
              color: red;
            }

						h1 {
							margin: 0px 0px 5px; font: 165% verdana,arial,helvetica
						}
						h2 {
							margin-top: 1em; margin-bottom: 0.5em; font: bold 125% verdana,arial,helvetica
						}
            .summaryBlock {
              position: absolute;
              right: 0px; 
              top: 0px;
            }

            .stepImage {
              position: relative;  
              margin-right: 3px;
            }


            .headerCell {
              width: 40px;
              padding: 3px 2px;
              font-weight: bold;
              font-size: 10px;
              background: #a6caf0;
              white-space: nowrap;
              margin: 0px 2px;
              text-align: center;
            }

             .total {
              position: relative;
              top: 1px;
              width: 42px;
              background-color:#eeeee0;
              margin-top: 0px;
              margin-bottom: 0px;
              margin-left: 2px;
              margin-right: 2px;
              text-align: center;
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
      </style>
			<script language="javacript" type="text/javascript">
        var imagesPath='<xsl:value-of select="translate($fileName,'\','/')"/>-images';
      <![CDATA[

        ]]>
      </script>		
      </head>
			<body>
        <h1>Badboy Test Summary</h1>
        Report created <xsl:value-of select="$saveDateTime"/>
				<hr size="1"/>				
				<h2>Overview</h2>
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

        <!-- If everything passed, show a "success"  -->
        <xsl:choose>
          <xsl:when test=' $totalPlayed = $successCount and $warningsCount = 0 and $assertionCount = 0 and $failureCount = 0'>
            <p class="bigSuccess">Success</p>
          </xsl:when>
          <xsl:when test=' $totalPlayed = $successCount and $warningsCount != 0 and $assertionCount = 0 and $failureCount = 0'>
            <p class="bigWarning">Passed with Warnings</p>
          </xsl:when>
          <xsl:otherwise>
            <p class="bigFailure">Test Failed</p>
          </xsl:otherwise>
        </xsl:choose>

        <hr align="left" width="95%" size="1"/>
        <h2>Script Summary</h2>
        <table style="position: relative; width: 95%" id="overviewTable">
          <thead>
            <tr>
              <td width='500px'>&#160;</td>
              <td>&#160;</td>
              <td class="headerCell"><div>Total</div></td> 
              <td class="headerCell"><div>Succ</div></td> 
              <td class="headerCell"><div>Fail</div></td> 
              <td class="headerCell"><div>Wrn</div></td> 
              <td class="headerCell"><div>Asst</div></td> 
              <td class="headerCell"><div>Avg</div></td> 
              <td class="headerCell"><div>Max</div></td> 
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="/WebScript/Script/ChildItems/*[local-name()='Step' or local-name()='TestItem' or local-name()='SuiteItem']">
              <xsl:if test='disabled != "true"'>
                  <xsl:call-template name="Step"/>
              </xsl:if>
            </xsl:for-each>        
          </tbody>
        </table>
      <br/>
			</body>
		</html>
    </xsl:template>

    <xsl:template name="Step">
      <xsl:param name="depth">0</xsl:param>
      <xsl:param name="display">block</xsl:param>
      <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
      <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
      <xsl:variable name="type" select="translate(local-name(),$ucletters,$lcletters)"/>
      <xsl:variable name="numChildren" select="count(descendant::Step) + count(descendant::TestItem) +  count(descendant::ThreadItem)"/>
      <xsl:if test='local-name()="Step" or local-name()="TestItem" or local-name()="SuiteItem"'>
        <tr id="treeStepDiv{id}">      
          <td class='treeCell'>
            <div id='treeCellInner'>
              <img src="{$fileName}-images/spacer.gif" width="{$depth*20}" height="0"/>
              <img id="stepImage{id}" class="stepImage">
                <xsl:attribute name="src"><xsl:value-of select="concat($fileName,'-images/m.gif')"/></xsl:attribute>
              </img>
              <img src="{$fileName}-images/{$type}icon.gif"/>
                &#160;<xsl:value-of select="name"/><xsl:value-of select="title"/>&#160;<xsl:value-of select="itemName"/>&#160;
            </div>
          </td>
          <td>&#160;</td>
          <td class="total"><div><xsl:value-of select="Summary/played"/>&#160;</div></td> 
          <td class="total"><div><xsl:value-of select="Summary/succeeded"/>&#160;</div></td> 
          <td class="total"><div><xsl:value-of select="Summary/failed"/>&#160;</div></td> 
          <td class="total"><div><xsl:value-of select="Summary/warnings"/>&#160;</div></td> 
          <td class="total">
            <xsl:if test='$numChildren = 0 and Summary/assertions > 0'> 
                <xsl:attribute name='class'>total failed</xsl:attribute>
              </xsl:if>
            <div><xsl:value-of select="number(concat('0',Summary/assertions))"/>&#160;</div></td> 
          <td class="total"><div><xsl:if test='Summary/averageResponseTime != ""'><xsl:value-of select="round(Summary/averageResponseTime)"/></xsl:if>&#160;</div></td> 
          <td class="total"><div><xsl:value-of select="Summary/maxResponseTime"/>&#160;</div></td> 
      </tr>
    </xsl:if>
    <span id="treeStepChildren{id}" style="display: {$display};">
      <xsl:for-each select="ChildItems/*">
        <xsl:choose>
          <xsl:when test='local-name()="Step" or local-name()="TestItem"'>
            <xsl:call-template name="Step">
              <xsl:with-param name="depth" select="$depth + 1"/>
              <xsl:with-param name="display" select="'none'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test='local-name()="ThreadItem"'>
            <xsl:call-template name="Step">
              <xsl:with-param name="depth" select="$depth"/>
              <xsl:with-param name="display" select="'block'"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>        
    </span>
  </xsl:template>
</xsl:stylesheet>
