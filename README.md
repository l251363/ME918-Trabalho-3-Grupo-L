
<!-- README.md is generated from README.Rmd. Please edit that file -->

# me918-trabalho3-grupoL

Olá, querido usuário! O objetivo deste produto é criar uma API
utilizando o pacote plumber no contexto de interação com banco de dados,
regressão linear e predições. Para isso, fique atento às seguintes
instruções.

### Configuração inicial: Banco de dados

O banco de dados que será manipulado pela API contém 25 observações
sobre 4 variáveis, sendo elas:

- x, uma variável numérica contínua;
- grupo, uma variável categórica com valores possíveis A, B e C;
- y, a variável resposta, numérica e contínua;
- momento_registro, contém uma data com o momento em que esse registro
  foi inserido na tabela.

A variável x é a combinação de uma Poisson com lambda igual a 4 e uma
uniforme entre -3 e 3. Já o grupo é uma amostra aleatória com reposição.
A variável resposta y é uma normal dada por “rnorm(n, mean = b0 + b1*x +
bB*(grupo==”B”) + bC\*(grupo==“C”), sd = 2)“, onde b0 e b1 são uniformes
entre -2 e 2, bB é o beta associado ao grupo B que vale 2, e bC é o
associado ao grupo C, igual a 3.

O banco de dados é armazenado em um arquivo csv.

### Etapa 1: Rota para registros de novos dados

Com a API rodando e assumindo que o usuário está acessando a rota de
alguma forma, para adicionar uma nova observação, como x = 1.5, grupo =
A e y = 3, o usuário deve acessar a seguinte url (substituindo xxxx pela
porta em que o servidor está rodando)

<a
href="http://127.0.0.1:xxxx/nova_observacao?x=1.5&amp;grupo=A&amp;y=3.0"
class="uri">http://127.0.0.1:xxxx/nova_observacao?x=1.5&amp;grupo=A&amp;y=3.0</a>

Note que a inclusão de novos registros é nossa única forma de interação
com o banco de dados, logo, se inserirmos alguma observação
incorretamente, alterações como deleção ou modificação de linhas não
poderão ser requisitadas.

### Etapa 2: Rotas para inferências (2 eletivas)

Tanto para gerar o gráfico de dispersão com a reta de regressão quanto
para obter as estimativas dos parâmetros envolvidos na reta de regressão
basta executar a rota correspondente, o que seria equivalente a acessar,
com a API rodando, as seguintes urls:

1)  <a href="http://127.0.0.1:xxxx/grafico"
    class="uri">http://127.0.0.1:xxxx/grafico</a>

2)  <a href="http://127.0.0.1:xxxx/regressao"
    class="uri">http://127.0.0.1:xxxx/regressao</a>

Além disso, o usuário também pode acessar outras 3 rotas nessa etapa
para obter informações sobre os resíduos do modelo de regressão e
significância estatística dos parâmetros envolvidos, apenas acessando as
rotas ou as seguintes urls:

3)  <a href="http://127.0.0.1:xxxx/residuos"
    class="uri">http://127.0.0.1:xxxx/residuos</a>

4)  <a href="http://127.0.0.1:xxxx/graficos_residuos"
    class="uri">http://127.0.0.1:xxxx/graficos_residuos</a>

5)  <a href="http://127.0.0.1:xxxx/significancia"
    class="uri">http://127.0.0.1:xxxx/significancia</a>

### Etapa 3: Rotas para predição

Para realizar predição do modelo ajustado, o usuário pode utilizar a
rota correspondente fornecendo a url abaixo, para o caso x = 2 e grupo B

<a href="http://127.0.0.1:xxxx/predicao?x=2.0&amp;grupo=B"
class="uri">http://127.0.0.1:xxxx/predicao?x=2.0&amp;grupo=B</a>
