<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="BadboyDocument">
    <html>
      <head>
        <style type="text/css">
          body 
          {
              font-family: Verdana;
              font-size: 0.8em;
              text-align: justify;
              background-color: rgb(255,255,255);            
          }
          .title
          {
             font-family: Verdana;
             font-size: 1.2em;
             font-weight: bold;
          }
          .resulttable
          {
              font-family: Verdana;
              font-size: 0.8em;
              text-align: justify;
              background-color: rgb(245,245,245);        
              border: 1px solid;
          }
        </style>
      </head>
      <body>
        <h1 class="title">Badboy Test Report</h1>
        <table class="resulttable">
          <tr style="font-weight: bold; border-bottom: 1px solid;"><td width="100">Assertion Id</td><td>Pattern</td><td width="100" align="center">Result</td><td>Failures</td></tr>
          <xsl:for-each select="//Assertion">
            <tr>
              <td align="center"><xsl:value-of select="Id"/></td>
              <td align="center"><xsl:value-of select="Pattern"/></td>
              <td align="center"><xsl:choose><xsl:when test="Passed='true'"> Passed</xsl:when><xsl:otherwise> Failed</xsl:otherwise></xsl:choose></td>
              <td align="center"><xsl:value-of select="summary/assertions"/></td>
            </tr>
          </xsl:for-each>
      </table>
      <br/>
      <table class="resulttable">
        <tr style="font-weight: bold; border-bottom: 1px solid;"><td>Request Id</td><td>Path</td><td>Played</td><td>Succeeded</td><td>Failed</td></tr>
          <xsl:for-each select="//Request">
            <tr><td align="center"><xsl:value-of select="Id"/></td>
              <td align="center"><xsl:value-of select="Path"/></td>
              <td align="center"><xsl:value-of select="summary/played"/></td>
              <td align="center"><xsl:value-of select="summary/succeeded"/></td>
              <td align="center"><xsl:value-of select="summary/failed"/></td>
              </tr>
          </xsl:for-each>
      </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
