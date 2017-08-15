<!---
Name             : Coldfusion LaTeX Formula Renderer
Created          : September 18, 2012

Methods:
<cfset latex=CreateObject("component","latex").init()>

init([formula])												=	Inits the object with an optionally specified formula.
latex.setFormula("\sqrt{\frac{n}{n-1} S}")					=	Sets the given math formula.
currentFormula = latex.getFormula()							=	Gets the currently set math formula.
latex.render2file(ExpandPath("./") & "formula.png")			=	Renders the current math formula to the given file as PNG with alpha channel.
bufimage = latex.render2buf()								=	Renders the current math formula to a BufferedImage object.
--->
<cfcomponent output="no" hint="LaTeX Formula Renderer.">
	<cfset this.version = StructNew() />
	<cfset this.version.product = "LaTeX Formula Renderer" />
	<cfset this.version.version = "1.0" />
	<cfset this.version.releaseDate = "18/9/2012" />
	<cfset this.version.lastUpdate = "18/9/2012" /><!--- d/m/yyyy --->
    <cfset this.classdir=ExpandPath("./jlatexmath/")>
    <cfset this.namespace="co_latex">
    <cfset this.javaloader=CreateObject("component","javaloader.JavaLoader")>
    <cfset this.initialized = false />

	<cffunction name="init" access="public" output="no" returntype="any" hint="Instanciates the renderer.">
		<cfargument name="formula" type="string" required="no" default="" hint="Optional formula to be initialized."/>
        <cfset var clatex={}>
		<cfset var cp=ArrayNew(1)>
        <cfset this.formula=trim(arguments.formula)>
        <!--- define ClassPath for Javaloader --->
        <cfif not IsDefined("server.#this.namespace#")>
            <!--- define ClassPath for Javaloader --->
            <cfdirectory action="list" directory="#this.classdir#" filter="*.jar" recurse="no" name="cp_fs"/>
            <cfloop query="cp_fs">
                <cfset cp[arraylen(cp)+1] = this.classdir & cp_fs.name>
            </cfloop>
            <cfset StructInsert(server,this.namespace,this.javaloader.init(cp),true)> 
        </cfif>
        <cfset this.ref=Evaluate("server.#this.namespace#")>
		<!---- Init classes ---->
        <cfset clatex.TeXConstants=this.ref.create("org.scilab.forge.jlatexmath.TeXConstants")>
        <cfset clatex.TeXFormula=this.ref.create("org.scilab.forge.jlatexmath.TeXFormula")>
        <cfset clatex.TeXIcon=this.ref.create("org.scilab.forge.jlatexmath.TeXIcon")>
        <cfset clatex.BufferedImage=this.ref.create("java.awt.image.BufferedImage")>
        <cfset clatex.JLabel=this.ref.create("javax.swing.JLabel")>
        <cfset clatex.imageIO=this.ref.create("javax.imageio.ImageIO")>
        <cfset clatex.OutputStream=this.ref.create("java.io.FileOutputStream") /> 
        <cfset this.classes=clatex>
        <!--- --->
		<cfreturn this/>
	</cffunction>
    
    <cffunction name="setFormula" access="public" output="no" returntype="any" hint="Sets the math formula.">
		<cfargument name="formula" type="string" required="yes" default=""/>
        <cfset this.formula=trim(arguments.formula)>
        <cfreturn this/>
    </cffunction>
    
    <cffunction name="getFormula" access="public" output="no" returntype="string" hint="Gets the current math formula.">
        <cfreturn this.formula/>
    </cffunction>
    
    <!--- render methods --->
    <cffunction name="render2file" access="public" output="no" returntype="any" hint="Renders the current math formula to the given image file.">
		<cfargument name="file" type="string" required="yes" default="" hint="Image file where to render the current math formula"/>
        <cfset var dirfile=GetDirectoryFromPath(arguments.file)>
        <cfset var extfile=lcase(trim(ListLast(arguments.file,".")))>
        <cfset var tmp={}>
        <cfif not DirectoryExists(dirfile)>
        	<cfthrow type="latex:render2file:directoryDoesExist" message="the target directory (#dirname#) for the given render image file, does not exist."/>
        </cfif>
        <cfif trim(this.formula) eq "">
			<cfthrow type="latex:render2file:formulaNotDefined" message="You must first use method setFormula to define math formula to render, before using this method."/>
        </cfif>
		<cfif extfile neq "png">
			<cfthrow type="latex:render2file:fileFormatNotSupported" message="Only PNG file formats are supported. (you defined:#extfile#)."/>
        </cfif>
		<!--- continue rendering --->
		<!--- render to bufferedimage --->
		<cfset tmp.fomule = this.classes.TeXFormula.init(this.formula)>
        <cfset tmp.ti = tmp.fomule.createTeXIcon(this.classes.TeXConstants.STYLE_DISPLAY, 40)>
        <cfset tmp.b = this.classes.BufferedImage.init(tmp.ti.getIconWidth(), tmp.ti.getIconHeight(), this.classes.BufferedImage.TYPE_4BYTE_ABGR)>
        <cfset tmp.ti.paintIcon(this.classes.JLabel, tmp.b.getGraphics(), 0, 0)>
        <!--- to file --->
		<cfset tmp.outputfile = this.classes.OutputStream.init(arguments.file)>
        <cfset this.classes.imageIO.write(tmp.b, extfile, tmp.outputfile)>
        <cfreturn this/>
    </cffunction>
    
    <cffunction name="render2buf" access="public" output="no" returntype="any" hint="Renders the current math formula to a bufferedImage object.">
        <cfset var tmp={}>
        <cfif trim(this.formula) eq "">
			<cfthrow type="latex:render2file:formulaNotDefined" message="You must first use method setFormula to define math formula to render, before using this method."/>
        </cfif>
		<!--- continue rendering --->
		<!--- render to bufferedimage --->
		<cfset tmp.fomule = this.classes.TeXFormula.init(this.formula)>
        <cfset tmp.ti = tmp.fomule.createTeXIcon(this.classes.TeXConstants.STYLE_DISPLAY, 40)>
        <cfset tmp.b = this.classes.BufferedImage.init(tmp.ti.getIconWidth(), tmp.ti.getIconHeight(), this.classes.BufferedImage.TYPE_4BYTE_ABGR)>
        <cfset tmp.ti.paintIcon(this.classes.JLabel, tmp.b.getGraphics(), 0, 0)>
        <cfreturn tmp.b/>
    </cffunction>
    
</cfcomponent>