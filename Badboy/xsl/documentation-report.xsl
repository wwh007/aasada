<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/DTD/strict.dtd"  />
<xsl:variable name="scriptFileName" select="translate( /WebScript/Variables/name[string()  = 'badboy.scriptFileName' ]/following-sibling::*[1],'\','/') " />	
<xsl:variable name="fileName" select="translate( /WebScript/Variables/name[string()  = 'badboy.saveItemRelFileName' ]/following-sibling::*[1],'\','/') " />	
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
		<title>Test Documentation</title>		
		<style type="text/css">
						body {
							font:normal 68% verdana,arial,helvetica;
							color:#000000;
						}

						table tr td, table tr th {
							font-size: 88%;
						}

						h1 {
							margin: 0px 0px 5px; font: 200% verdana,arial,helvetica
						}
						h2 {
							margin-top: 1em; margin-bottom: 0.5em; font: bold 150% verdana,arial,helvetica
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
            .test {
              background-color: white;
              padding-top: 0px;
              padding-bottom: 1em;
            }
            .testheader {
              background-color: #fff0d9;
              background-color: #aaa;
              padding: 5px 1em 2px 1em;
              color: white;
            }
            .testbox {
              border: solid 1px #aaa;
              margin-bottom: 1em;
            }
            .inlinedoc { font-style: italic;  font-size: 93%; }

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
        <h1>Test Documentation: 
          <xsl:choose>
            <xsl:when test='//Script/itemName=""'>
              <xsl:value-of select="$scriptFileName"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//Script/itemName"/> 
            </xsl:otherwise>
          </xsl:choose>
          </h1>

        Report created <xsl:value-of select="$saveDateTime"/>

        <xsl:if test='//Script/documentation!=""'>
          <hr/>
        </xsl:if>
        <xsl:value-of select="//Script/documentation" disable-output-escaping="yes"/>

				<hr size="1"/>				

        <h2>Contents</h2>

        <ul>
        <xsl:for-each select='//SuiteItem[disabled!="true"]'>
          <li>
            <a href='#{id}'><xsl:value-of select='itemName'/></a>
            <ol>
            <xsl:for-each select='descendant::TestItem[disabled!="true"]'>
              <li>
                <a href='#{id}'><xsl:value-of select='title'/> <xsl:value-of select='itemName'/></a>
              </li>
            </xsl:for-each>
            </ol>
          </li>
        </xsl:for-each>
        </ul>

        <hr/>
        
        <xsl:for-each select='//SuiteItem[disabled!="true"]'>
          <h2><a name='{id}'>Suite - <xsl:value-of select='itemName'/></a></h2>
          <xsl:for-each select='descendant::TestItem[disabled!="true"]'>
          <div class='testbox'>
            <div class='testheader'>
              <h3><a name='{id}'>Test -  <xsl:value-of select='title'/> <xsl:value-of select='itemName'/></a> </h3>
              <xsl:value-of select="documentation" disable-output-escaping="yes"/>
            </div>

              <ol class='test'>
                <xsl:for-each select='descendant::Step[disabled!="true"]'>
                  <li>
                    <h4><xsl:value-of select='name'/> <xsl:value-of select='itemName'/> </h4>
                    <xsl:value-of select="documentation" disable-output-escaping="yes"/>

                    <xsl:for-each select='ChildItems/*'>
                        <xsl:if test="local-name()='Request' and count(ChildItems/Parameter)=0">
                          <p>Navigate to <xsl:value-of select='protocol'/>://<xsl:value-of select='host'/><xsl:value-of select='path'/></p>
                        </xsl:if>

                        <xsl:if test="local-name()='Navigation' and count(./references/VisibleTextReference)>0">
                          Click 
                          <xsl:choose>
                            <xsl:when test='count(references/VisibleTextReference[filter="Buttons"])>0'>Button </xsl:when>
                            <xsl:when test='count(references/VisibleTextReference[filter="Links"])>0'>Link </xsl:when>
                            <xsl:otherwise>Item </xsl:otherwise>
                          </xsl:choose>

                          <xsl:value-of select='references/VisibleTextReference/value'/>
                        </xsl:if>

                        <xsl:if test="local-name()='FormPopulator'">
                          <p>Populate form  
                            <xsl:choose>
                              <xsl:when test='string-length(formName)>0'>
                                <xsl:value-of select='formName'/>
                              </xsl:when>
                              <xsl:otherwise>
                                number <xsl:value-of select='formIndex'/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </p>
                          <span class='inlinedoc'><xsl:value-of select="documentation" disable-output-escaping="yes"/></span>
                        </xsl:if>

                        <xsl:if test="local-name()='Assertion'">
                          <h5>Verify</h5>
                          <xsl:value-of select="documentation" disable-output-escaping="yes"/>

                          <ul>
                          <xsl:for-each select='ChildItems/*'>

                            <li> 
                              <xsl:choose>
                                <xsl:when test="local-name()='ContentCheckItem'">
                                  Page <xsl:choose><xsl:when test='type = 1'>does not contain</xsl:when><xsl:otherwise>contains</xsl:otherwise></xsl:choose>
                                  pattern &#160; '<xsl:call-template name="wrap_text"><xsl:with-param name="text" select="pattern"/><xsl:with-param name="width" select="100"/></xsl:call-template>'
                                </xsl:when>
                                <xsl:when test="local-name()='BitmapCheckItem'">
                                  Color RGB(<xsl:value-of select="r"/>,<xsl:value-of select="b"/>,<xsl:value-of select="g"/>)
                                  <xsl:value-of select="Type"/>&#160;at&#160;
                                  (<xsl:value-of select="number(concat('0',x))"/>,<xsl:value-of select="number(concat('0',y))"/>)
                                </xsl:when>
                                <xsl:when test="local-name()='ResponseCheckItem'">
                                  Response Time is <xsl:value-of select="number(concat('0',minSeconds))"/> to <xsl:value-of select="number(concat('0',maxSeconds))"/> secs
                                  <xsl:if test="checkSize = 'true'">
                                    , Size is <xsl:value-of select="number(concat('0',minSizeKB))"/>&#160;to&#160;<xsl:value-of select="number(concat('0',maxSizeKB))"/> KB
                                  </xsl:if>
                                </xsl:when>
                                <xsl:when test="local-name()='SummaryCheckItem'">
                                  <xsl:choose>
                                    <xsl:when test="locatorType = '1'">Item <xsl:value-of select="id"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="summarySelector"/></xsl:otherwise>
                                  </xsl:choose>
                                  has <xsl:choose><xsl:when test='combineType=1'>one of</xsl:when><xsl:otherwise>all of</xsl:otherwise></xsl:choose>
                                  <ul class="summaryCheck">
                                    <xsl:call-template name="SummaryCheckRule"><xsl:with-param name='stat'>played</xsl:with-param></xsl:call-template>
                                    <xsl:call-template name="SummaryCheckRule"><xsl:with-param name='stat'>succeeded</xsl:with-param></xsl:call-template>
                                    <xsl:call-template name="SummaryCheckRule"><xsl:with-param name='stat'>failed</xsl:with-param></xsl:call-template>
                                    <xsl:call-template name="SummaryCheckRule"><xsl:with-param name='stat'>warnings</xsl:with-param></xsl:call-template>
                                    <xsl:call-template name="SummaryCheckRule"><xsl:with-param name='stat'>assertions</xsl:with-param></xsl:call-template>
                                    <xsl:call-template name="SummaryCheckRule"><xsl:with-param name='stat'>timeouts</xsl:with-param></xsl:call-template>
                                  </ul>
                                </xsl:when>
                                <xsl:when test="local-name()='VariableCheck'">
                                  Variable  <xsl:value-of select="variableName"/> matches pattern '<xsl:value-of select="regex"/>'
                                </xsl:when>
                              </xsl:choose>
                            </li>
                          </xsl:for-each>
                          </ul>
                        </xsl:if>
                    </xsl:for-each>

                  </li>
                </xsl:for-each>
              </ol>
            </div>

            <div class='step'>
            </div>
          </xsl:for-each>
                  <hr/>
        </xsl:for-each>

      </body>
    </html>
  </xsl:template>

  <xsl:template name="ItemPath">
     <xsl:param name="depth">0</xsl:param>
     <xsl:param name="n" select="../.."/>

     <xsl:if test='$n/id != "" '>
       <xsl:call-template name="ItemPath">
         <xsl:with-param name="n" select="$n/../.."/>
         <xsl:with-param name="depth" select="$depth + 1"/>
       </xsl:call-template> 

       <xsl:if test='local-name($n) != "Script"'>
         <xsl:value-of select="$n/name"/><xsl:value-of select="$n/title"/>&#160;<xsl:value-of select="$n/itemName"/>
         <xsl:if test='$depth &gt; 1'> / </xsl:if>
       </xsl:if>
     </xsl:if>
  </xsl:template>

  <xsl:template name="SummaryCheckRule">
    <xsl:param name="stat">0</xsl:param>
    <xsl:if test='max/*[local-name()=$stat] >= 0'> <!-- less than zero means disabled -->
    <li>
        <xsl:value-of select="$stat"/> in range [<xsl:value-of select="number(concat('0',min/*[local-name()=$stat]))"/> , <xsl:value-of select="number(concat('0',max/*[local-name()=$stat]))"/>]
    </li>
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
