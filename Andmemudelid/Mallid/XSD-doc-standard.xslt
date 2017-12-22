<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://vabavara.eu/xsdetails"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml"
>
  <xsl:output method="xml" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.1//EN"
              doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" encoding="utf-8" />

  <xsl:template match="/xs:schema">
    <html xml:lang="et-ee">
      <head>
        <meta http-equiv="Content-Type" content="application/xhtml;encoding=utf-8"/>
        <link href="../Mallid/XSD-css.css" type="text/css" rel="stylesheet"/>
        <title>Andmete dokumentatsioon</title>
      </head>
      <body>
        <h1>Andmestandardi dokumentatsioon</h1>
        <xsl:if test="./xs:annotation/xs:documentation/text()">
          <p>
            <xsl:value-of select="./xs:annotation/xs:documentation/text()"/>
          </p>
        </xsl:if>
        <h2>Nimeruumid</h2>
        <table class="ns-table">
          <thead>
            <tr>
              <th>Eesliide</th>
              <th>Nimeruum</th>
            </tr>
          </thead>
          <tbody>
            <!-- Default namespace (no prefix) -->
            <xsl:if test="namespace::*[local-name(.)='']">
              <xsl:variable name="ns" select="namespace::*[local-name(.)='']"/>
              <tr>
                <td>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="/xs:schema/@targetNamespace and $ns=normalize-space(/xs:schema/@targetNamespace)">
                      <span class="targetNS">
                        <xsl:value-of select="$ns"/>
                      </span>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$ns"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </xsl:if>
            <!-- Namespaces with prefixes -->
            <xsl:for-each select="namespace::*[local-name(.)!='']">
              <xsl:variable name="prefix" select="local-name(.)"/>
              <xsl:variable name="ns" select="."/>
              <tr>
                <td>
                  <xsl:value-of select="$prefix"/>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="/xs:schema/@targetNamespace and $ns=normalize-space(/xs:schema/@targetNamespace)">
                      <span class="targetNS">
                        <xsl:value-of select="$ns"/>
                      </span>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$ns"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
        <xsl:if test="./xs:element">
          <h2>Elemendid (kirjed)</h2>
          <!-- list elements defined in the schema -->
          <table>
            <thead>
              <tr>
                <th>..</th>
                <th>Element</th>
                <th>Tüüp</th>
                <th>Tähendus</th>
                <th>Märkmed</th>
                <th>Probleemid</th>
                <th>Kasutuslood</th>
              </tr>
            </thead>
            <tbody>
              <xsl:apply-templates select="xs:element" mode="list"/>
            </tbody>
          </table>
        </xsl:if>
        <xsl:if test="./xs:complexType|./xs:simpleType">
          <h2>Tüübid</h2>
          <!-- list types defined in the schema -->
          <table>
            <thead>
              <tr>
                <th>Tüüp</th>
                <th>Tähendus</th>
                <th>Märkmed</th>
                <th>Probleemid</th>
                <th>Kasutuslood</th>
              </tr>
            </thead>
            <tbody>
              <xsl:apply-templates select="xs:complexType" mode="list"/>
              <xsl:apply-templates select="xs:simpleType" mode="list"/>
            </tbody>
          </table>
        </xsl:if>
        <xsl:if test="./xs:element">
          <h2>Elemendid</h2>
          <xsl:apply-templates select="./xs:element" mode="typedetails"/>
        </xsl:if>
        <xsl:if test="./xs:complexType|./xs:simpleType">
          <h2>Andmetüübid</h2>
          <xsl:apply-templates select="./xs:complexType" mode="typedetails"/>
          <xsl:apply-templates select="./xs:simpleType" mode="typedetails"/>
        </xsl:if>
        <xsl:if test="./xs:attributeGroup">
          <h2>Grupid</h2>
          <!-- list attribute groups defined in the schema -->
          <xsl:apply-templates select="./xs:attributeGroup"/>
        </xsl:if>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="xs:element" mode="list">
    <xsl:variable name="docdetails" select="xs:annotation/xs:documentation/xsd:documentationDetails"/>
    <tr>
      <td>
        <xsl:choose>
          <xsl:when test="@minOccurs">
            <xsl:value-of select="@minOccurs"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>1</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>..</xsl:text>
        <xsl:choose>
          <xsl:when test="@maxOccurs and (@maxOccurs = 'unbounded')">
            <xsl:text>*</xsl:text>
          </xsl:when>
          <xsl:when test="@maxOccurs">
            <xsl:value-of select="@maxOccurs"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>1</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:if test="@name">
      <td id="el{@name}">
        <xsl:value-of select="@name"/>
      </td>
      </xsl:if>
      <xsl:if test="@ref"><td>
        <xsl:value-of select="@ref"/>
      </td></xsl:if>
      <td>
        <xsl:if test="@type">
          <xsl:variable name="typeName" select="@type"/>
          <xsl:choose>
            <xsl:when test="/*[1]/*[@name = $typeName]">
              <a title="{@type} kirjeldus" href="#type{@type}">
                <xsl:value-of select="@type"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@type"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="@ref">
          <xsl:variable name="typeName" select="@ref"/>
          <xsl:choose>
            <xsl:when test="/*[1]/*[@name = $typeName]">
              <a title="{@ref} kirjeldus" href="#el{@ref}">
                <xsl:value-of select="@ref"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@ref"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="xs:complexType">
          <xsl:apply-templates select="xs:complexType" mode="typedetails"/>
        </xsl:if>
        <xsl:if test="xs:simpleContent/xs:extension">
          <xsl:value-of select="xs:simpleContent/xs:extension/@base"/>
          <br/>
          <xsl:apply-templates select="xs:simpleContent/xs:extension" mode="typedetails"/>
        </xsl:if>
      </td>
      <xsl:call-template name="docdetails">
        <xsl:with-param name="docdetails" select="$docdetails"/>
      </xsl:call-template>
    </tr>
  </xsl:template>

  <xsl:template match="xs:complexType" mode="list">
    <xsl:variable name="docdetails" select="xs:annotation/xs:documentation/xsd:documentationDetails"/>
    <tr>
      <td>
        <a href="#type{@name}" title="{@name} ehitus">
          <xsl:value-of select="@name"/>
        </a>
      </td>
      <xsl:call-template name="docdetails">
        <xsl:with-param name="docdetails" select="$docdetails"/>
      </xsl:call-template>
    </tr>
  </xsl:template>

  <xsl:template match="xsd:note|xsd:issue|xsd:useCase">
    <tr>
      <td>
        <xsl:if test="@time">
          <xsl:value-of select="@time"/>
        </xsl:if>
      </td>
      <td>
        <xsl:if test="@author">
          <xsl:value-of select="@author"/>
        </xsl:if>
      </td>
      <td>
        <xsl:copy-of select="."/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="xs:sequence|xs:choice|xs:all" mode="typedetails">
    <div class="str{local-name()}">
      <xsl:if test="@minOccurs or @maxOccurs">
        <xsl:choose>
          <xsl:when test="@minOccurs">
            <xsl:value-of select="@minOccurs"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>1</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>..</xsl:text>
        <xsl:choose>
          <xsl:when test="@maxOccurs and (@maxOccurs = 'unbounded')">
            <xsl:text>*</xsl:text>
          </xsl:when>
          <xsl:when test="@maxOccurs">
            <xsl:value-of select="@maxOccurs"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>1</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="xs:annotation/xs:documentation">
        <table>
          <xsl:call-template name="docdetails">
            <xsl:with-param name="docdetails" select="xs:annotation/xs:documentation/xsd:documentationDetails"/>
          </xsl:call-template>
        </table>
      </xsl:if>
      <xsl:if test="xs:element">
        <table>
          <thead>
            <tr>
              <th>
                <xsl:text>..</xsl:text>
                <xsl:choose>
                  <xsl:when test="local-name(.) = 'choice'">valik</xsl:when>
                  <xsl:when test="local-name(.) = 'sequence'">järjestatud</xsl:when>
                </xsl:choose>
              </th>
              <th>Element</th>
              <th>Tüüp</th>
              <th>Tähendus</th>
              <th>Märkmed</th>
              <th>Probleemid</th>
              <th>Kasutuslood</th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select="xs:element" mode="list"/>
          </tbody>
        </table>
      </xsl:if>
      <xsl:apply-templates select="xs:sequence|xs:choice|xs:all" mode="typedetails"/>
    </div>
  </xsl:template>

  <xsl:template match="xs:element" mode="typedetails">
    <xsl:param name="mainentry" select="true()"/>
    <xsl:choose>
      <xsl:when test="$mainentry">
        <h3  id="el_{@name}">
          <xsl:value-of select="./@name"/>
        </h3>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:value-of select="./@name"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="*" mode="typedetails"/>
    <xsl:if test="@type">
      <xsl:variable name="type" select="@type"/>
      <p>
        <xsl:value-of select="@type"/>
      </p>
      <xsl:apply-templates select="/*[1]/xs:complexType[@name = $type]" mode="typedetails">
        <xsl:with-param name="mainentry" select="false()"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="/*[1]/xs:simpleType[@name = $type]" mode="typedetails">
        <xsl:with-param name="mainentry" select="false()"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xs:complexType|xs:extension" mode="typedetails">
    <xsl:param name="mainentry" select="true()"/>
    <xsl:choose>
      <xsl:when test="$mainentry">
        <h3  id="type{@name}">
          <xsl:value-of select="./@name"/>
        </h3>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:value-of select="./@name"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    <div class="typedetails">
      <xsl:if test="./xs:annotation/xs:documentation/xsd:documentationDetails/@version">
        <h4>Versioon</h4>
        <xsl:value-of select="./xs:annotation/xs:documentation/xsd:documentationDetails/@version"/>
      </xsl:if>
      <xsl:if test="./xs:annotation/xs:documentation/xsd:documentationDetails/@state">
        <h4>Olek</h4>
        <xsl:value-of select="./xs:annotation/xs:documentation/xsd:documentationDetails/@state"/>
      </xsl:if>
      <xsl:if test="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:interpretation">
        <h4>Tõlgendus</h4>
        <xsl:apply-templates select="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:interpretation"/>
      </xsl:if>
      <xsl:if test="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:useCases">
        <h4>Kasutuslood</h4>
        <xsl:apply-templates select="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:useCases/xsd:useCase"/>
      </xsl:if>
      <xsl:if test="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:issues">
        <h4>Probleemid</h4>
        <xsl:apply-templates select="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:issues/xsd:issue"/>
      </xsl:if>
      <xsl:if test="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:standardisationNotes">
        <h4>Märkused</h4>
        <xsl:value-of select="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:standardisationNotes/xsd:note"/>
      </xsl:if>
      <xsl:if test="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:usedBy">
        <h4>Kasutuses</h4>
        <ol>
          <xsl:for-each select="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:usedBy">
            <li>
              <a href="{@externalHref}" title="{@href}">
                <xsl:value-of select="@name"/>
              </a>
            </li>
          </xsl:for-each>
        </ol>
      </xsl:if>
      <xsl:if test="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:relatedDocumentation">
        <h4>Seotud dokumentatsioon</h4>
        <ol>
          <xsl:for-each select="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:relatedDocumentation">
            <li>
              <a href="{@externalHref}" title="{@href}">
                <xsl:value-of select="@name"/>
              </a>
              <xsl:text> </xsl:text>
              <xsl:value-of select="@relation"/>
            </li>
          </xsl:for-each>
        </ol>
      </xsl:if>
      <xsl:if test="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:example">
        <h4>Näited</h4>
        <xsl:value-of select="./xs:annotation/xs:documentation/xsd:documentationDetails/xsd:example"/>
      </xsl:if>
    </div>
    <div>
      <xsl:if test="xs:attribute|xs:attributeGroup">
        <!--<h3>Attributes</h3>-->
        <table class="attributes">
          <thead>
            <tr>
              <th>Nimi</th>
              <th>Tüüp</th>
              <th>Tähendus</th>
              <th>Märkmed</th>
              <th>Probleemid</th>
              <th>Kasutuslood</th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select="xs:attribute" mode="list"/>
            <xsl:apply-templates select="xs:attributeGroup/xs:attribute" mode="list">
              <xsl:with-param name="referred" select="true()"/>
            </xsl:apply-templates>
            <xsl:variable name="nameref" select="xs:attributeGroup/@ref"/>
            <xsl:apply-templates select="/*[1]/xs:attributeGroup[@name = $nameref]/xs:attribute" mode="list">
              <xsl:with-param name="referred" select="true()"/>
            </xsl:apply-templates>
          </tbody>
        </table>
      </xsl:if>
      <xsl:apply-templates select="xs:complexType|xs:sequence|xs:choice|xs:all" mode="typedetails"/>
      <xsl:if test="./*/xs:extension">
        <xsl:variable select="./*/xs:extension/@base" name="baseTypeName"/>
        <p>
          <xsl:text>Aluseks tüüp </xsl:text>
          <a href="#type{$baseTypeName}" title="Tüübi {$baseTypeName} kirjeldus">
            <xsl:value-of select="$baseTypeName"/>
          </a>
          <xsl:text>.</xsl:text>
        </p>
        <div class="basetype">
          <xsl:apply-templates select="/*/xs:complexType[./@name = $baseTypeName]" mode="typedetails">
            <xsl:with-param name="mainentry" select="false()"/>
          </xsl:apply-templates>
        </div>
        <xsl:apply-templates select="./*/xs:extension" mode="typedetails">
          <xsl:with-param name="mainentry" select="false()"/>
        </xsl:apply-templates>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="xs:attribute" mode="list">
    <xsl:param name="referred" select="false()"/>
    <xsl:variable name="docdetails" select="xs:annotation/xs:documentation/xsd:documentationDetails"/>
    <xsl:variable name="use">
      <xsl:choose>
        <xsl:when test="@use">
          <xsl:value-of select="@use"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>optional</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr class="use{$use}">
      <td>
        <xsl:if test="$referred">
          <xsl:attribute name="class">referred</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="@name"/>
      </td>
      <td>
        <xsl:if test="@type">
          <xsl:variable name="typeName" select="@type"/>
          <xsl:choose>
            <xsl:when test="/*[1]/*[@name = $typeName]">
              <a title="{@type} kirjeldus" href="#type{@type}">
                <xsl:value-of select="@type"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@type"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="@ref">
          <xsl:variable name="typeName" select="@ref"/>
          <xsl:choose>
            <xsl:when test="/*[1]/*[@name = $typeName]">
              <a title="{@ref} kirjeldus" href="#el{@ref}">
                <xsl:value-of select="@ref"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@ref"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="@default">
          <xsl:text>(vaikimisi </xsl:text>
          <xsl:value-of select="@default"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </td>
      <xsl:call-template name="docdetails">
        <xsl:with-param name="docdetails" select="$docdetails"/>
      </xsl:call-template>
    </tr>
    <xsl:if test="xs:simpleType">
      <tr class="typeDetails">
        <td>
          <xsl:apply-templates select="xs:simpleType" mode="typedetails"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template name="docdetails">
    <xsl:param name="docdetails" select="."/>
    <td>
      <xsl:if test="$docdetails/xsd:interpretation">
        <xsl:copy-of select="$docdetails/xsd:interpretation"/>
      </xsl:if>
    </td>
    <td>
      <xsl:if test="xs:annotation/xs:documentation/text()">
        <xsl:copy-of select="xs:annotation/xs:documentation/text()"/>
      </xsl:if>
      <xsl:if test="$docdetails/xsd:standardisationNotes">
        <table class="notes">
          <xsl:apply-templates select="$docdetails/xsd:standardisationNotes/xsd:note"/>
        </table>
      </xsl:if>
    </td>
    <td>
      <xsl:if test="$docdetails/xsd:issues">
        <table class="notes issue">
          <xsl:apply-templates select="$docdetails/xsd:issues/xsd:issue"/>
        </table>
      </xsl:if>
    </td>
    <td>
      <xsl:if test="$docdetails/xsd:useCases">
        <table class="notes case">
          <xsl:apply-templates select="$docdetails/xsd:useCases/xsd:useCase"/>
        </table>
      </xsl:if>
    </td>
  </xsl:template>
</xsl:stylesheet>
