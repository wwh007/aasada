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
            <node>
              <testelement class="org.apache.jmeter.protocol.http.sampler.HTTPSampler">
                <property name="HTTPSampler.mimetype"></property>
                <property name="HTTPSampler.follow_redirects">true</property>
                <property name="HTTPSampler.domain"><xsl:value-of select="Host"/></property>
                <property name="HTTPSampler.protocol"><xsl:value-of select="Protocol"/></property>
                <property name="HTTPSampler.FILE_FIELD"></property>
                <property name="HTTPSampler.FILE_NAME"></property>
                <property name="HTTPSampler.path"><xsl:value-of select="Path"/></property>
                <property name="TestElement.name"><xsl:value-of select="Protocol"/>://<xsl:value-of select="Host"/><xsl:value-of select="Path"/></property>
                <property name="HTTPSampler.port"><xsl:value-of select="Port"/></property>
                <property name="HTTPSampler.method"><xsl:value-of select="Method"/></property>
                <property name="TestElement.gui_class">org.apache.jmeter.protocol.http.control.gui.HttpTestSampleGui</property>
                <property name="TestElement.test_class">org.apache.jmeter.protocol.http.sampler.HTTPSampler</property>
                <property name="HTTPSampler.use_keepalive">true</property>
                <collection name="AbstractSampler.assertions" class="java.util.ArrayList"></collection>
                <testelement name="HTTPsampler.Arguments" class="org.apache.jmeter.config.Arguments">
                  <property name="TestElement.gui_class">org.apache.jmeter.protocol.http.gui.HTTPArgumentsPanel</property>
                  <property name="TestElement.test_class">org.apache.jmeter.config.Arguments</property>
                  <property name="TestElement.name">Argument List</property>
                  <collection name="Arguments.arguments" class="java.util.ArrayList">
                    <xsl:for-each select="ChildItems/Parameter">
                      <testelement class="org.apache.jmeter.protocol.http.util.HTTPArgument">
                        <xsl:choose>
                          <xsl:when test='count(Value) = 1'>
                            <property name="HTTPArgument.always_encode">true</property>
                            <property name="Argument.value"><xsl:value-of select="Value"/></property>
                          </xsl:when>
                          <xsl:otherwise>
                            <property name="HTTPArgument.always_encode">false</property>
                            <property name="Argument.value"><xsl:value-of select="EncodedValue"/></property>
                          </xsl:otherwise>
                        </xsl:choose>
                        <property name="Argument.name"><xsl:value-of select="Name"/></property>
                        <property name="Argument.metadata">=</property>
                        <property name="Argument.use_equals">
                          <xsl:choose>
                            <xsl:when test='sendEquals=0'>false</xsl:when>
                            <xsl:otherwise>true</xsl:otherwise>
                          </xsl:choose>
                        </property>
                      </testelement>
                    </xsl:for-each>
                    <xsl:for-each select="ChildItems/FormPartItem">
                      <xsl:choose>
                        <xsl:when test="FileUpload = 0">
                          <testelement class="org.apache.jmeter.protocol.http.util.HTTPArgument">
                            <xsl:choose>
                              <xsl:when test='count(Content) = 1'>
                                <property name="HTTPArgument.always_encode">true</property>
                                <property name="Argument.value"><xsl:value-of select="Content"/></property>
                              </xsl:when>
                              <xsl:otherwise>
                                <property name="HTTPArgument.always_encode">false</property>
                                <property name="Argument.value"><xsl:value-of select="EncodedContent"/></property>
                              </xsl:otherwise>
                            </xsl:choose>
                            <property name="Argument.name"><xsl:value-of select="Name"/></property>
                            <property name="Argument.metadata">=</property>
                            <property name="Argument.use_equals">true</property>
                          </testelement>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                  </collection>           
                </testelement>
                <xsl:for-each select="ChildItems/FormPartItem">
                  <xsl:choose>
                    <xsl:when test="FileUpload = 1 and count(FileName) > 0 and FileName != ''">
                      <property  name="HTTPSampler.FILE_FIELD"><xsl:value-of select="Name"/></property>
                      <property  name="HTTPSampler.FILE_NAME"><xsl:value-of select="FileName"/></property>
                    </xsl:when>
                  </xsl:choose>
                </xsl:for-each>
              </testelement>
              <node>
                <testelement class="org.apache.jmeter.protocol.http.control.HeaderManager">
                  <property xml:space="preserve" name="TestElement.gui_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.protocol.http.gui.HeaderPanel</property>
                  <property xml:space="preserve" name="TestElement.name" propType="org.apache.jmeter.testelement.property.StringProperty">HTTP Header Manager</property>
                  <property xml:space="preserve" name="TestElement.enabled" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
                  <property xml:space="preserve" name="TestElement.test_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.protocol.http.control.HeaderManager</property>
                  <collection name="HeaderManager.headers" propType="org.apache.jmeter.testelement.property.CollectionProperty" class="java.util.ArrayList">
                    <xsl:for-each select="Header">
                      <testelement name="" class="org.apache.jmeter.protocol.http.control.Header">
                        <property xml:space="preserve" name="Header.value" propType="org.apache.jmeter.testelement.property.StringProperty"><xsl:value-of select='.'/></property>
                        <property xml:space="preserve" name="TestElement.name" propType="org.apache.jmeter.testelement.property.StringProperty"><xsl:value-of select='@name'/></property>
                      </testelement>
                    </xsl:for-each>
                  </collection>
                </testelement>
              </node>

            <xsl:variable name='requestId' select='Id'/>

            <xsl:for-each select=".//Assertion">
                  <xsl:call-template name="Assertion"/>
            </xsl:for-each>

            <xsl:for-each select="following-sibling::Assertion[ (preceding-sibling::Request/Id)[position()=last()] = $requestId]">
                  <xsl:call-template name="Assertion"/>
            </xsl:for-each>

            </node>            

            <xsl:for-each select="ChildItems">
                  <xsl:apply-templates/>
            </xsl:for-each>        
  </xsl:template>


  <xsl:template name="Assertion">
    <xsl:variable name='assertionName' select='ItemName'/>
    <xsl:for-each select="ChildItems/ResponseCheckItem">
      <node>
        <testelement class="org.apache.jmeter.assertions.DurationAssertion">
          <property name="TestElement.gui_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.assertions.gui.DurationAssertionGui</property>
          <property name="DurationAssertion.duration" propType="org.apache.jmeter.testelement.property.LongProperty"><xsl:value-of select='MaxSeconds*1000'/></property>
          <property name="TestElement.name" propType="org.apache.jmeter.testelement.property.StringProperty">
            <xsl:choose>
              <xsl:when test='$assertionName = ""'>Duration Assertion</xsl:when>
              <xsl:otherwise><xsl:value-of select='$assertionName'/> (Max Duration)</xsl:otherwise>
            </xsl:choose>
          </property>
          <property name="TestElement.enabled" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
          <property name="TestElement.test_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.assertions.DurationAssertion</property>
        </testelement>
      </node>
      <xsl:if test='CheckSize="true"'>
        <node>
          <testelement class="org.apache.jmeter.assertions.SizeAssertion">
            <property name="SizeAssertion.operator" propType="org.apache.jmeter.testelement.property.IntegerProperty">5</property>
            <property name="TestElement.gui_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.assertions.gui.SizeAssertionGui</property>
            <property name="SizeAssertion.size" propType="org.apache.jmeter.testelement.property.LongProperty"><xsl:value-of select='MinSizeKB*1024'/></property>
            <property name="TestElement.name" propType="org.apache.jmeter.testelement.property.StringProperty">
              <xsl:choose>
                <xsl:when test='$assertionName = ""'>Size Assertion (Min)</xsl:when>
                <xsl:otherwise><xsl:value-of select='$assertionName'/> (Min Size)</xsl:otherwise>
              </xsl:choose>
            </property>
            <property name="TestElement.enabled" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
            <property name="TestElement.test_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.assertions.SizeAssertion</property>
          </testelement>
        </node>
        <node>
          <testelement class="org.apache.jmeter.assertions.SizeAssertion">
            <property name="SizeAssertion.operator" propType="org.apache.jmeter.testelement.property.IntegerProperty">6</property>
            <property name="TestElement.gui_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.assertions.gui.SizeAssertionGui</property>
            <property name="SizeAssertion.size" propType="org.apache.jmeter.testelement.property.LongProperty"><xsl:value-of select='MaxSizeKB*1024'/></property>
            <property name="TestElement.name" propType="org.apache.jmeter.testelement.property.StringProperty">
              <xsl:choose>
                <xsl:when test='$assertionName = ""'>Size Assertion (Max)</xsl:when>
                <xsl:otherwise><xsl:value-of select='$assertionName'/> (Max Size)</xsl:otherwise>
              </xsl:choose>
            </property>
            <property name="TestElement.enabled" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
            <property name="TestElement.test_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.assertions.SizeAssertion</property>
          </testelement>
        </node>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="ChildItems/ContentCheckItem">
    <node>
      <testelement class="org.apache.jmeter.assertions.ResponseAssertion">
        <property name="Assertion.test_type" propType="org.apache.jmeter.testelement.property.IntegerProperty">
          <xsl:choose>
            <xsl:when test="Type='Does Not Contain'">6</xsl:when>
            <xsl:otherwise>2</xsl:otherwise>
          </xsl:choose>
        </property>
        <xsl:variable name='ignorecase'><xsl:choose><xsl:when test='RuntimeBodyContent="true"'>(?i)</xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>
        <property name="TestElement.gui_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.assertions.gui.AssertionGui</property>
        <collection name="Asserion.test_strings" propType="org.apache.jmeter.testelement.property.CollectionProperty" class="java.util.ArrayList">
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
              <property propType="org.apache.jmeter.testelement.property.StringProperty"><xsl:attribute name="name">pattern</xsl:attribute><xsl:value-of select='$ignorecase'/><xsl:value-of select='$p'/></property>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name='p' select='Pattern'/>
              <property propType="org.apache.jmeter.testelement.property.StringProperty"><xsl:attribute name="name">pattern</xsl:attribute><xsl:value-of select='$ignorecase'/><xsl:value-of select='$p'/></property>
            </xsl:otherwise>
          </xsl:choose>
        </collection>
        <property name="TestElement.name" propType="org.apache.jmeter.testelement.property.StringProperty">
          Assertion - Response <xsl:value-of select="Type"/>&#160;<xsl:value-of select="substring(Pattern,0,30)"/><xsl:if test='string-length(Pattern) > 30'>...</xsl:if> 
        </property>
        <property name="Assertion.test_field" propType="org.apache.jmeter.testelement.property.StringProperty">Assertion.response_data</property>
        <property name="TestElement.enabled" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
        <property name="TestElement.test_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.assertions.ResponseAssertion</property>
      </testelement>
    </node>
    </xsl:for-each>

  </xsl:template>

  <xsl:template match="VariableSetter[type=2]">
    <node>
      <testelement class="org.apache.jmeter.extractor.RegexExtractor">
        <property xml:space="preserve" name="RegexExtractor.match_number" propType="org.apache.jmeter.testelement.property.StringProperty">1</property>
        <property xml:space="preserve" name="TestElement.gui_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.extractor.gui.RegexExtractorGui</property>
        <property xml:space="preserve" name="RegexExtractor.refname" propType="org.apache.jmeter.testelement.property.StringProperty"><xsl:value-of select='variableName'/></property>
        <property xml:space="preserve" name="RegexExtractor.default" propType="org.apache.jmeter.testelement.property.StringProperty"/>
        <property xml:space="preserve" name="RegexExtractor.template" propType="org.apache.jmeter.testelement.property.StringProperty">$1$</property>
        <property xml:space="preserve" name="TestElement.name" propType="org.apache.jmeter.testelement.property.StringProperty"><xsl:choose><xsl:when test='string-length(ItemName)>0'><xsl:value-of select='ItemName'/></xsl:when> <xsl:otherwise test='ItemName=""'>Set $<xsl:value-of select='variableName'/></xsl:otherwise></xsl:choose></property>
        <property xml:space="preserve" name="TestElement.enabled" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
        <property xml:space="preserve" name="TestElement.test_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.extractor.RegexExtractor</property>
        <property xml:space="preserve" name="RegexExtractor.regex" propType="org.apache.jmeter.testelement.property.StringProperty"><xsl:value-of select='regex'/></property>
      </testelement>
    </node>
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
        <node>
          <testelement class="org.apache.jmeter.control.LoopController"><Id><xsl:value-of select="Id"/></Id>
            <property name="TestElement.test_class">org.apache.jmeter.control.LoopController</property>
            <property name="TestElement.gui_class">org.apache.jmeter.control.gui.LoopControlPanel</property>
            <property name="TestElement.name"><xsl:value-of select="Name"/></property>
            <property name="LoopController.loops"><xsl:value-of select="Repetitions"/></property>
            <property name="TestElement.enabled" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
            <property name="LoopController.continue_forever" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
          </testelement>
          <xsl:for-each select="ChildItems">
                <xsl:apply-templates/>
          </xsl:for-each>        
        </node>
  </xsl:template>


  
  <xsl:template match="BadboyDocument">
    <node>
      <testelement class="org.apache.jmeter.testelement.TestPlan">
        <property name="TestPlan.functional_mode">false</property>
        <property name="TestElement.test_class">org.apache.jmeter.testelement.TestPlan</property>
        <property name="TestElement.gui_class">org.apache.jmeter.control.gui.TestPlanGui</property>
        <collection name="TestPlan.thread_groups" class="java.util.LinkedList"></collection>
        <property name="TestElement.name">Badboy Test Plan</property>
        <testelement name="TestPlan.user_defined_variables" class="org.apache.jmeter.config.Arguments">
          <property name="TestElement.test_class">org.apache.jmeter.config.Arguments</property>
          <property name="TestElement.gui_class">org.apache.jmeter.config.gui.ArgumentsPanel</property>
          <property name="TestElement.name">Argument List</property>
          <collection name="Arguments.arguments" class="java.util.ArrayList"></collection>
        </testelement>
      </testelement>
      <node>
        <testelement class="org.apache.jmeter.threads.ThreadGroup">
          <property name="TestElement.test_class">org.apache.jmeter.threads.ThreadGroup</property>
          <property name="TestElement.gui_class">org.apache.jmeter.threads.gui.ThreadGroupGui</property>
          <property name="TestElement.name">Thread Group</property>
          <testelement name="ThreadGroup.main_controller" class="org.apache.jmeter.control.LoopController">
            <property name="LoopController.continue_forever">false</property>
            <property name="TestElement.test_class">org.apache.jmeter.control.LoopController</property>
            <property name="LoopController.loops">1</property>
            <property name="TestElement.gui_class">org.apache.jmeter.control.gui.LoopControlPanel</property>
            <property name="TestElement.name">Loop Controller</property>
          </testelement>
          <property name="ThreadGroup.num_threads">1</property>
          <property name="ThreadGroup.ramp_time">1</property>
        </testelement>
        <node>
          <testelement class="org.apache.jmeter.protocol.http.control.CookieManager">
            <property name="TestElement.test_class">org.apache.jmeter.protocol.http.control.CookieManager</property>
            <property name="TestElement.gui_class">org.apache.jmeter.protocol.http.gui.CookiePanel</property>
            <property name="TestElement.name">HTTP Cookie Manager</property>
            <collection name="CookieManager.cookies" class="java.util.ArrayList"></collection>
          </testelement>
        </node>
        <node>
          <testelement class="org.apache.jmeter.modifiers.UserParameters">
            <property name="TestElement.test_class">org.apache.jmeter.modifiers.UserParameters</property>
            <property name="TestElement.gui_class">org.apache.jmeter.modifiers.gui.UserParametersGui</property>
            <property name="TestElement.name">User Parameters</property>
            <property name="TestElement.enabled" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
            <property name="TestElement.per_iteration" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
            <collection name="UserParameters.names" class="java.util.ArrayList">
              <xsl:for-each select="Variable">
                <!-- Check that it does not occur in a variable setter -->
                <xsl:variable name='varName' select='@name'/>
                <xsl:if test='count(//VariableSetter[variableName=$varName])=0'>
                  <property name="{@name}"><xsl:value-of select="@name"/></property>
                </xsl:if>
              </xsl:for-each>
            </collection>
            <collection name="UserParameters.thread_values" class="java.util.ArrayList">
              <collection name="" class="java.util.ArrayList">
                <xsl:for-each select="Variable">
                  <xsl:variable name='varName' select='@name'/>
                  <xsl:if test='count(//VariableSetter[variableName=$varName])=0'>
                    <property name="{.}"><xsl:value-of select="."/></property>
                  </xsl:if>
                </xsl:for-each>
              </collection>
            </collection>
          </testelement>
        </node>
        <node>
          <testelement class="org.apache.jmeter.protocol.http.control.HeaderManager">
            <property xml:space="preserve" name="TestElement.gui_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.protocol.http.gui.HeaderPanel</property>
            <property xml:space="preserve" name="TestElement.name" propType="org.apache.jmeter.testelement.property.StringProperty">HTTP Header Manager</property>
            <property xml:space="preserve" name="TestElement.enabled" propType="org.apache.jmeter.testelement.property.BooleanProperty">true</property>
            <property xml:space="preserve" name="TestElement.test_class" propType="org.apache.jmeter.testelement.property.StringProperty">org.apache.jmeter.protocol.http.control.HeaderManager</property>
            <collection name="HeaderManager.headers" propType="org.apache.jmeter.testelement.property.CollectionProperty" class="java.util.ArrayList">
              <xsl:for-each select="/BadboyDocument/Script/Header">
                <testelement name="" class="org.apache.jmeter.protocol.http.control.Header">
                  <property xml:space="preserve" name="Header.value" propType="org.apache.jmeter.testelement.property.StringProperty"><xsl:value-of select='.'/></property>
                  <property xml:space="preserve" name="TestElement.name" propType="org.apache.jmeter.testelement.property.StringProperty"><xsl:value-of select='@name'/></property>
                </testelement>
              </xsl:for-each>
            </collection>
          </testelement>
        </node>
        <!-- Add the steps -->
        <xsl:for-each select="Script/ChildItems">
            <xsl:apply-templates/>
        </xsl:for-each>        
      </node>
    </node>
  </xsl:template>
</xsl:stylesheet>
