<?xml version="1.0" encoding="utf-8"?>

<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2006-2007 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:redirect="http://xml.apache.org/xalan/redirect" 
xmlns:str="http://exslt.org/strings" 
xmlns:exslt="http://exslt.org/common" 
extension-element-prefixes="redirect" 
exclude-result-prefixes="redirect str exslt">

	<xsl:import href="asdoc-util.xsl" />
	<xsl:import href="class-stub.xsl" />

	<xsl:param name="outputPath" select="'../out'"/>
	<xsl:param name="tabSpaces" select="'    '" />
	<xsl:variable name="tab">
		<xsl:text>	</xsl:text>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:for-each select="//asClass[@type='class']">
			<xsl:sort select="@name" order="ascending" />

			<xsl:variable name="stubName"><xsl:value-of select="@name"/>Stub</xsl:variable>

			<xsl:variable name="isTopLevel">
				<xsl:call-template name="isTopLevel">
					<xsl:with-param name="packageName" select="@packageName"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="isInnerClass" select="ancestor::asClass"/>
			<xsl:variable name="packagePath" select="translate(@packageName, '.', '/')"/>
			<xsl:variable name="classFile">
				<xsl:value-of select="$outputPath"/>
				<xsl:if test="$isTopLevel='false'">
					<xsl:value-of select="$packagePath"/>
					<xsl:text>/</xsl:text>
				</xsl:if>
				<xsl:value-of select="$stubName"/>
				<xsl:text>.as</xsl:text>
			</xsl:variable>

			<redirect:write select="$classFile">
				<xsl:call-template name="class-stub">
					<!-- <xsl:with-param name="stubName" select="$stubName"/>
					<xsl:with-param name="packageName" select="@packageName"/> -->
				</xsl:call-template>
			</redirect:write>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
