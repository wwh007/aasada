<?xml version="1.0" encoding="UTF-8"?>
<!--
   Copyright 2005 - 2008 Simon Sadedin, Badboy Software.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/> 

  <xsl:template match="text()|@*">
  </xsl:template>

  <xsl:template match="Request[Mode!='redirect']">

    <HTTPSampler guiclass="HttpTestSampleGui" testclass="HTTPSampler" enabled="true">
      <xsl:attribute name="testname">
        <xsl:value-of select="Protocol"/>://<xsl:value-of select="Host"/><xsl:value-of select="Path"/>
      </xsl:attribute>
      <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
        <xsl:value-of select="Protocol"/>://<xsl:value-of select="Host"/><xsl:value-of select="Path"/>
        <collectionProp name="Arguments.arguments">
          
          <!-- Normal GET and POST parameters-->
          <xsl:for-each select="ChildItems/Parameter">
            <elementProp elementType="HTTPArgument">
              <xsl:attribute name="name">
                <xsl:value-of select="Name"/>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test='count(Value) = 1'>
                  <boolProp name="HTTPArgument.always_encode">true</boolProp>
                  <stringProp name="Argument.value"><xsl:value-of select="Value"/></stringProp>
                </xsl:when>
                <xsl:otherwise>
                  <boolProp name="HTTPArgument.always_encode">false</boolProp>
                  <stringProp name="Argument.value"><xsl:value-of select="EncodedValue"/></stringProp>
                </xsl:otherwise>
              </xsl:choose>
              <stringProp name="Argument.metadata">=</stringProp>
              <boolProp name="HTTPArgument.use_equals">
                <xsl:choose>
                  <xsl:when test='sendEquals=0'>false</xsl:when>
                  <xsl:otherwise>true</xsl:otherwise>
                </xsl:choose>
              </boolProp>
              <stringProp name="Argument.name"><xsl:value-of select="Name"/></stringProp>
            </elementProp>
          </xsl:for-each>

          <!-- Form parts that are not file uploads - send as normal parameters -->
          <xsl:for-each select="ChildItems/FormPartItem">
              <xsl:choose>
                <xsl:when test="FileUpload = 0">
                  <elementProp elementType="HTTPArgument">
                    <xsl:attribute name="name">
                      <xsl:value-of select="Name"/>
                    </xsl:attribute>
                    <xsl:choose>
                      <xsl:when test='count(Content) = 1'>
                        <boolProp name="HTTPArgument.always_encode">true</boolProp>
                        <stringProp name="Argument.value">
                          <xsl:value-of select="Content"/>
                        </stringProp>
                      </xsl:when>
                      <xsl:otherwise>
                        <boolProp name="HTTPArgument.always_encode">false</boolProp>
                        <stringProp name="Argument.value">
                          <xsl:value-of select="EncodedContent"/>
                        </stringProp>
                      </xsl:otherwise>
                    </xsl:choose>
                    <stringProp name="Argument.metadata">=</stringProp>
                    <boolProp name="HTTPArgument.use_equals">
                      <xsl:choose>
                        <xsl:when test='sendEquals=0'>false</xsl:when>
                        <xsl:otherwise>true</xsl:otherwise>
                      </xsl:choose>
                    </boolProp>
                    <stringProp name="Argument.name">
                      <xsl:value-of select="Name"/>
                    </stringProp>
                  </elementProp>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>

        </collectionProp>
      </elementProp>
      <stringProp name="HTTPSampler.domain"><xsl:value-of select="Host"/></stringProp>
      <stringProp name="HTTPSampler.port"><xsl:value-of select="Port"/></stringProp>
      <stringProp name="HTTPSampler.protocol"><xsl:value-of select="Protocol"/></stringProp>
      <stringProp name="HTTPSampler.contentEncoding"></stringProp>
      <stringProp name="HTTPSampler.path"><xsl:value-of select="Path"/></stringProp>
      <stringProp name="HTTPSampler.method"><xsl:value-of select="Method"/></stringProp>
      <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
      <boolProp name="HTTPSampler.auto_redirects">true</boolProp>
      <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
      <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
      
      <xsl:for-each select="ChildItems/FormPartItem">
        <xsl:choose>
          <xsl:when test="FileUpload = 1 and count(FileName) > 0 and FileName != ''">
            <stringProp name="HTTPSampler.FILE_FIELD">
              <xsl:value-of select="Name"/>
            </stringProp>
            <stringProp name="HTTPSampler.FILE_FIELD">
              <xsl:value-of select="FileName"/>
            </stringProp>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <stringProp name="HTTPSampler.mimetype"></stringProp>
      <stringProp name="HTTPSampler.monitor">false</stringProp>
      <stringProp name="HTTPSampler.embedded_url_re"></stringProp>
    </HTTPSampler>
    <hashTree/>

    <xsl:variable name='requestId' select='Id'/>

      <xsl:for-each select=".//Assertion">
        <xsl:call-template name="Assertion"/>
      </xsl:for-each>

      <xsl:for-each select="following-sibling::Assertion[ (preceding-sibling::Request/Id)[position()=last()] = $requestId]">
        <xsl:call-template name="Assertion"/>
      </xsl:for-each>
    
    <xsl:for-each select="ChildItems">
      <xsl:apply-templates/>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="Assertion">
    <xsl:variable name='assertionName' select='ItemName'/>
    <xsl:for-each select="ChildItems/ResponseCheckItem">

      <DurationAssertion guiclass="DurationAssertionGui" testclass="DurationAssertion" enabled="true">
        <xsl:attribute name="testname">
          <xsl:choose>
            <xsl:when test='$assertionName = ""'>Duration Assertion</xsl:when>
            <xsl:otherwise><xsl:value-of select='$assertionName'/> (Max Duration)</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <stringProp name="DurationAssertion.duration"><xsl:value-of select='MaxSeconds*1000'/></stringProp>
      </DurationAssertion>
      <hashTree/>
      
      <xsl:if test='CheckSize="true"'>

        <SizeAssertion guiclass="SizeAssertionGui" testclass="SizeAssertion" enabled="true">
          <xsl:attribute name="testname">
            <xsl:choose>
              <xsl:when test='$assertionName = ""'>Size Assertion (Min)</xsl:when>
              <xsl:otherwise>
                <xsl:value-of select='$assertionName'/> (Min Size)
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <longProp name="SizeAssertion.size"><xsl:value-of select='MinSizeKB*1024'/></longProp>
          <intProp name="SizeAssertion.operator">5</intProp>
        </SizeAssertion>

        <hashTree/>

        <SizeAssertion guiclass="SizeAssertionGui" testclass="SizeAssertion" enabled="true">
          <xsl:attribute name="testname">
            <xsl:choose>
              <xsl:when test='$assertionName = ""'>Size Assertion (Max)</xsl:when>
              <xsl:otherwise>
                <xsl:value-of select='$assertionName'/> (Max Size)
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <longProp name="SizeAssertion.size">
            <xsl:value-of select='MaxSizeKB*1024'/>
          </longProp>
          <intProp name="SizeAssertion.operator">6</intProp>
        </SizeAssertion>        
        <hashTree/>
      </xsl:if>
    </xsl:for-each>
    
    <xsl:for-each select="ChildItems/ContentCheckItem">     
      <ResponseAssertion guiclass="AssertionGui" testclass="ResponseAssertion" testname="Response Assertion" enabled="true">
        <xsl:variable name='ignorecase'>
          <xsl:choose>
            <xsl:when test='RuntimeBodyContent="true"'>(?i)</xsl:when>
            <xsl:otherwise></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <collectionProp name="Asserion.test_strings">
          <stringProp>
            <xsl:attribute name="name">pattern</xsl:attribute>
            <xsl:choose>
              <xsl:when test='UseRegex="false"'>
                <xsl:variable name='p'>
                  <xsl:call-template name="replace-string">
                    <xsl:with-param name="text">
                      <xsl:call-template name="replace-string">
                        <xsl:with-param name="text">
                          <xsl:call-template name="replace-string">
                            <xsl:with-param name="text">
                              <xsl:call-template name="replace-string">
                                <xsl:with-param name="text">
                                  <xsl:call-template name="replace-string">
                                    <xsl:with-param name="text">
                                      <xsl:call-template name="replace-string">
                                        <xsl:with-param name="text">
                                          <xsl:call-template name="replace-string">
                                            <xsl:with-param name="text">
                                              <xsl:call-template name="replace-string">
                                                <xsl:with-param name="text">
                                                  <xsl:call-template name="replace-string">
                                                    <xsl:with-param name="text">
                                                      <xsl:call-template name="replace-string">
                                                        <xsl:with-param name="text">
                                                          <xsl:call-template name="replace-string">
                                                            <xsl:with-param name="text" select="Pattern"/>
                                                            <xsl:with-param name="from" select="'\'"/>
                                                            <xsl:with-param name="to" select="'\\'"/>
                                                          </xsl:call-template>
                                                        </xsl:with-param>
                                                        <xsl:with-param name="from" select="')'"/>
                                                        <xsl:with-param name="to" select="'\)'"/>
                                                      </xsl:call-template>
                                                    </xsl:with-param>
                                                    <xsl:with-param name="from" select="'('"/>
                                                    <xsl:with-param name="to" select="'\('"/>
                                                  </xsl:call-template>
                                                </xsl:with-param>
                                                <xsl:with-param name="from" select="'+'"/>
                                                <xsl:with-param name="to" select="'\+'"/>
                                              </xsl:call-template>
                                            </xsl:with-param>
                                            <xsl:with-param name="from" select="'|'"/>
                                            <xsl:with-param name="to" select="'\|'"/>
                                          </xsl:call-template>
                                        </xsl:with-param>
                                        <xsl:with-param name="from" select="'.'"/>
                                        <xsl:with-param name="to" select="'\.'"/>
                                      </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="from" select="'*'"/>
                                    <xsl:with-param name="to" select="'\*'"/>
                                  </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="from" select="']'"/>
                                <xsl:with-param name="to" select="'\]'"/>
                              </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="from" select="'['"/>
                            <xsl:with-param name="to" select="'\['"/>
                          </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="from" select="'^'"/>
                        <xsl:with-param name="to" select="'\^'"/>
                      </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="from" select="'$'"/>
                    <xsl:with-param name="to" select="'\$'"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select='$ignorecase'/>
                <xsl:value-of select='$p'/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name='p' select='Pattern'/>
                <xsl:value-of select='$ignorecase'/>
                <xsl:value-of select='$p'/>
              </xsl:otherwise>
            </xsl:choose>
          </stringProp>
        </collectionProp>
        <stringProp name="Assertion.test_field">Assertion.response_data</stringProp>
        <stringProp name="Assertion.assume_success">false</stringProp>
        <intProp name="Assertion.test_type">
          <xsl:choose>
            <xsl:when test="Type='Does Not Contain'">6</xsl:when>
            <xsl:otherwise>2</xsl:otherwise>
          </xsl:choose>
        </intProp>
      </ResponseAssertion>
       <hashTree/>
    </xsl:for-each>

  </xsl:template>

  <xsl:template match="VariableSetter[type=2]">
    <RegexExtractor guiclass="RegexExtractorGui" testclass="RegexExtractor" enabled="true">
      <xsl:attribute name="testname">
        <xsl:choose>
          <xsl:when test='string-length(ItemName)>0'><xsl:value-of select='ItemName'/></xsl:when>
          <xsl:otherwise test='ItemName=""'>Set $<xsl:value-of select='variableName'/></xsl:otherwise>
        </xsl:choose>        
      </xsl:attribute>
      <stringProp name="RegexExtractor.useHeaders">false</stringProp>
      <stringProp name="RegexExtractor.refname"><xsl:value-of select='variableName'/></stringProp>
      <stringProp name="RegexExtractor.regex"><xsl:value-of select='regex'/></stringProp>
      <stringProp name="RegexExtractor.template">$1$</stringProp>
      <stringProp name="RegexExtractor.default"></stringProp>
      <stringProp name="RegexExtractor.match_number">1</stringProp>
    </RegexExtractor>
    <hashTree/>
  </xsl:template>


   <!-- reusable replace-string function -->
   <xsl:template name="replace-string">
     <xsl:param name="text"/>
     <xsl:param name="from"/>
     <xsl:param name="to"/>
     <xsl:choose>
       <xsl:when test="contains($text, $from)">

         <xsl:variable name="before" select="substring-before($text, $from)"/>
         <xsl:variable name="after" select="substring-after($text, $from)"/>
         <xsl:variable name="prefix" select="concat($before, $to)"/>

         <xsl:value-of select="$before"/>
         <xsl:value-of select="$to"/>
         <xsl:call-template name="replace-string">
           <xsl:with-param name="text" select="$after"/>
           <xsl:with-param name="from" select="$from"/>
           <xsl:with-param name="to" select="$to"/>
         </xsl:call-template>
       </xsl:when> 
       <xsl:otherwise>
         <xsl:value-of select="$text"/>  
       </xsl:otherwise>
     </xsl:choose>            
   </xsl:template>
  

  <xsl:template match="Step">
    <LoopController guiclass="LoopControlPanel" testclass="LoopController" testname="{Name}" enabled="true">
      <boolProp name="LoopController.continue_forever">false</boolProp>
      <stringProp name="LoopController.loops"><xsl:value-of select="Repetitions"/></stringProp>
    </LoopController>
    <hashTree>
      <xsl:for-each select="ChildItems">
        <xsl:apply-templates/>
      </xsl:for-each>
    </hashTree>
  </xsl:template>
  
  <xsl:template match="BadboyDocument">
    <jmeterTestPlan version="1.2" properties="2.1">
      <hashTree>
        <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="Test Plan" enabled="true">
          <stringProp name="TestPlan.comments"></stringProp>
          <boolProp name="TestPlan.functional_mode">false</boolProp>
          <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
          <elementProp name="TestPlan.user_defined_variables" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
            <collectionProp name="Arguments.arguments"/>
          </elementProp>
          <stringProp name="TestPlan.user_define_classpath"></stringProp>
        </TestPlan>
        <hashTree>
          <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Thread Group" enabled="true">
            <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
              <boolProp name="LoopController.continue_forever">false</boolProp>
              <stringProp name="LoopController.loops">1</stringProp>
            </elementProp>
            <stringProp name="ThreadGroup.num_threads">1</stringProp>
            <stringProp name="ThreadGroup.ramp_time">1</stringProp>
            <longProp name="ThreadGroup.start_time">1281132211000</longProp>
            <longProp name="ThreadGroup.end_time">1281132211000</longProp>
            <boolProp name="ThreadGroup.scheduler">false</boolProp>
            <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
            <stringProp name="ThreadGroup.duration"></stringProp>
            <stringProp name="ThreadGroup.delay"></stringProp>
          </ThreadGroup>
          <hashTree>
            <CookieManager guiclass="CookiePanel" testclass="CookieManager" testname="HTTP Cookie Manager" enabled="true">
              <collectionProp name="CookieManager.cookies"/>
              <boolProp name="CookieManager.clearEachIteration">false</boolProp>
              <stringProp name="CookieManager.policy">rfc2109</stringProp>
            </CookieManager>
            <hashTree/>

            <!-- Variables -->
            <Arguments guiclass="ArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
              <collectionProp name="Arguments.arguments">
                <xsl:for-each select="Variable">
                  <!-- Check that it does not occur in a variable setter -->
                  <xsl:variable name='varName' select='@name'/>
                  <xsl:if test='count(//VariableSetter[variableName=$varName])=0'>
                    <elementProp name="{@name}" elementType="Argument">
                      <stringProp name="Argument.name"><xsl:value-of select="@name"/></stringProp>
                      <stringProp name="Argument.value"><xsl:value-of select="."/></stringProp>
                      <stringProp name="Argument.metadata">=</stringProp>                      
                    </elementProp>
                  </xsl:if>
                </xsl:for-each>
              </collectionProp>
            </Arguments>
            <hashTree/>
            
            <!-- Headers - User-Agent, Accept, Accept-Language -->
            <HeaderManager guiclass="HeaderPanel" testclass="HeaderManager" testname="HTTP Header Manager" enabled="true">
              <collectionProp name="HeaderManager.headers">
                <xsl:for-each select="/BadboyDocument/Script/Header">
                  <elementProp name="" elementType="Header">
                    <stringProp xml:space="preserve" name="Header.name"><xsl:value-of select='@name'/></stringProp>
                    <stringProp xml:space="preserve" name="Header.value"><xsl:value-of select='.'/></stringProp>
                  </elementProp>
                </xsl:for-each>
              </collectionProp>
            </HeaderManager>
            <hashTree/>

            <!-- Add the steps -->
            <xsl:for-each select="Script/ChildItems">
              <xsl:apply-templates/>
            </xsl:for-each>
          </hashTree>
        </hashTree>
      </hashTree>
    </jmeterTestPlan>
  </xsl:template>
</xsl:stylesheet>
