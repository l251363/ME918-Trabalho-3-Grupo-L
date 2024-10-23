#
# This is a Plumber API. In RStudio 1.2 or newer you can run the API by
# clicking the 'Run API' button above.
#
# In RStudio 1.1 or older, see the Plumber documentation for details
# on running the API.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(lubridate)
library(readr)
library(ggplot2)
#* @apiTitle Plumber Example API


#* Registra uma nova observação
#* @param x O valor da covariável numérica contínua
#* @param grupo O grupo categórico (A, B ou C)
#* @param y O valor da variável resposta
#* @post /nova_observacao
function(x, grupo, y) {
  

  if (!(grupo %in% c("A", "B", "C"))) {
    return(list(error = "Grupo inválido. Use A, B ou C."))
  }
  
 
  if (is.na(as.numeric(x))) {
    return(list(error = "Valor de 'x' deve ser numérico contínuo."))
  }
  

  if (is.na(as.numeric(y))) {
    return(list(error = "Valor de 'y' deve ser numérico contínuo."))
  }
  
 
  observacao <- data.frame(
    x = as.numeric(x),
    grupo = as.character(grupo),
    y = as.numeric(y),
    momento_registro = lubridate::now()
  )
  
  
  df <<- rbind(df, observacao)
  
 
  readr::write_csv(df, file = "dados_regressao.csv")
  
  return(list(status = "Observação inserida com sucesso", observacao = observacao))
}


#* Obter gráfico de dispersão com regressão
#* @serializer png
#* @get /grafico
function() {
  graf <- ggplot(df, aes(x = x, y = y, color = grupo)) +
    geom_point() +  # Gráfico de dispersão
    geom_smooth(method = "lm", se = FALSE) +  # Reta de regressão
    labs(title = "Gráfico de Dispersão com as retas de regressão por grupo",
         x = "X (Covariável)",
         y = "Y (Variável Resposta)",
         color = "Grupo") +
    theme_minimal()
  print(graf) 
}


#* Obter estimativas da regressão
#* @serializer json
#* @get /regressao
function() {

  modelo <- lm(y ~ x + grupo, data = df)
  

  coeficientes <- summary(modelo)$coefficients
  

  resultado <- list(
    intercepto = coeficientes[1, 1],
    Beta_x = coeficientes[2, 1],
    Beta_grupoB = coeficientes[3, 1],
    Beta_grupoC = coeficientes[4, 1]
  )
  

  return(resultado)
}


#* Obter todos os resíduos do modelo de regressão
#* @serializer json
#* @get /residuos
function() {

  modelo <- lm(y ~ x + grupo, data = df)
  

  residuos <- residuals(modelo)
  

  return(list(residuos = residuos))
}

library(ggplot2)
library(grid)

library(ggplot2)
library(grid)

#* Obter gráficos padrão de resíduos
#* @serializer png
#* @get /graficos_residuos
function() {

  modelo <- lm(y ~ x + grupo, data = df)
  

  par(mfrow = c(2, 2))  # Configura o layout para 2x2
  

  plot(modelo$fitted.values, residuals(modelo),
       main = "Resíduos vs Valores Ajustados",
       xlab = "Valores Ajustados",
       ylab = "Resíduos")
  abline(h = 0, lty = 2, col = "red")
  

  qqnorm(residuals(modelo))
  qqline(residuals(modelo), col = "red")

  

  plot(df$x, residuals(modelo),
       main = "Resíduos vs Covariável",
       xlab = "X (Covariável)",
       ylab = "Resíduos")
  abline(h = 0, lty = 2, col = "red")
  

  hist(residuals(modelo), breaks = 10, main = "Histograma dos Resíduos",
       xlab = "Resíduos", col = "lightblue", border = "black")
  

  dev.copy(png, "graficos_residuos.png")
  dev.off()
  
  return("Gráficos de resíduos gerados com sucesso e salvos como 'graficos_residuos.png'.")
}



#* Obter informações sobre a significância estatística dos parâmetros do modelo
#* @serializer json
#* @get /significancia
function() {

  modelo <- lm(y ~ x + grupo, data = df)
  

  resumo <- summary(modelo)
  

  significancia <- data.frame(
    Parametro = rownames(resumo$coefficients),
    Estimativa = resumo$coefficients[, 1],
    Erro_Estimado = resumo$coefficients[, 2],
    Valor_t = resumo$coefficients[, 3],
    p_valor = resumo$coefficients[, 4]
  )
  

  return(significancia)
}

#* Realizar predições com o modelo ajustado
#* @param x O valor da covariável numérica contínua
#* @param grupo O grupo categórico (A, B ou C)
#* @get /predicao
function(x, grupo) {
  

  if (!(grupo %in% c("A", "B", "C"))) {
    return(list(error = "Grupo inválido. Use A, B ou C."))
  }
  

  if (is.na(as.numeric(x))) {
    return(list(error = "Valor de 'x' deve ser numérico contínuo."))
  }
  

  nova_obs <- data.frame(x = as.numeric(x), grupo = as.factor(grupo))
  

  modelo <- lm(y ~ x + grupo, data = df)
  
  # Realizar a predição
  predicao <- predict(modelo, newdata = nova_obs)
  
  return(list(predicao = predicao))
}



