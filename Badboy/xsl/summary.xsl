<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="text()|@*"/>
  <xsl:template match="/">
  <HTML style="overflow:auto;">
    <head>
      <style type="text/css">
        .heading {
          font-family: arial;
          font-size: 14px;
          font-weight: bold;
        }

        table tr td, table tr th {
          font-family: arial;
          font-size: 12px;
          border-style: none;
          border-width: 1px;
          padding-left: 5px;
          padding-right: 5px;
        }
        
        table tr td.highlight {
          color: red;
        }

        table#summary tr td {
          text-align: center;
          background-color: #eeeeee;
          width: 50px;
        }

        table tr th.padded {
          padding-left: 10px;
        }

        table tr th {
          white-space: nowrap;
          font-weight: normal;
        }

        p { 
          margin-top: 2px; margin-bottom: 2px; 
        }

        #editDescription {
          font-size: 9px;
          position: absolute;
          right: 30px; 
          height: 15px;
          display: none;
        }

        #refs {
          width: 100%;
        }
        #refs th {
          padding-top: 4px;
          font-weight: bold;
        }
        #refs td {
          background-color: transparent;
        }

      </style>
      <script type="text/javascript">
        var scriptId = '<xsl:value-of select='/summaryview/id'/>';
        scriptId = scriptId == '' ?  null : parseInt(scriptId);
        var stats = [ ["played",false], ["succeeded",false], ["failed",true], ["assertions",true], ["warnings",true], ["averageResponseTime",false], ["maxResponseTime",false], ["timeouts",true] ];
        function update() {
          if(scriptId==null)
            return;
          for(i=0;i&lt;stats.length;++i) {
            var val = window.external.summary(scriptId,stats[i][0]);
            var el = document.getElementById(stats[i][0]);
            el.innerText = val;
            if(stats[i][1]) {
              el.className = (val>0) ? 'highlight' : '';
            }
          }
        }
      </script>
    </head>
    <BODY style="font-family: arial;overflow:auto;" scroll="auto"
      onmouseover="document.getElementById('editDescription').style.display='block';" onmouseout="document.getElementById('editDescription').style.display='none';"
      onload="">
      <div style="width: 100%;"><button title="Edit Documentation" id="editDescription">...</button></div>
      <xsl:apply-templates/>
    </BODY>
  </HTML>
  </xsl:template>

  <xsl:template match="description">
    <xsl:choose>
      <xsl:when test=".=''"></xsl:when>
      <xsl:otherwise>
            <span class="heading"><xsl:choose><xsl:when test="../name=''">Description</xsl:when><xsl:otherwise><xsl:value-of select="../name"/></xsl:otherwise></xsl:choose></span>
        <HR/><SPAN style="font-family: arial; font-size: 12px;"><P>
            <xsl:value-of select="." disable-output-escaping="yes"/>
        </P></SPAN>
        <BR/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

   <xsl:template match="summary">
    <div class="heading">
      <xsl:choose>
        <xsl:when test="../description!='' or ../name=''">Summary</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../name"/>
      </xsl:otherwise>
    </xsl:choose>
    </div>
    <hr/>
    <table id="summary" cellspacing="0">
      <!-- <tr><th colspan="5" align="left">Summary</th></tr> -->
      <tr><th>Played</th><td id='played'><xsl:value-of select="played"/></td>
          <th class="padded">Assertions</th><td id='assertions'><xsl:if test="assertions &gt; 0"><xsl:attribute name="class">highlight</xsl:attribute></xsl:if><xsl:value-of select="assertions"/></td></tr>
      <tr><th>Succeeded</th><td id='succeeded'><xsl:value-of select="succeeded"/></td>
          <th class="padded">Warnings</th><td id='warnings'><xsl:if test="warnings &gt; 0"><xsl:attribute name="class">highlight</xsl:attribute></xsl:if><xsl:value-of select="warnings"/></td></tr>
      <tr><th>Failed</th><td id='failed'><xsl:if test="failed &gt; 0"><xsl:attribute name="class">highlight</xsl:attribute></xsl:if><xsl:value-of select="failed"/></td>
          <th class="padded">Timeouts</th><td id='timeouts'><xsl:if test="timeouts &gt; 0"><xsl:attribute name="class">highlight</xsl:attribute></xsl:if><xsl:value-of select="timeouts"/></td></tr>
        <tr><th>Avg Time (ms)</th><td id='averageResponseTime'><xsl:value-of select="averageResponseTime"/></td>
          <th class="padded">Max Time (ms)</th><td id='maxResponseTime'><xsl:value-of select="maxResponseTime"/></td></tr>
    </table>
  </xsl:template>


  
  <xsl:template match="references">
    <br/>
    <span class="heading">References</span>
    <hr/>
    <table id='refs'>
      <!-- <tr><th>Id</th><th>Title</th></tr> -->
      <xsl:for-each select="ref">
        <xsl:call-template name='reference'/>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template name='reference'>
    <tr>
      <th valign="top"><xsl:value-of select='refId'/></th>
      <!-- <td><xsl:value-of select='type'/></td> -->
      <td><xsl:value-of select='title'/></td>
    </tr>
  </xsl:template>


</xsl:stylesheet>
