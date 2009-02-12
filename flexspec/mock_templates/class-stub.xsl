<?xml version='1.0'?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:str="http://exslt.org/strings"
exclude-result-prefixes="str">

	<xsl:import href="asdoc-util.xsl"/>

	<xsl:template name="class-stub">
<xsl:text>package </xsl:text><xsl:value-of select="@packageName"/><xsl:text> {
	public class </xsl:text><xsl:value-of select="@name"/>Stub extends <xsl:value-of select="@name"/><xsl:text> {
</xsl:text>
	<!-- <xsl:call-template name="properties"/> -->

	<xsl:apply-templates select="constructors"/>
	<xsl:call-template name="methods"/>
<xsl:text>
	}
}</xsl:text>
	</xsl:template>


	<xsl:template name="property">
		<xsl:param name="only"/>
		<xsl:param name="accessLevel"/>

<xsl:value-of select="$accessLevel"/> override function <xsl:value-of select="$only"/> <xsl:value-of select="@name"/>():<xsl:value-of select="@type"/><xsl:text>
</xsl:text>
	</xsl:template>

	<xsl:template name="properties">
		<xsl:variable name="accessLevel">public</xsl:variable>
		<xsl:for-each select="fields/field[@accessLevel=$accessLevel]">
			<xsl:sort select="translate(@name,'_','')" order="ascending" data-type="text"/>
			<!-- <xsl:value-of select="@only"/>
			<xsl:if test="not(@only='read-write')">
				<xsl:text>-only</xsl:text>
			</xsl:if>
			<xsl:if test="not(@only='read-write')">
				<xsl:text>-only</xsl:text>
			</xsl:if>
			<xsl:if test="not(@only='read-write')">
				<xsl:text>-only</xsl:text>
			</xsl:if> -->
			<xsl:call-template name="property">
				<xsl:with-param name="only">get</xsl:with-param>
				<xsl:with-param name="accessLevel">public</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="methods">
		<xsl:variable name="accessLevel">public</xsl:variable>
		<xsl:for-each select="methods/method[@accessLevel=$accessLevel]">
			<xsl:sort select="translate(@name,'_','')" order="ascending" data-type="text"/>
			<xsl:call-template name="method">
				<xsl:with-param name="accessLevel" select="$accessLevel"/>
			</xsl:call-template>	

			<xsl:if test="position() != last()">
				<xsl:text>
</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="method">
		<xsl:param name="accessLevel"/>

		<xsl:text>
		</xsl:text>
		<xsl:value-of select="$accessLevel"/>
		<xsl:text> override function </xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>(</xsl:text>
		<xsl:call-template name="params">
			<xsl:with-param name="includeTypes">true</xsl:with-param>
		</xsl:call-template>
		<xsl:text>)</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="result/@type"/>
		<xsl:text> {
</xsl:text>
		<xsl:text>			</xsl:text>
		<xsl:if test="result[@type != 'void']">
			<xsl:text>return</xsl:text>
		</xsl:if>
		<xsl:text> invokeStub('</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>'</xsl:text>
		<xsl:call-template name="params">
			<xsl:with-param name="prependComma">true</xsl:with-param>
			<xsl:with-param name="includeTypes">false</xsl:with-param>
		</xsl:call-template>
		<xsl:text>);
		}</xsl:text>
	</xsl:template>

	<xsl:template match="constructor">
		<xsl:param name="accessLevel"/>

		<xsl:text>public function </xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>Stub(</xsl:text>
		<xsl:call-template name="params">
			<xsl:with-param name="includeTypes">true</xsl:with-param>
		</xsl:call-template>
		<xsl:text>)</xsl:text>
		<xsl:text> {
			super(</xsl:text>
		<xsl:call-template name="params">
			<xsl:with-param name="includeTypes">false</xsl:with-param>
		</xsl:call-template>
		<xsl:text>);
		}
</xsl:text>
	</xsl:template>


	<xsl:template name="params">
		<xsl:param name="prependComma">false</xsl:param>
		<xsl:param name="includeTypes"/>
		<xsl:for-each select="params/param">
			<xsl:if test="position()>1">
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:if test="position()=1 and $prependComma = 'true'">
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$includeTypes = 'false'"><xsl:value-of select="@name"/></xsl:when>
				<xsl:otherwise>
					<xsl:if test="@type">
						<xsl:if test="@type = 'restParam'">
							<xsl:text>...</xsl:text>
							<xsl:value-of select="@name"/>
						</xsl:if>
						<xsl:if test="@type != 'restParam'">
							<xsl:value-of select="@name"/>
							<xsl:text>:</xsl:text>
							
							<xsl:if test="@type = '*' or @type=''">
								<xsl:text>*</xsl:text>
							</xsl:if>
							<xsl:if test="@type != '*'">
								<xsl:value-of select="@type"/>
							</xsl:if>
						</xsl:if>
					</xsl:if>
					<xsl:if test="(string-length(@default) or @type='String') and @default!='unknown'">
						<xsl:text> = </xsl:text>
						<xsl:if test="@type='String' and @default!='null'">
							<xsl:text>"</xsl:text>
						</xsl:if>
						<xsl:value-of select="@default"/>
						<xsl:if test="@type='String' and @default!='null'">
							<xsl:text>"</xsl:text>
						</xsl:if>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>