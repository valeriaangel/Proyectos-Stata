//Taller 4
cls
clear all
*Punto 1
cd "/Users/valeria/Desktop/202310/Econometría 2/Taller 4"
import excel using PIB_producción.xlsx, firstrow
*Base de 2005-1 hasta 2019-4
drop if Año == 2020
*B.1
gen tiempo=yq(Año, Trimestre)
tsset tiempo, q
tsappend, add(3)

///////////////////       1. Identificación        ///////////////////////
tsline Produccion, name(Produccion, replace) title(Serie Produccion)
corrgram Produccion 
ac Produccion, name (fac, replace)
pac Produccion, name (fap, replace)
gr combine fac fap, col(2) name(fac_fap, replace)
* Regla de schwert: nq-perron: (12*(T/100)^0.25): Cuántos rezagos incluir en la prueba? 11
dfuller Produccion, regress lags(11)
 

*Prueba con primera diferencia
corrgram d.Produccion
ac d.Produccion, name(fac_est, replace)
pac d.Produccion, name(fap_est, replace)
gr combine fac_est fap_est, title(dif Produccion)

dfuller d.Produccion, trend regress lags(1)
* Según la prueba de dickey y fuller el rezago 1 es significativo y con un nivel de significancia de 0.05 concluimos que la serie es estacionaria. 

///////////////////       2. Estimación      //////////////////////
**Candidato 1
arima Produccion, arima(2,1,1) vce(robust)
outreg2 using "arima211.doc"
estimates store a1 
armaroots 
	
estimates stat a1

predict residual, residuals 
corrgram residual 
wntestq residual

jb residual 

**Candidato 2
arima Produccion, arima(1,1,1) vce(robust)
outreg2 using "arima111.doc"
estimates store a1 

**Candidato 3
arima Produccion, arima(2,1,0) vce(robust)
outreg2 using "arima210.doc"
estimates store a1 
**Candidato 4
arima Produccion, arima(1,1,0) vce(robust)
outreg2 using "arima110.doc"
estimates store a2 
armaroots 
	
estimates stat a2

predict residual1, residuals 
corrgram residual1 
wntestq residual1

jb residual 

///////////////////     3. Validación     ///////////////////////
ssc install armaroots
armaroots 
	
estimates stat a1

predict residual, residuals 
corrgram residual 
wntestq residual
	* H0: es Ruido Blanco

ssc install jb
jb residual 
*Matriz Akaike

// Para comparar con criterio akaike
est stat _all

///////////////////       4. Pronóstico        /////////////////////
predict Produccionf, dynamic(tq(2019q4)) y
tsline Produccion Produccionf
