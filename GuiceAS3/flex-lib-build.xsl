<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output indent="yes" method="xml" />

	<xsl:param name="FLEX_SDK" />
	<xsl:param name="MAIN_APP" />
	<xsl:param name="FLEX_CONFIG" />
	<xsl:param name="WORKSPACE_DIR" />
	<xsl:param name="FLEX_DEBUG" />
	<xsl:param name="AUTOMATION_DIR" />

	<xsl:template match="/">
		<xsl:for-each select="//actionScriptProperties/compiler">

			<xsl:variable name="SRC_DIR" select="@sourceFolderPath" />
			<xsl:variable name="BUILD_DIR" select="@outputFolderPath" />
			<xsl:variable name="ARGS" select="@additionalCompilerArguments" />

			<project name="{$MAIN_APP}" default="build" basedir=".">

				<property name="flex.sdk.dir" location="{$FLEX_SDK}" />
				<property name="output.name" value="{$MAIN_APP}" />
				<property name="flex.debug" value="{$FLEX_DEBUG}" />
				<property name="src.dir" location="{$SRC_DIR}" />
				<property name="build.dir" location="{$BUILD_DIR}" />
				<property name="DOCUMENTS" location="{$WORKSPACE_DIR}" />
				<property name="automation.dir" location="{$AUTOMATION_DIR}" />
				<property name="additional.compiler.arguments" value="{$ARGS}" />
				<property name="flex.config.xml" location="{$FLEX_CONFIG}" />

				<xsl:for-each select="//compiler/variables">
					<xsl:text disable-output-escaping="yes"><![CDATA[
	<property name="]]></xsl:text>
					<xsl:value-of select="@name" />
					<xsl:text disable-output-escaping="yes"><![CDATA[" location="]]></xsl:text>
					<xsl:value-of select="@value" />
					<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
				</xsl:for-each>

				<xsl:text disable-output-escaping="yes"><![CDATA[
<property name="includeAutomation" value="false"/>
<property name="FRAMEWORKS" location="${flex.sdk.dir}/frameworks"/>

    <property name="main.application.out" location="${build.dir}/${output.name}.swc"/>
    <property name="compc.jar" location="${flex.sdk.dir}/lib/compc.jar"/>

 <condition property="automation" value="-include-libraries+=${automation.dir}/automation.swc -include-libraries+=${automation.dir}/automation_agent.swc -include-libraries+=${automation.dir}/qtp.swc -include-libraries+=${automation.dir}/automation_dmv.swc">
  <equals arg1="${includeAutomation}" arg2="true" />
 </condition>  
 <condition property="automation" value="">
  <not>
   <isset property="automation"/>
   </not>
 </condition>
 <echo message="Include Automation:${includeAutomation}"/>  

    <!-- =================================
          target: build
         ================================= -->
    <target
     name="build"
     depends="clear,init,compile"
     description="-->Compile flex library">
    </target>

    <!-- - - - - - - - - - - - - - - - - -
          target: compile
         - - - - - - - - - - - - - - - - - -->
    <target name="compile">
     <java
      jar="${compc.jar}"
      fork="true"
      maxmemory="512m"
      failonerror="true">

      <arg value="+flexlib=${flex.sdk.dir}/frameworks"/>
      <arg line="${additional.compiler.arguments}" />
      <arg value="-load-config=${flex.config.xml}"/>
      <arg value="-output=${main.application.out}"/>
      <arg value="-source-path"/>
      <arg value="${src.dir}"/>
      <arg value="-warnings=false"/>
      <arg value="-debug=${flex.debug}"/>
	  <arg value="-external-library-path+=${FRAMEWORKS}/libs/player/10.0/playerglobal.swc"/>
	  <arg value="-library-path+=${FRAMEWORKS}/locale/{locale}"/>
      <arg line="${automation}"/>
]]></xsl:text>

				<xsl:for-each select="//compiler/libraryPath/libraryPathEntry[@linkType=1]">
					<xsl:text disable-output-escaping="yes"><![CDATA[
	  <arg value="-library-path+=]]></xsl:text>
					<xsl:value-of select="@path" />
					<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
				</xsl:for-each>

				<xsl:for-each select="//compiler/libraryPath/libraryPathEntry[@linkType=2]">
					<xsl:text disable-output-escaping="yes"><![CDATA[
	  <arg value="-external-library-path+=]]></xsl:text>
					<xsl:value-of select="@path" />
					<xsl:text disable-output-escaping="yes"><![CDATA["/>]]></xsl:text>
				</xsl:for-each>

				<xsl:text disable-output-escaping="yes"><![CDATA[
	 </java>
    </target>

 <!-- - - - - - - - - - - - - - - - - -
          target: clear
         - - - - - - - - - - - - - - - - - -->
    <target name="clear">
  <delete failonerror="false">
   <fileset dir="${build.dir}" includes="**/*.*" />
  </delete>
    </target>

 <!-- - - - - - - - - - - - - - - - - -
          target: init
         - - - - - - - - - - - - - - - - - -->
    <target name="init">
     <mkdir
      dir="${build.dir}"/>
    </target>
]]></xsl:text>
			</project>

		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>
