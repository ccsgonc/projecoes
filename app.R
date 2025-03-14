#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/

library(plotly)
library(shiny)
library(ggplot2)
library(dplyr)
library(readxl)
library(readr)
library(tidyverse)
library(bslib)
library(highcharter)
library(shinydashboard)
library(fresh)
library(openxlsx)

# options(repos = c(CRAN = "https://cran.rstudio.com/"))

# 
# pacotes <- c("shiny", "plotly", "ggplot2", "dplyr", "readxl", "readr", "tidyverse",
#              "bslib", "highcharter", "shinydashboard", "fresh", "openxlsx")
# 
# # Verifica se os pacotes ainda não foi instalados e, caso não, instala:
# 
# pacotes_instalados <- pacotes %in% rownames(installed.packages())
# if (any(pacotes_instalados == FALSE)) {
#   install.packages(pacotes[!pacotes_instalados])
# }
# 
# # carrega os pacotes instalados:
# 
# lapply(pacotes, library, character.only = TRUE)


# .libPaths(c(.libPaths(), "/srv/connect/apps/Projecoes_2025/packages"))


# Exportar

export <- list(
  list(text="PNG",
       onclick=JS("function () {
                this.exportChartLocal(); }")),
  list(text="JPEG",
       onclick=JS("function () {
                this.exportChartLocal({ type: 'image/jpeg' }); }"))
)

# Criar um tema personalizado
custom_theme <- create_theme(
  adminlte_color(
    light_blue = "#0080FF",  # Cor para o cabeçalho e barra lateral
    green = "#28a745",       # Cor dos botões e notificações
    red = "#dc3545"          # Cor de alertas ou destaques
  ),
  adminlte_sidebar(
    dark_bg = "#343a40",     # Cor de fundo da barra lateral
    dark_hover_bg = "#495057", # Cor ao passar o mouse nos itens da barra lateral
    dark_color = "#ffffff"   # Cor do texto da barra lateral
  ),
  adminlte_global(
    content_bg = "#f8f9fa",  # Cor de fundo do corpo do aplicativo
    box_bg = "#ffffff",      # Cor de fundo das caixas
    info_box_bg = "#e9ecef"  # Cor de fundo das info-boxes
  )
)

# UI

ui <-  dashboardPage(
  dashboardHeader(title = "Demografia FJP",
                  titleWidth = 540),
  dashboardSidebar(sidebarMenu(id = 'barra_lateral',
                               menuItem("Introdução", tabName = 'opcao0', icon = icon("gear")),
                               menuItem("Visão geral", tabName = 'opcao01', icon = icon("globe")),
                               menuItem("Pirâmides etárias", tabName = 'opcao1', icon = icon("people-group")),
                               menuItem("Razão de sexo e Taxas", tabName = 'opcao110', icon = icon("bolt")),
                               menuItem("Crescimento por idade", tabName = 'opcao111', icon = icon("chart-line")),
                               menuItem("Razão de dependência", tabName = 'opcao2', icon = icon("brain")),
                               menuItem("Outros indicadores", tabName = 'opcao3', icon = icon("people-roof")),
                               menuItem("Página final", tabName = 'opcao4', icon = icon("umbrella"))
                               )
                   ),
  dashboardBody(
    use_theme(custom_theme),
    tabItems(
      
      # 1 - Introdução
      tabItem(
        tabName = 'opcao0',
        div(style = "display: flex; justify-content: space-evenly; align-items: center",
            img(src = "Nova-Marca-FJP-sem-fundo.png", height = 100, width = 110),
            img(src = "fapemig.png", height = 100, width = 110)),
        h1("Resultados da projeção populacional dos municípios de Minas Gerais", 
           style = "
           margin-top: 50px;
           font-family: 'Arial'; 
           font-size: 26px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        p("Neste site são apresentados os resultados da projeção populacional dos municípios
          de Minas Gerais de 2022 até 2047. Em todas as abas à esquerda, é possível visualizar indicadores selecionados 
          a nível do município, da região intermediária e do porte populacional. Eles têm a funçaõ de 
          demonstrar a tendência demográfica dos municípios ao longo do período de projeção.", 
          style = "
          font-family: 'Arial'; 
          font-size: 22px; 
          font-weight: 600; 
          color: #333;
          text-align: justify;
          margin-top: 50px;
          "),
        p("1 - Na aba Visão geral, são apresentados os resultados do crescimento populacional absoluto por idade e sexo.", 
          style = "
          font-family: 'Arial'; 
          font-size: 18px; 
          font-weight: 600; 
          color: #333;
          text-align: justify;
          margin-top: 50px;
          "),
        p("2 - Na aba Pirâmides etárias, são apresentados as pirâmides etárias por idade e sexo.", 
          style = "
          font-family: 'Arial'; 
          font-size: 18px; 
          font-weight: 600; 
          color: #333;
          text-align: justify;
          margin-top: 25px;
          "),
        p("3 - Na aba Razão de Sexo e taxa de crescimento, são apresentados as razões de sexo por grupo etário e as taxas de crescimento entre anos projetados.
          A razão de sexo pode ser compreendida como a razão entre a quantidade de homens sobre a quantidade de mulheres, enquanto a taxa de crescimento representa o crescimento
          da população entre dois períodos.", 
          style = "
          font-family: 'Arial'; 
          font-size: 18px; 
          font-weight: 600; 
          color: #333;
          text-align: justify;
          margin-top: 25px;
          "),
        p("4 - Na aba Crescimento por idade, são apresentados o crescimento absoluto da população de 0 a 14, de 15 a 60 e de 60 ou mais anos.", 
          style = "
          font-family: 'Arial'; 
          font-size: 18px; 
          font-weight: 600; 
          color: #333;
          text-align: justify;
          margin-top: 25px;
          "),
        p("5 - Na aba Razão de dependência, são apresentadas a razão de dependência total (população com menos de 15 anos e população 
          com 65 anos ou mais dividido pela população de 15 a 64 anos), a razão de dependência idosa (população com 65 anos ou mais dividido 
          pela população de 15 a 64 anos), e a a razão de dependência jovem (população com menos de 15 anos dividido pela população de 15 a 64 anos).", 
          style = "
          font-family: 'Arial'; 
          font-size: 18px; 
          font-weight: 600; 
          color: #333;
          text-align: justify;
          margin-top: 25px;
          "),
        p("6 - Na aba Outros indicadores, são apresentados o índice de envelhecimento (população com 60, 65 e 80 anos ou mais dividida pela população com menso de 15
          anos), e o crescimento absoluto do percentual da população com 60 e 65 anos ou mais e da população com menso de 5 anos.", 
          style = "
          font-family: 'Arial'; 
          font-size: 18px; 
          font-weight: 600; 
          color: #333;
          text-align: justify;
          margin-top: 25px;
          ")
      ),
      
      # 2- Visão Geral
      tabItem(
        tabName = 'opcao01',
        
        h1("Crescimento absoluto da população de Minas Gerais por idade e sexo", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 24px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        h2("Resultados por município, região intermediária, porte populacional e agregado de Minas Gerais", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 20px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        
        # 🔹 Primeira linha de filtros para o Gráfico 1
        fluidRow(
          style = "margin-top: 25px;",
          box(width = 12, title = "Opções de filtro para o Gráfico 1",
              solidHeader = TRUE, status = "primary", collapsible = TRUE, collapsed = FALSE,
              
              fluidRow(
                column(width = 4,
                       selectInput(inputId = 'nivel_analise1',
                                   label = "Escolha o nível de análise:",
                                   choices = c("Minas Gerais" = "MG",
                                               "Município" = "nome_mn",
                                               "Região intermediária" = "nome_rg",
                                               "Porte populacional" = "portepop"))
                ),
                column(width = 4,
                       uiOutput("filtroUnidade1") # Filtro dinâmico (seleção única)
                ),
                column(width = 4,
                       selectInput(inputId = 'sexo1',
                                   label = "Escolha o sexo:",
                                   choices = c("Total", "Homens", "Mulheres"),
                                   selected = c("Total", "Homens", "Mulheres"),
                                   multiple = TRUE)
                )
              )
          )
        ),
        
        # 🔹 Segunda linha de filtros para o Gráfico 2
        fluidRow(
          box(width = 12, title = "Opções de filtro para o Gráfico 2",
              solidHeader = TRUE, status = "primary", collapsible = TRUE, collapsed = FALSE,
              
              fluidRow(
                column(width = 4,
                       selectInput(inputId = 'nivel_analise2',
                                   label = "Escolha o nível de análise:",
                                   choices = c("Minas Gerais" = "MG",
                                               "Município" = "nome_mn",
                                               "Região intermediária" = "nome_rg",
                                               "Porte populacional" = "portepop"))
                ),
                column(width = 4,
                       uiOutput("filtroUnidade2") # Filtro dinâmico (seleção única)
                ),
                column(width = 4,
                       selectInput(inputId = 'sexo2',
                                   label = "Escolha o sexo:",
                                   choices = c("Total", "Homens", "Mulheres"),
                                   selected = c("Total", "Homens", "Mulheres"),
                                   multiple = TRUE)
                )
              )
          )
        ),
        
        # 🔹 Exibição dos gráficos lado a lado
        fluidRow(
          box(
            width = 6, 
            title = "Gráfico 1",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput(outputId = 'grafico1', height = "500px")
          ),
          box(
            width = 6, 
            title = "Gráfico 2",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput(outputId = 'grafico2', height = "500px")
          )
        )
      ),
      
      # 3- Pirâmides
      tabItem(
        tabName = 'opcao1',
        
        h1("Pirâmides etárias da população de Minas Gerais projetada por idade e sexo", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 24px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        h2("Resultados por município, região intermediária, porte populacional e agregado de Minas Gerais", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 20px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        
        # 🔹 Primeira linha de filtros para a pirâmide etária 1
        fluidRow(
          style = "margin-top: 25px;",
          box(
            width = 12,
            title = "Opções de filtro para a pirâmide etária 1",
            solidHeader = TRUE,
            status = "primary",
            collapsible = TRUE,
            collapsed = FALSE,
            
            # 🔹 Filtros para seleção de escala, unidade e ano da pirâmide 1
            column(
              width = 4,
              selectInput("escala1", "Selecione a Escala (Pirâmide 1):",
                          choices = c(
                            "Minas Gerais" = "MG",
                            "Município" = "nome_mn",
                            "Região Intermediária" = "nome_rg",
                            "Porte Populacional" = "portepop"
                          )
              )
            ),
            column(
              width = 4,
              uiOutput("filtroEscala1") # Filtro dinâmico atualizado para nome_mn e nome_rg
            ),
            column(
              width = 4,
              selectInput("ano1", "Selecione o Ano (Pirâmide 1):",
                          choices = c(2022, 2025, 2026, 2027, 2032, 2037, 2042, 2047))
            )
          )
        ),
        
        # 🔹 Segunda linha de filtros para a pirâmide etária 2
        fluidRow(
          box(
            width = 12,
            title = "Opções de filtro para a pirâmide etária 2",
            solidHeader = TRUE,
            status = "primary",
            collapsible = TRUE,
            collapsed = FALSE,
            
            # 🔹 Filtros para seleção de escala, unidade e ano da pirâmide 2
            column(
              width = 4,
              selectInput("escala2", "Selecione a Escala (Pirâmide 2):",
                          choices = c(
                            "Minas Gerais" = "MG",
                            "Município" = "nome_mn",
                            "Região Intermediária" = "nome_rg",
                            "Porte Populacional" = "portepop"
                          )
              )
            ),
            column(
              width = 4,
              uiOutput("filtroEscala2") # Filtro dinâmico atualizado para nome_mn e nome_rg
            ),
            column(
              width = 4,
              selectInput("ano2", "Selecione o Ano (Pirâmide 2):",
                          choices = c(2022, 2025, 2026, 2027, 2032, 2037, 2042, 2047))
            )
          )
        ),
        
        # 🔹 Exibição dos gráficos de pirâmides etárias lado a lado
        fluidRow(
          box(
            width = 6,
            title = "Pirâmide etária 1",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput("piramideEtaria1", height = "500px")
          ),
          box(
            width = 6,
            title = "Pirâmide etária 2",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput("piramideEtaria2", height = "500px")
          )
        )
      ),
      
      # RS e TX
      tabItem(
        tabName = 'opcao110', 
        
        h1("Razão de sexo por idade e taxas de crescimento entre períodos da população projetada de Minas Gerais", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 24px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        h2("Resultados por município, região intermediária e porte populacional", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 20px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        
        # 🔹 Primeira linha de filtros para o Gráfico 1 (Indicadores)
        fluidRow(
          style = "margin-top: 25px;",
          box(
            width = 12,
            title = "Opções de filtro para razão de sexo",
            solidHeader = TRUE,
            status = "primary",
            collapsible = TRUE,
            collapsed = FALSE,
            
            # 🔹 Filtros para seleção de escala, unidade e ano
            column(
              width = 4,
              selectInput("escala_indicador110", "Selecione a Escala:",
                          choices = c(
                            "Município" = "nome_mn",
                            "Região Intermediária" = "nome_rg",
                            "Porte Populacional" = "id"
                          )
              )
            ),
            column(
              width = 4,
              uiOutput("filtroEscalaIndicador110") # Filtro dinâmico
            ),
            column(
              width = 4,
              selectInput("ano_indicador110", "Selecione o Ano:",
                          choices = c("2022", "2025", "2026", "2027", "2032", "2037", "2042", "2047"),
                          selected = "2022")
            )
          )
        ),
        
        # 🔹 Segunda linha de filtros para o Gráfico 2 (Taxas de Crescimento)
        fluidRow(
          box(
            width = 12,
            title = "Opções de filtro para taxas de crescimento",
            solidHeader = TRUE,
            status = "primary",
            collapsible = TRUE,
            collapsed = FALSE,
            
            # 🔹 Filtros para seleção de escala e unidade
            column(
              width = 4,
              selectInput("escala_taxa110", "Selecione a Escala:",
                          choices = c(
                            "Município" = "nome_mn",
                            "Região Intermediária" = "nome_rg",
                            "Porte Populacional" = "portepop"
                          )
              )
            ),
            column(
              width = 4,
              uiOutput("filtroEscalaTaxa110") # Filtro dinâmico
            )
          )
        ),
        
        # 🔹 Exibição dos gráficos lado a lado
        fluidRow(
          box(
            width = 6,
            title = "Razão de sexo",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput("grafico_indicador110", height = "500px")
          ),
          box(
            width = 6,
            title = "Taxas de crescimento",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput("grafico_taxa110", height = "500px")
          )
        )
      ),
      
      # CRESCIMENTO POR IDADE
      
      tabItem(
        tabName = 'opcao111',
        
        h1("Crescimento absoluto por grupos etários da população projetada de Minas Gerais", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 24px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        h2("Resultados por município, região intermediária e porte populacional", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 20px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        
        # 🔹 Primeira linha de filtros para o Gráfico 1
        fluidRow(
          style = "margin-top: 25px;",
          box(width = 12, title = "Opções de Filtro para o Gráfico 1",
              solidHeader = TRUE, status = "primary", collapsible = TRUE, collapsed = FALSE,
              fluidRow(
                column(width = 4,
                       selectInput(inputId = 'nivel_analise_pop1',
                                   label = "Escolha o nível de análise:",
                                   choices = c("Município" = "nome_mn",
                                               "Região Intermediária" = "nome_rg",
                                               "Porte Populacional" = "portepop"),
                                   selected = "nome_mn")
                ),
                column(width = 4,
                       uiOutput("filtroUnidade_pop1")
                ),
                column(width = 4,
                       selectInput("faixa_etaria_pop1", "Selecione a faixa etária:",
                                   choices = c("0-14", "15-59", "60+"),
                                   selected = c("0-14", "15-59", "60+"),
                                   multiple = TRUE)
                )
              )
          )
        ),
        
        # 🔹 Segunda linha de filtros para o Gráfico 2
        fluidRow(
          box(width = 12, title = "Opções de Filtro para o Gráfico 2",
              solidHeader = TRUE, status = "primary", collapsible = TRUE, collapsed = FALSE,
              fluidRow(
                column(width = 4,
                       selectInput(inputId = 'nivel_analise_pop2',
                                   label = "Escolha o nível de análise:",
                                   choices = c("Município" = "nome_mn",
                                               "Região Intermediária" = "nome_rg",
                                               "Porte Populacional" = "portepop"),
                                   selected = "nome_mn")
                ),
                column(width = 4,
                       uiOutput("filtroUnidade_pop2")
                ),
                column(width = 4,
                       selectInput("faixa_etaria_pop2", "Selecione a faixa etária:",
                                   choices = c("0-14", "15-59", "60+"),
                                   selected = c("0-14", "15-59", "60+"),
                                   multiple = TRUE)
                )
              )
          )
        ),
        
        # 🔹 Exibição dos gráficos lado a lado
        fluidRow(
          box(
            width = 6, 
            title = "Gráfico 1",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput(outputId = 'grafico_pop1', height = "500px")
          ),
          box(
            width = 6, 
            title = "Gráfico 2",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput(outputId = 'grafico_pop2', height = "500px")
          )
        )
      ),
      
      # 5- Razão de dependência
      tabItem(
        tabName = 'opcao2',
        
        h1("Razão de dependência da população projetada de Minas Gerais", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 24px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        h2("Resultados por município, região intermediária e porte populacional", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 20px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        
        # 🔹 Primeira linha de filtros para o gráfico 1
        fluidRow(
          style = "margin-top: 25px;",
          box(
            width = 12,
            title = "Opções de filtro para Gráfico 1",
            solidHeader = TRUE,
            status = "primary",
            collapsible = TRUE,
            collapsed = FALSE,
            
            # 🔹 Filtros para seleção de escala, unidade e tipo de razão de dependência (gráfico 1)
            column(
              width = 4,
              selectInput("escala11", "Selecione a Escala (Gráfico 1):",
                          choices = c(
                            "Município" = "mn",
                            "Região Intermediária" = "rg",
                            "Porte Populacional" = "porte"
                          )
              )
            ),
            column(
              width = 4,
              uiOutput("filtroEscala11") # Filtro dinâmico atualizado para o gráfico 1
            ),
            column(
              width = 4,
              selectInput("tipo_razao11", "Tipo de Razão de Dependência (Gráfico 1):",
                          choices = c("Total", "Jovem", "Idosa"),
                          selected = "Total",
                          multiple = TRUE)
            )
          )
        ),
        
        # 🔹 Segunda linha de filtros para o gráfico 2
        fluidRow(
          box(
            width = 12,
            title = "Opções de filtro para Gráfico 2",
            solidHeader = TRUE,
            status = "primary",
            collapsible = TRUE,
            collapsed = FALSE,
            
            # 🔹 Filtros para seleção de escala, unidade e tipo de razão de dependência (gráfico 2)
            column(
              width = 4,
              selectInput("escala22", "Selecione a Escala (Gráfico 2):",
                          choices = c(
                            "Município" = "mn",
                            "Região Intermediária" = "rg",
                            "Porte Populacional" = "porte"
                          )
              )
            ),
            column(
              width = 4,
              uiOutput("filtroEscala22") # Filtro dinâmico atualizado para o gráfico 2
            ),
            column(
              width = 4,
              selectInput("tipo_razao22", "Tipo de Razão de Dependência (Gráfico 2):",
                          choices = c("Total", "Jovem", "Idosa"),
                          selected = "Total",
                          multiple = TRUE)
            )
          )
        ),
        
        # 🔹 Exibição dos gráficos de razão de dependência lado a lado
        fluidRow(
          box(
            width = 6,
            title = "Gráfico 1",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput("graficoRazao1", height = "500px")
          ),
          box(
            width = 6,
            title = "Gráfico 2",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput("graficoRazao2", height = "500px")
          )
        )
      ),
      
      
      # 6 - Outros indicadores
      tabItem(
        tabName = 'opcao3', 
        
        h1("Índice de envelhecimento e percentual de indivíduos com menos de 5 anos e com 65 anos ou mais da população projetada de Minas Gerais", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 24px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        h2("Resultados por município, região intermediária e porte populacional", 
           style = "
           margin-top: 10px;
           font-family: 'Arial'; 
           font-size: 20px; 
           font-weight: bold; 
           color: #333;
           text-align: center;
           "),
        
        # 🔹 Primeira linha de filtros para o gráfico 1 (Índice de Envelhecimento)
        fluidRow(
          style = "margin-top: 25px;",
          box(
            width = 12,
            title = "Opções de filtro para o índice de envelhecimento",
            solidHeader = TRUE,
            status = "primary",
            collapsible = TRUE,
            collapsed = FALSE,
            
            # 🔹 Filtros para seleção de escala, unidade e indicador
            column(
              width = 4,
              selectInput("escala_indicador3", "Selecione a Escala:",
                          choices = c(
                            "Município" = "mn",
                            "Região Intermediária" = "rg",
                            "Porte Populacional" = "porte"
                          )
              )
            ),
            column(
              width = 4,
              uiOutput("filtroEscalaIndicador3") # Filtro dinâmico
            ),
            column(
              width = 4,
              selectInput("indicador_idade3", "Indicador:",
                          choices = c(
                            "Índice de Envelhecimento (60+/0 a 14)",
                            "Índice de Envelhecimento (65+/0 a 14)",
                            "Índice de Envelhecimento (80+/0 a 14)"
                          ),
                          selected = "Índice de Envelhecimento (65+/0 a 14)",
                          multiple = TRUE)  # Permite seleção múltipla
            )
          )
        ),
        
        # 🔹 Segunda linha de filtros para o gráfico 2 (Percentuais Populacionais)
        fluidRow(
          box(
            width = 12,
            title = "Opções de filtro para percentuais populacionais",
            solidHeader = TRUE,
            status = "primary",
            collapsible = TRUE,
            collapsed = FALSE,
            
            # 🔹 Filtros para seleção de escala, unidade e tipo de percentual
            column(
              width = 4,
              selectInput("escala_percentual3", "Selecione a Escala:",
                          choices = c(
                            "Município" = "mn",
                            "Região Intermediária" = "rg",
                            "Porte Populacional" = "porte"
                          )
              )
            ),
            column(
              width = 4,
              uiOutput("filtroEscalaPercentual3")  # Filtro dinâmico (não alterar)
            ),
            column(
              width = 4,
              selectInput("tipo_percentual3", "Tipo de Percentual:",
                          choices = c("População com menos de 5 anos",
                                      "População com 60 anos ou mais",
                                      "População com 65 anos ou mais"),
                          selected = "População com menos de 5 anos",
                          multiple = TRUE)
            )
          )
        ),
        
        # 🔹 Exibição dos gráficos de indicadores lado a lado
        fluidRow(
          box(
            width = 6,
            title = "Índice de envelhecimento",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput("grafico_indicador3", height = "500px")
          ),
          box(
            width = 6,
            title = "Percentuais populacionais",
            solidHeader = TRUE,
            status = "info",
            collapsible = TRUE,
            highchartOutput("grafico_percentual3", height = "500px")
          )
        )
      ),
        tabItem(tabName = 'opcao4')
                         ),
  ))

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # 🔹 1 - VISÃO GERAL DO CRESCIMENTO - Renderizar o filtro de unidades baseado no nível de análise
  # 🔹 Filtro dinâmico para a escala selecionada (Gráfico 1)
  output$filtroUnidade1 <- renderUI({
    req(input$nivel_analise1)
    
    if (input$nivel_analise1 == "MG") {
      choices <- "Minas Gerais"
      selectInput("municipios1", "Escolha a unidade:", choices = choices, selected = "Minas Gerais")
    } else if (input$nivel_analise1 == "nome_mn") {
      choices <- unique(base_pop_idade_mn_vg$nome_mn)
      selectInput("municipios1", "Escolha o município:", choices = choices)
    } else if (input$nivel_analise1 == "nome_rg") {
      choices <- unique(base_pop_idade_rg_vg$nome_rg)
      selectInput("municipios1", "Escolha a região intermediária:", choices = choices)
    } else {
      choices <- unique(base_pop_idade_porte_vg$portepop)
      selectInput("municipios1", "Escolha o porte populacional:", choices = choices)
    }
  })
  
  # 🔹 Filtro dinâmico para a escala selecionada (Gráfico 2)
  output$filtroUnidade2 <- renderUI({
    req(input$nivel_analise2)
    
    if (input$nivel_analise2 == "MG") {
      choices <- "Minas Gerais"
      selectInput("municipios2", "Escolha a unidade:", choices = choices, selected = "Minas Gerais")
    } else if (input$nivel_analise2 == "nome_mn") {
      choices <- unique(base_pop_idade_mn_vg$nome_mn)
      selectInput("municipios2", "Escolha o município:", choices = choices)
    } else if (input$nivel_analise2 == "nome_rg") {
      choices <- unique(base_pop_idade_rg_vg$nome_rg)
      selectInput("municipios2", "Escolha a região intermediária:", choices = choices)
    } else {
      choices <- unique(base_pop_idade_porte_vg$portepop)
      selectInput("municipios2", "Escolha o porte populacional:", choices = choices)
    }
  })
  
  # 🔹 Função para gerar os gráficos
  gerarGraficoPopulacao <- function(nivel_analise, municipios, sexo) {
    req(municipios, sexo, nivel_analise)
    
    dados_final <- list()
    
    for (unidade in municipios) {
      
      if (nivel_analise == "MG") {
        dados_base <- pop_minas_gerais
        dados_sexo <- pop_minas_gerais_sexo
        filtro_col <- "categoria"  # Coluna fictícia para Minas Gerais
      } else if (nivel_analise == "nome_mn") {
        dados_base <- base_pop_idade_mn_vg
        dados_sexo <- base_pop_idade_mn_sexo_vg
        filtro_col <- "nome_mn"
      } else if (nivel_analise == "nome_rg") {
        dados_base <- base_pop_idade_rg_vg
        dados_sexo <- base_pop_idade_rg_sexo_vg
        filtro_col <- "nome_rg"
      } else {
        dados_base <- base_pop_idade_porte_vg
        dados_sexo <- base_pop_idade_porte_sexo_vg
        filtro_col <- "portepop"
      }
      
      if ("Total" %in% sexo) {
        dados_total <- dados_base %>%
          filter(if (nivel_analise == "MG") TRUE else !!sym(filtro_col) == unidade) %>%
          select(ano, pop_total)
        
        dados_final <- append(dados_final, list(
          list(name = paste(unidade, "(Total)"), data = list_parse2(dados_total))
        ))
      }
      
      if ("Homens" %in% sexo) {
        dados_homens <- dados_sexo %>%
          filter(if (nivel_analise == "MG") TRUE else !!sym(filtro_col) == unidade, sexo == "H") %>%
          select(ano, pop_total)
        
        dados_final <- append(dados_final, list(
          list(name = paste(unidade, "(Homens)"), data = list_parse2(dados_homens))
        ))
      }
      
      if ("Mulheres" %in% sexo) {
        dados_mulheres <- dados_sexo %>%
          filter(if (nivel_analise == "MG") TRUE else !!sym(filtro_col) == unidade, sexo == "M") %>%
          select(ano, pop_total)
        
        dados_final <- append(dados_final, list(
          list(name = paste(unidade, "(Mulheres)"), data = list_parse2(dados_mulheres))
        ))
      }
    }
    
    h <- highchart() %>%
      hc_chart(type = "line") %>%
      hc_xAxis(title = list(text = "Ano"), categories = c(2022, 2025, 2026, 2027, 2032, 2037, 2042, 2047)) %>%
      hc_yAxis(
        title = list(text = "População Total"),
        labels = list(
          formatter = JS("function() {
          if (this.value >= 1000000) {
            return (this.value / 1000000) + 'M';
          } else if (this.value >= 1000) {
            return (this.value / 1000) + 'mil';
          } else {
            return this.value;
          }
        }")
        )
      ) %>%
      hc_tooltip(shared = TRUE) %>%
      hc_exporting(enabled = TRUE, fallbackToExportServer = FALSE)
    
    for (serie in dados_final) {
      h <- h %>% hc_add_series(name = serie$name, data = serie$data)
    }
    
    return(h)
  }
  
  output$grafico1 <- renderHighchart({
    gerarGraficoPopulacao(input$nivel_analise1, input$municipios1, input$sexo1)
  })
  
  output$grafico2 <- renderHighchart({
    gerarGraficoPopulacao(input$nivel_analise2, input$municipios2, input$sexo2)
  })
  
  
  # 🔹 2 - PIRÂMIDES - Filtro dinâmico para a escala selecionada (Pirâmide 1)
  output$filtroEscala1 <- renderUI({
    req(input$escala1)
    
    if (input$escala1 == "MG") {
      selectInput("filtro1", "Escolha Minas Gerais (Pirâmide 1):", choices = "Minas Gerais", selected = "Minas Gerais")
    } else {
      escolhas <- unique(pop_interp_mm_idade_shiny[[input$escala1]])
      selectInput("filtro1", "Escolha o município, região ou porte (Pirâmide 1):", choices = escolhas)
    }
  })
  
  # 🔹 Filtro dinâmico para a escala selecionada (Pirâmide 2)
  output$filtroEscala2 <- renderUI({
    req(input$escala2)
    
    if (input$escala2 == "MG") {
      selectInput("filtro2", "Escolha Minas Gerais (Pirâmide 2):", choices = "Minas Gerais", selected = "Minas Gerais")
    } else {
      escolhas <- unique(pop_interp_mm_idade_shiny[[input$escala2]])
      selectInput("filtro2", "Escolha o município, região ou porte (Pirâmide 2):", choices = escolhas)
    }
  })
  
  # 🔹 Gerar a pirâmide etária 1 com Highcharter
  output$piramideEtaria1 <- renderHighchart({
    req(input$escala1, input$filtro1, input$ano1)
    
    if (input$escala1 == "MG") {
      dados_filtrados <- pop_interp_mm_idade_shiny %>%
        filter(ano == input$ano1)
    } else {
      dados_filtrados <- pop_interp_mm_idade_shiny %>%
        filter(!!sym(input$escala1) == input$filtro1, ano == input$ano1)
    }
    
    gerarGraficoPiramide(dados_filtrados, input$filtro1, input$ano1)
  })
  
  # 🔹 Gerar a pirâmide etária 2 com Highcharter
  output$piramideEtaria2 <- renderHighchart({
    req(input$escala2, input$filtro2, input$ano2)
    
    if (input$escala2 == "MG") {
      dados_filtrados <- pop_interp_mm_idade_shiny %>%
        filter(ano == input$ano2)
    } else {
      dados_filtrados <- pop_interp_mm_idade_shiny %>%
        filter(!!sym(input$escala2) == input$filtro2, ano == input$ano2)
    }
    
    gerarGraficoPiramide(dados_filtrados, input$filtro2, input$ano2)
  })
  
  # 🔹 Função auxiliar para gerar gráfico de pirâmide etária
  gerarGraficoPiramide <- function(dados, filtro, ano) {
    breaks <- seq(0, 80, by = 5)
    labels <- as.character(breaks)
    labels[length(labels)] <- paste0(breaks[length(labels)], "+")
    
    dados_plot <- dados %>%
      mutate(
        pop_menor = ifelse(sexo == "H", -pop_menor, pop_menor), # Valores negativos para homens
        faixa_etaria = cut(idade, breaks = c(breaks, Inf), right = FALSE, labels = labels)
      ) %>%
      group_by(faixa_etaria, sexo) %>%
      summarise(populacao = sum(pop_menor), .groups = 'drop') %>%
      pivot_wider(names_from = sexo, values_from = populacao, values_fill = 0) %>%
      arrange(desc(faixa_etaria))
    
    highchart() %>%
      hc_chart(type = "bar") %>%
      hc_xAxis(categories = dados_plot$faixa_etaria,
               title = list(text = "Faixa Etária"),
               reversed = TRUE) %>%
      hc_yAxis(
        title = list(text = "População total"),
        labels = list(formatter = JS("function() { return Math.abs(this.value); }")),
        reversed = FALSE
      ) %>%
      hc_plotOptions(series = list(stacking = "normal")) %>%
      hc_add_series(name = "Homens", data = dados_plot$H, color = "#4e79a7") %>%
      hc_add_series(name = "Mulheres", data = dados_plot$M, color = "#f28e2b") %>%
      hc_title(text = paste("Pirâmide Etária -", filtro, "- Ano:", ano)) %>%
      hc_tooltip(shared = TRUE) %>%
      hc_exporting(enabled = TRUE, fallbackToExportServer = FALSE)
  }
  
  # 3 - RS e TX
  # 🔹 Filtro dinâmico para a escala selecionada (Gráfico 1 - Indicadores)
  output$filtroEscalaIndicador110 <- renderUI({
    req(input$escala_indicador110)
    
    if (input$escala_indicador110 == "nome_mn") {
      choices <- unique(rs_mn$nome_mn)
    } else if (input$escala_indicador110 == "nome_rg") {
      choices <- unique(rs_rg$nome_rg)
    } else {
      choices <- unique(rs_porte$id)
    }
    
    selectInput("unidade_indicador110", "Escolha a unidade:", choices = choices)
  })
  
  # 🔹 Filtro dinâmico para a escala selecionada (Gráfico 2 - Taxas de Crescimento)
  output$filtroEscalaTaxa110 <- renderUI({
    req(input$escala_taxa110)
    
    if (input$escala_taxa110 == "nome_mn") {
      choices <- unique(base_tx_mn_total$nome_mn)
    } else if (input$escala_taxa110 == "nome_rg") {
      choices <- unique(base_tx_rg_total$nome_rg)
    } else {
      choices <- unique(base_tx_porte_total$portepop)
    }
    
    selectInput("unidade_taxa110", "Escolha a unidade:", choices = choices)
  })
  
  # 🔹 Gráfico 1 - Indicadores
  output$grafico_indicador110 <- renderHighchart({
    req(input$escala_indicador110, input$unidade_indicador110, input$ano_indicador110)
    
    dados <- switch(input$escala_indicador110,
                    "nome_mn" = rs_mn,
                    "nome_rg" = rs_rg,
                    "id" = rs_porte)
    
    dados_filtrados <- dados %>%
      filter(if (input$escala_indicador110 == "nome_mn") nome_mn == input$unidade_indicador110
             else if (input$escala_indicador110 == "nome_rg") nome_rg == input$unidade_indicador110
             else id == input$unidade_indicador110,
             ano == input$ano_indicador110)
    
    highchart() %>%
      hc_chart(type = "line") %>%
      hc_xAxis(categories = unique(dados_filtrados$fe)) %>%
      hc_yAxis(title = list(text = "Indicador")) %>%
      hc_add_series(name = "Razão de sexo", data = dados_filtrados$indicador) %>%
      hc_tooltip(pointFormat = "{point.y:.2f}") %>%
      hc_exporting(enabled = TRUE)
  })
  
  # 🔹 Gráfico 2 - Taxas de Crescimento
  output$grafico_taxa110 <- renderHighchart({
    req(input$escala_taxa110, input$unidade_taxa110)
    
    dados <- switch(input$escala_taxa110,
                    "nome_mn" = base_tx_mn_total,
                    "nome_rg" = base_tx_rg_total,
                    "portepop" = base_tx_porte_total)
    
    dados_filtrados <- dados %>%
      filter(if (input$escala_taxa110 == "nome_mn") nome_mn == input$unidade_taxa110
             else if (input$escala_taxa110 == "nome_rg") nome_rg == input$unidade_taxa110
             else portepop == input$unidade_taxa110)
    
    highchart() %>%
      hc_chart(type = "column") %>%
      hc_xAxis(categories = unique(dados_filtrados$tx_cresc)) %>%
      hc_yAxis(title = list(text = "Taxa de Crescimento")) %>%
      hc_add_series(name = "Taxa de Crescimento", data = dados_filtrados$valor) %>%
      hc_tooltip(pointFormat = "{point.y:.4f}") %>%
      hc_exporting(enabled = TRUE)
  })
  
  # 🔹 4 - CRESC POR IDADE - Filtro dinâmico para a unidade (Gráfico 1)
  
  # 🔹 Atualiza dinamicamente as opções do segundo filtro com base no nível de análise
  output$filtroUnidade_pop1 <- renderUI({
    req(input$nivel_analise_pop1)
    choices <- switch(input$nivel_analise_pop1,
                      "nome_mn" = unique(base_pop_idade_mn_total$nome_mn),
                      "nome_rg" = unique(base_pop_idade_rg_total$nome_rg),
                      "portepop" = unique(base_pop_idade_porte_total$portepop))
    selectInput("unidade_pop1", "Escolha a unidade:", choices = choices)
  })
  
  output$filtroUnidade_pop2 <- renderUI({
    req(input$nivel_analise_pop2)
    choices <- switch(input$nivel_analise_pop2,
                      "nome_mn" = unique(base_pop_idade_mn_total$nome_mn),
                      "nome_rg" = unique(base_pop_idade_rg_total$nome_rg),
                      "portepop" = unique(base_pop_idade_porte_total$portepop))
    selectInput("unidade_pop2", "Escolha a unidade:", choices = choices)
  })
  
  # 🔹 Atualização dos gráficos com os novos anos e filtros de faixa etária
  criar_grafico <- function(nivel_analise, unidade, faixa_etaria, output_id) {
    req(nivel_analise, unidade, faixa_etaria)
    
    dados_base <- switch(nivel_analise,
                         "nome_mn" = base_pop_idade_mn_total,
                         "nome_rg" = base_pop_idade_rg_total,
                         "portepop" = base_pop_idade_porte_total)
    
    filtro_col <- nivel_analise
    
    dados_final <- dados_base %>%
      filter(!!sym(filtro_col) %in% unidade, faixa_etaria %in% faixa_etaria, ano %in% c(2022, 2025, 2026, 2027, 2032, 2037, 2042, 2047)) %>%
      group_by(ano, faixa_etaria) %>%
      summarise(pop_total = sum(pop_total, na.rm = TRUE), .groups = "drop")
    
    if (nrow(dados_final) == 0) {
      output[[output_id]] <- renderHighchart({ NULL })
      return(NULL)
    }
    
    h <- highchart() %>%
      hc_size(width = 850, height = 500) %>%
      hc_xAxis(title = list(text = "Ano"), categories = c(2022, 2025, 2026, 2027, 2032, 2037, 2042, 2047)) %>%
      hc_chart(type = "line") %>%
      hc_yAxis(
        title = list(text = "População Total"),
        labels = list(
          formatter = JS("function() {
          if (this.value >= 1000000) {
            return (this.value / 1000000) + 'M';
          } else if (this.value >= 1000) {
            return (this.value / 1000) + 'mil';
          } else {
            return this.value;
          }
        }")
        )
      ) %>%
      hc_title(text = paste0("Evolução Populacional - ", unidade)) %>%
      hc_tooltip(pointFormat = "{point.y:,.0f}") %>%
      hc_legend(enabled = TRUE) %>%
      hc_exporting(enabled = TRUE, buttons = list(contextButton = list(menuItems = c('downloadPNG', 'downloadJPEG', 'downloadSVG'))))
    
    for (faixa in faixa_etaria) {
      dados_faixa <- dados_final %>% filter(faixa_etaria == faixa)
      h <- h %>%
        hc_add_series(data = list_parse2(dados_faixa %>% select(ano, pop_total)),
                      name = faixa,
                      type = "line")
    }
    
    output[[output_id]] <- renderHighchart({ h })
  }
  
  observeEvent({input$unidade_pop1; input$faixa_etaria_pop1}, {
    criar_grafico(input$nivel_analise_pop1, input$unidade_pop1, input$faixa_etaria_pop1, "grafico_pop1")
  })
  
  observeEvent({input$unidade_pop2; input$faixa_etaria_pop2}, {
    criar_grafico(input$nivel_analise_pop2, input$unidade_pop2, input$faixa_etaria_pop2, "grafico_pop2")
  })
  
  
  # 🔹 5 - RAZÃO DE DEPENDÊNCIA 
  # Função para obter a base de dados correta
  get_razao_base <- function(tipos_razao, escala) {
    bases <- list(
      Total = list(
        mn = razao_dep_total_mn,
        rg = razao_dep_total_rg,
        porte = razao_dep_total_porte
      ),
      Jovem = list(
        mn = razao_dep_jovem_mn,
        rg = razao_dep_jovem_rg,
        porte = razao_dep_jovem_porte
      ),
      Idosa = list(
        mn = razao_dep_idosa_mn,
        rg = razao_dep_idosa_rg,
        porte = razao_dep_idosa_porte
      )
    )
    
    bases_selecionadas <- lapply(tipos_razao, function(tipo) bases[[tipo]][[escala]])
    base_final <- do.call(rbind, bases_selecionadas)
    
    return(base_final)
  }
  
  # 🔹 Filtro dinâmico para Razão de Dependência (Gráfico 1)
  output$filtroEscala11 <- renderUI({
    req(input$escala11, input$tipo_razao11)
    
    base <- get_razao_base(input$tipo_razao11, input$escala11)
    
    coluna_filtro <- switch(input$escala11,
                            "mn" = "nome_mn",
                            "rg" = "nome_rg",
                            "porte" = "id")
    
    selectInput("filtroRDP1", "Escolha a unidade (Gráfico 1):",
                choices = unique(base[[coluna_filtro]]))
  })
  
  # 🔹 Filtro dinâmico para Razão de Dependência (Gráfico 2)
  output$filtroEscala22 <- renderUI({
    req(input$escala22, input$tipo_razao22)
    
    base <- get_razao_base(input$tipo_razao22, input$escala22)
    
    coluna_filtro <- switch(input$escala22,
                            "mn" = "nome_mn",
                            "rg" = "nome_rg",
                            "porte" = "id")
    
    selectInput("filtroRDP2", "Escolha a unidade (Gráfico 2):",
                choices = unique(base[[coluna_filtro]]))
  })
  
  # 🔹 Gerar gráfico para Razão de Dependência 1
  output$graficoRazao1 <- renderHighchart({
    req(input$escala11, input$filtroRDP1, input$tipo_razao11)
    
    anos_referencia <- unique(razao_dep_total_mn$ano)
    
    h <- highchart() %>%
      hc_chart(type = "line") %>%
      hc_xAxis(categories = anos_referencia, title = list(text = "Ano")) %>%
      hc_yAxis(title = list(text = "Razão de Dependência")) %>%
      hc_tooltip(shared = TRUE) %>%
      hc_exporting(enabled = TRUE)
    
    for (tipo in input$tipo_razao11) {
      base <- get_razao_base(tipo, input$escala11)
      
      coluna_filtro <- switch(input$escala11,
                              "mn" = "nome_mn",
                              "rg" = "nome_rg",
                              "porte" = "id")
      
      dados_filtrados <- base %>%
        filter(!!sym(coluna_filtro) == input$filtroRDP1) %>%
        arrange(ano)
      
      cor <- if (tipo == "Total") "#0080FF" else if (tipo == "Jovem") "#FF8000" else "#8000FF"
      
      h <- h %>%
        hc_add_series(name = paste("Razão de Dependência -", tipo),
                      data = dados_filtrados$indicador,
                      color = cor)
    }
    
    h
  })
  
  # 🔹 Gerar gráfico para Razão de Dependência 2
  output$graficoRazao2 <- renderHighchart({
    req(input$escala22, input$filtroRDP2, input$tipo_razao22)
    
    anos_referencia <- unique(razao_dep_total_mn$ano)
    
    h <- highchart() %>%
      hc_chart(type = "line") %>%
      hc_xAxis(categories = anos_referencia, title = list(text = "Ano")) %>%
      hc_yAxis(title = list(text = "Razão de Dependência")) %>%
      hc_tooltip(shared = TRUE) %>%
      hc_exporting(enabled = TRUE)
    
    for (tipo in input$tipo_razao22) {
      base <- get_razao_base(tipo, input$escala22)
      
      coluna_filtro <- switch(input$escala22,
                              "mn" = "nome_mn",
                              "rg" = "nome_rg",
                              "porte" = "id")
      
      dados_filtrados <- base %>%
        filter(!!sym(coluna_filtro) == input$filtroRDP2) %>%
        arrange(ano)
      
      cor <- if (tipo == "Total") "#0080FF" else if (tipo == "Jovem") "#FF8000" else "#8000FF"
      
      h <- h %>%
        hc_add_series(name = paste("Razão de Dependência -", tipo),
                      data = dados_filtrados$indicador,
                      color = cor)
    }
    
    h
  })
  # 6🔹- IE E PERCENTUAIS
  # 🔹 Filtro dinâmico para o Índice de Envelhecimento
  output$filtroEscalaIndicador3 <- renderUI({
    req(input$escala_indicador3)
    
    base <- switch(input$escala_indicador3,
                   "mn" = indice_de_envelhecimento_mn_60,
                   "rg" = indice_de_envelhecimento_rg_60,
                   "porte" = indice_de_envelhecimento_porte_60)
    
    coluna_filtro <- switch(input$escala_indicador3,
                            "mn" = "nome_mn",
                            "rg" = "nome_rg",
                            "porte" = "portepop")  # Atualizado para "portepop"
    
    selectInput("unidade_indicador3", "Escolha a unidade:",
                choices = unique(base[[coluna_filtro]]))
  })
  
  # 🔹 Definição correta do eixo X com todas as categorias de anos
  anos <- unique(indice_de_envelhecimento_mn_60$ano)  # Todos os anos disponíveis
  anos_plotar <- c(2022, 2025, 2026, 2027, 2032, 2037, 2042, 2047)  # Anos específicos para plotar
  
  # 🔹 Filtro dinâmico para os percentuais populacionais
  output$filtroEscalaPercentual3 <- renderUI({
    req(input$escala_percentual3)
    
    base <- switch(input$escala_percentual3,
                   "mn" = percentual_menor_de_5_anos_mn,
                   "rg" = percentual_menor_de_5_anos_rg,
                   "porte" = percentual_menor_de_5_anos_porte)
    
    coluna_filtro <- switch(input$escala_percentual3,
                            "mn" = "nome_mn",
                            "rg" = "nome_rg",
                            "porte" = "id")
    
    selectInput("unidade_percentual3", "Escolha a unidade:",
                choices = unique(base[[coluna_filtro]]))
  })
  
  # 🔹 Definição correta do eixo X com todas as categorias de anos
  anos <- unique(percentual_menor_de_5_anos_mn$ano)  # Todos os anos disponíveis
  # anos_plotar <- c(2022, 2025, 2026, 2027, 2032, 2037, 2042, 2047)  # Anos específicos para plotar
  
  # 🔹 Gerar gráfico para Índice de Envelhecimento
  output$grafico_indicador3 <- renderHighchart({
    req(input$escala_indicador3, input$unidade_indicador3, input$indicador_idade3)
    
    # Define as bases de dados com base no indicador selecionado
    bases_indicadores <- list(
      "Índice de Envelhecimento (60+/0 a 14)" = list(
        "mn" = indice_de_envelhecimento_mn_60,
        "rg" = indice_de_envelhecimento_rg_60,
        "porte" = indice_de_envelhecimento_porte_60
      ),
      "Índice de Envelhecimento (65+/0 a 14)" = list(
        "mn" = indice_de_envelhecimento_mn_65,
        "rg" = indice_de_envelhecimento_rg_65,
        "porte" = indice_de_envelhecimento_porte_65
      ),
      "Índice de Envelhecimento (80+/0 a 14)" = list(
        "mn" = indice_de_envelhecimento_mn_80,
        "rg" = indice_de_envelhecimento_rg_80,
        "porte" = indice_de_envelhecimento_porte_80
      )
    )
    
    # Cria o gráfico
    h <- highchart() %>%
      hc_chart(type = "line") %>%
      hc_xAxis(
        title = list(text = "Ano"),
        categories = as.character(anos),  # Todos os anos como categorias
        labels = list(
          step = 1,  # Exibir todos os anos, sem agrupamento
          rotation = -45  # Rotacionar os rótulos para melhor legibilidade
        )
      ) %>%
      hc_yAxis(title = list(text = "Índice de Envelhecimento")) %>%
      hc_tooltip(shared = TRUE) %>%
      hc_exporting(enabled = TRUE)
    
    # Adiciona séries para cada indicador selecionado
    for (indicador in input$indicador_idade3) {
      base <- bases_indicadores[[indicador]][[input$escala_indicador3]]
      
      coluna_filtro <- switch(input$escala_indicador3,
                              "mn" = "nome_mn",
                              "rg" = "nome_rg",
                              "porte" = "portepop")  # Atualizado para "portepop"
      
      dados_filtrados <- base %>%
        filter(!!sym(coluna_filtro) == input$unidade_indicador3, ano %in% anos) %>%
        arrange(ano)
      
      h <- h %>%
        hc_add_series(name = paste(input$unidade_indicador3, "-", indicador), 
                      data = dados_filtrados$indicador)
    }
    
    h
  })
  
  # 🔹 Gerar gráfico para Percentuais Populacionais
  output$grafico_percentual3 <- renderHighchart({
    req(input$escala_percentual3, input$unidade_percentual3, input$tipo_percentual3)
    
    bases <- list(
      "População com menos de 5 anos" = list(
        "mn" = percentual_menor_de_5_anos_mn,
        "rg" = percentual_menor_de_5_anos_rg,
        "porte" = percentual_menor_de_5_anos_porte
      ),
      "População com 65 anos ou mais" = list(
        "mn" = percentual_maior_de_65_anos_mn,
        "rg" = percentual_maior_de_65_anos_rg,
        "porte" = percentual_maior_de_65_anos_porte
      ),
      "População com 60 anos ou mais" = list(
        "mn" = percentual_maior_de_60_anos_mn,
        "rg" = percentual_maior_de_60_anos_rg,
        "porte" = percentual_maior_de_60_anos_porte
      )
    )
    
    h <- highchart() %>%
      hc_chart(type = "line") %>%
      hc_xAxis(title = list(text = "Ano"), categories = anos) %>%
      hc_yAxis(title = list(text = "Percentual da População")) %>%
      hc_tooltip(pointFormat = "{point.y:,.0f}") %>%
      hc_exporting(enabled = TRUE)
    
    for (tipo in input$tipo_percentual3) {
      base <- bases[[tipo]][[input$escala_percentual3]]
      
      coluna_filtro <- switch(input$escala_percentual3,
                              "mn" = "nome_mn",
                              "rg" = "nome_rg",
                              "porte" = "id")
      
      dados_filtrados <- base %>%
        filter(!!sym(coluna_filtro) == input$unidade_percentual3, ano %in% anos) %>%
        arrange(ano)
      
      h <- h %>%
        hc_add_series(name = paste(input$unidade_percentual3, "-", tipo), 
                      data = dados_filtrados$indicador)
    }
    
    h
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)

