*TALLER 1
cls
*Punto 1
cd "/Users/valeria/Desktop/202310/Econometría 2/Taller 1"
use "Agresiones.dta", clear

*a) Estimar los modelos
*Modelo 1
reg lnpib_total agresiones IPM discapital disbogota areaoficialkm2 altura
outreg2 using "Regresiones1punto1a.doc", label title(Regresion 1 MCO) replace
*Modelo 2
reg lnpib_total lnagresiones IPM discapital disbogota areaoficialkm2 altura
outreg2 using "Regresiones2punto1a.doc", label title(Regresion 2 MCO) replace

*b) Prueba J de Davidson y Mackinnon
*Prueba de Modelos Anidados
reg lnpib_total agresiones IPM discapital disbogota areaoficialkm2 altura
	predict yA,
reg lnpib_total lnagresiones IPM discapital disbogota areaoficialkm2 altura yA
outreg2 using "Regresiones1punto1b.doc", label title(Regresion 1 Prueba J) replace

	test yA
	 
reg lnpib_total lnagresiones IPM discapital disbogota areaoficialkm2 altura	
	predict yB
reg lnpib_total agresiones IPM discapital disbogota areaoficialkm2 altura yB 
outreg2 using "Regresiones2punto1b.doc", label title(Regresion 2 Prueba J) replace
	ttest yB==0

*c) Prueba RESET de Ramsey
reg lnpib_total lnagresiones IPM discapital disbogota areaoficialkm2 altura
	estat ovtest
outreg2 using "Regresionesresetpunto1c.doc", label title(Regresion  Prueba RESET) replace
	*Si hay variables omitidas, rechazo h0
	
*d) Prueba del Multiplicador de Lagrange
*Prueba para variable omitida	
reg lnpib_total lnagresiones IPM discapital disbogota areaoficialkm2 altura
	predict r_2, residual
reg r_2 lnagresiones IPM discapital disbogota areaoficialkm2 altura nbi
	scalar ML=e(N)*e(r2)
	scalar prob=chi2tail(1,ML)
	scalar list ML prob
outreg2 using "RegresionesMLpunto1d.doc", label title(Regresion  Prueba ML) replace
	*Hay sesgo de especificación por variable omitida. NBI si es relevante para el modelo

*e) Endogeneidad en la variable agresiones

*f) Beneficios o perjuicios de usar agresionespercap en el modelo

*g) Proponga el mejor modelo para analizar esta relación e interprete
reg lnpib_total lnagresiones IPM discapital disbogota areaoficialkm2 altura nbi agresiones_percap
outreg2 using "Regresionespunto1g.doc", label title(Regresion) replace

*Punto 2
cls
clear all
use "website.dta", clear

*a) Estimar modelo por MCO
reg visits ad female time
outreg2 using "Regresion1punto2a.doc", label title(Regresion MCO) replace

*b) Explicar endogeneidad de variable TIME

*c) Justificar si los instrumentos son relevantes y válidos

*d)Realice estimación con el instrumento Phone
	ivregress2 2sls visits (time=phone) ad female, first
est restore first
	outreg2 using "RegresionIVprimeraetapa.doc", label title(IV Primera etapa) replace
ivregress 2sls visits (time=phone) ad female, first
	outreg2 using "RegresionIVsegundaetapa.doc", label title(IV Segunda etapa) replace

*Test para probar relevancia
	reg time ad female phone
	*Se realiza la prueba de significancia conjunta
	test phone
	outreg2 using "Regresionpunto2d.doc", label title(Relevancia IV) replace

*Test para probar exogeneidad
	regress visits ad female time
	est store mco
	ivregress 2sls visits (time= phone) ad female
	est store iv
	hausman iv mco, sigmamore
*Test instrumentos débiles
reg time phone ad female,r	


*e) Estimacion con los dos instrumentos
ivregress2 2sls visits (time=phone frfam) ad female, first
est restore first
	outreg2 using "RegresionIV2primeraetapa.doc", label title(IV Primera etapa) replace
ivregress 2sls visits (time=phone frfam) ad female, first
	outreg2 using "RegresionIV2segundaetapa.doc", label title(IV Segunda etapa) replace
	
*Test instrumentos débiles
reg time phone frfam ad female,r
*Test para probar relevancia
	reg time ad female frfam phone
	*Se realiza la prueba de significancia conjunta
	test frfam phone
	outreg2 using "Regresionpunto2e.doc", label title(Relevancia IV) replace
*Test de validez
	ivreg visits (time= phone frfam) ad female
	predict res, residuals
	reg res phone frfam ad female
	scalar ml=e(N)*e(r2)
	scalar prob=chi2tail(1,ml)
	scalar list ml prob
	outreg2 using "Regresionvalidezpunto2e.doc", label title(Validez IV) replace

*f)Comparar resultados y escoger mejor modelo

















