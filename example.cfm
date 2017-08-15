<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>LaTeX CFC Example</title>
<cfparam name="math" default="\sqrt{\frac{n}{n-1} S}">
<!--- look on: http://es.wikipedia.org/wiki/LaTeX
for more math expressions examples...

more math expressions for you can try:

<cfset math="\begin{matrix}A\xrightarrow{\;\;\;f\;\;\;}B\\\pi\downarrow{\;\;\;\;\;}\;\;\;\uparrow{} \phi\\C\xrightarrow{\;\;\;g\;\;\;}D\end{matrix}">
<cfset math="f(x)=\begin{cases} \begin{matrix} 0 & si\; x>0 \\ x^2 & si\;no \end{matrix} \end{cases}">

--->
</head>

<body>
<!--- --->
<cfset reldir="/">
<cfset filegraf=ExpandPath(reldir) & "formula.png">
<cfset latex=CreateObject("component","latex").init(math).render2file(filegraf)>
<cfset latex.setFormula(math).render2file(filegraf)>
<!--- --->
<h1>LaTeX CFC Formula Renderer</h1>
<cfoutput>
<form action="example.cfm" method="post">
Enter your LaTeX math formula:<br />
<textarea name="math" rows="5" cols="50">
#math#
</textarea><br />
<input type="submit" value="Render image"/>
</form><br />
<img src="#reldir#formula.png" alt="#math#"/>
</cfoutput>
<!--- --->
</body>
</html>