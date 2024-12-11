//Taller 3
cls
cd "/Users/valeria/Desktop/202310/Econometría 2/Taller 3"
use "WDI.dta", clear
*Punto 1
*a) MCO como pool de datos
xtset id year
gen lGDP = ln(GDP)
gen lLabor = ln(Labor)
gen lCapital = ln(Capital)
reg lGDP lLabor lCapital
estimates store reg1
outreg2 using "Regresion1A.doc", replace ctitle(MCO Combinados)
*Efectos Fijos Within
xtset id year
xtreg lGDP lLabor lCapital, fe
estimates store reg2
outreg2 using "Regresion1A.doc",append ctitle(Efectos Fijos)

*b) Prueba estadística
//Puntos porcentuales F 
reg lGDP lLabor lCapital i.id
testparm i.id

*c) Variables dummy
reg lGDP lLabor lCapital i.id
outreg2 using "Regresion1B.doc", label title(Modelo LSDV) replace


*Punto 2
*a) Gráfica serie de tiempo Colombia
keep if id==42
tsset year
tsline GDP, name(serie, replace)

*b) Ciclos y tendencias

ssc install hprescott
hprescott GDP, stub(GDP_hp) smooth(100)
// Para ponerle tendencia y ciclo
tsline GDP GDP_hp_GDP_sm_1 , name(tendencia, replace) title(Tendencia)
tsline GDP_hp_GDP_1 , name(ciclo, replace ) title(Ciclo)

*c) Indicar 2 modelos de tendencia determinística
//Cuadrática
		reg GDP c.year##c.year
		predict GDP_sq2
		tsline GDP_sq GDP_sq2 GDP, name(g2, replace) title(Cuadrática: y=b0+b1t+b2t^2+u)
//Log-lin
		gen lGDP=ln(GDP)
		reg lGDP year
		predict ln_GDP
		gen GDP_loglin=exp(ln_GDP)
		tsline GDP_loglin GDP_loglin GDP, name(g3, replace) title(Log lin: ln(y)=b0+b1t+u)
		gen lyear=ln(year)
//Matriz Akaike

	reg GDP year 
	estat ic 
	mat akaike=r(S)
	reg GDP c.year##c.year
	estat ic 
	mat akaike=akaike\r(S)
	reg lGDP year 
	estat ic 
	mat akaike=akaike\r(S)
	reg GDP lyear
	estat ic 
	mat akaike=akaike\r(S)
	boxcox GDP year, model(theta)
	estat ic 
	mat akaike=akaike\r(S)

mat rownames akaike = linlin sq loglin linlog  boxcox
matlist akaike
//El mejor es el modelo LogLin porque es el estadistico AIC más pequeño

*d) Pronosticar valor del PIB para 2022
tsappend, add(1)
replace id = 42 if id==.
replace lGDP = ln(GDP) if lGDP==.
reg lGDP year in 1/22
predict GDP_loglin_2022
scalar pronostico_2022 = GDP_loglin_2022[23]
display  "Proyeccion 2023 PIB Colombia"
display pronostico_2022

scalar cambioporcentual = (exp(GDP_loglin_2022[23])/exp(GDP_loglin_2022[22]))-1
display cambioporcentual












