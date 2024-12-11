//Taller 2
cls
*Punto 1
cd "/Users/valeria/Desktop/202310/Econometría 2/Taller 2"
use "politica.dta", clear
//a) 
mean lnw , over(politica anho)
mat medias= e(b)
mat2txt , matrix(medias) saving(tabla1a) title(Promedio de lnw) replace
reg lnw politica
twoway (scatter lnw politica if anho==2020) (lfit lnw politica if anho==2020)(scatter lnw politica if anho==2022) (lfit 	lnw politica if anho==2022)
asdoc ttest lnw if politica==0, by(anho) unequal
//b)
scalar dif_dif= (medias[1,4] - medias[1,3]) - (medias[1,2] - medias[1,1])
scalar list dif_dif
reg lnw i.politica##i.anho
outreg2 using "RegresionBpooledmco.doc", label title(MCO Combinados) replace
display _b[1.politica#2022.anho]

//c) 
//d)
reg lnw i.politica##i.anho profesional rural
display _b[1.politica#2022.anho]
outreg2 using "RegresionDpooledmco.doc", label title(MCO Combinados) replace
//e)


*Punto 2
cls
use "trabajo_fem.dta", clear
//a)
//b) Estimar por MPL
reg trabaja educ_padre educ_madre hijos_vivos
outreg2 using "Regresion2b.doc", label title(Regresion MPL) replace
//c)
//d)
predict pr_mco, xb
scatter pr_mco hijos_vivos
//e)
reg trabaja educ_padre educ_madre hijos_vivos, robust
asdoc imtest, white, save(Heterocedasticidad.doc) replace
outreg2 using "Regresion2e.doc", label title(Regresion errores robustos) replace
//f) 
//Para logit
logit trabaja educ_padre educ_madre hijos_vivos
outreg2 using "Regresion2fl.doc", label title(Regresion Logit) replace
margins , dydx(_all)
asdoc margins, dydx(*) atmeans save(Logit_margins.doc) replace
margins,dydx(_all) at (educ_padre=3 educ_madre=10 hijos_vivos=0)
asdoc margins, dydx(*) at (educ_padre=3 educ_madre=10 hijos_vivos=0) save(Logit_margins_punto.doc) replace
estat classification
//Para probit 
probit trabaja educ_padre educ_madre hijos_vivos
outreg2 using "Regresion2fp.doc", label title(Regresion Probit) replace
margins , dydx(_all)
asdoc margins, dydx(*) atmeans save(Probit_margins.doc) replace
margins,dydx(_all) at (educ_padre=3 educ_madre=10 hijos_vivos=0)
asdoc margins, dydx(*) at (educ_padre=3 educ_madre=10 hijos_vivos=0) save(Probit_margins_punto.doc) replace
estat classification
//g)
reg trabaja educ_padre educ_madre i.hijos_vivos, robust
outreg2 using "Regresion2g.doc", label title(Regresion Especificacion) replace









