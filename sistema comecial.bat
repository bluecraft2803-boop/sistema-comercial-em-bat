@echo off
setlocal enabledelayedexpansion
title FERRIRAPLAS COMERCIAL - GESTAO

:: Configuração do arquivo de Banco de Dados
set "DB_FILE=banco_dados.dat"

:CARREGAR_DB
:: Inicializa valores padrão caso o banco de dados não exista
set "jaExisteCadastro=falso"
set "usuarioCadastrado="
set "senhaCadastrada="
set /a qtdProdutos=0
set /a saldoCaixa=0

for /l %%i in (1,1,5) do (
    set "cadastradoFuncionarios[%%i]=falso"
    set "nomeFuncionarios[%%i]="
    set "idadeFuncionarios[%%i]=0"
    set "salarioFuncionarios[%%i]=0"
)

:: Carrega os dados salvos tratando corretamente strings
if exist "%DB_FILE%" (
    for /f "usebackq tokens=1,2 delims==" %%a in ("%DB_FILE%") do (
        set "%%a=%%b"
    )
)
set "logado=falso"

:MENU_ACESSO
cls
echo ====================================
echo        FERRIRAPLAS COMERCIAL
echo ====================================
echo 1 - Fazer login
echo 2 - Criar/Alterar conta administrativa
echo 3 - Remover conta administrativa
echo 4 - Desligar sistema
echo.
set "opcaoAcesso="
set /p "opcaoAcesso=Escolha uma opcao: "

if "%opcaoAcesso%"=="1" goto :LOGIN
if "%opcaoAcesso%"=="2" goto :CADASTRO_ADM
if "%opcaoAcesso%"=="3" goto :REMOVER_ADM
if "%opcaoAcesso%"=="4" goto :ENCERRAR
echo Opcao invalida!
pause
goto :MENU_ACESSO

:SALVAR_DB
:: ATENCAO: Os comandos abaixo nao tem espacos antes do '>' para nao salvar espacos invisiveis no arquivo!
(echo jaExisteCadastro=%jaExisteCadastro%)> "%DB_FILE%"
(echo usuarioCadastrado=%usuarioCadastrado%)>> "%DB_FILE%"
(echo senhaCadastrada=%senhaCadastrada%)>> "%DB_FILE%"
(echo qtdProdutos=%qtdProdutos%)>> "%DB_FILE%"
(echo saldoCaixa=%saldoCaixa%)>> "%DB_FILE%"

for /l %%i in (1,1,5) do (
    (echo cadastradoFuncionarios[%%i]=!cadastradoFuncionarios[%%i]!)>> "%DB_FILE%"
    (echo nomeFuncionarios[%%i]=!nomeFuncionarios[%%i]!)>> "%DB_FILE%"
    (echo idadeFuncionarios[%%i]=!idadeFuncionarios[%%i]!)>> "%DB_FILE%"
    (echo salarioFuncionarios[%%i]=!salarioFuncionarios[%%i]!)>> "%DB_FILE%"
)
goto :eof

:LOGIN
cls
echo ========== LOGIN ==========
if "!jaExisteCadastro!"=="falso" (
    echo Nenhum administrador cadastrado.
    echo Cadastre uma conta primeiro.
    pause
    goto :MENU_ACESSO
)
set "usuarioTentativa="
set "senhaTentativa="
set /p "usuarioTentativa=Usuario: "
set /p "senhaTentativa=Senha: "

:: Validacao exata sem espacos espelhos
if "!usuarioTentativa!"=="!usuarioCadastrado!" (
    if "!senhaTentativa!"=="!senhaCadastrada!" (
        set "logado=verdadeiro"
        goto :MENU_PRINCIPAL
    )
)
echo Usuario ou senha incorretos!
pause
goto :MENU_ACESSO

:CADASTRO_ADM
cls
echo ===== CADASTRO ADMINISTRATIVO =====
set "usuarioCadastrado="
set "senhaCadastrada="
set /p "usuarioCadastrado=Crie/Altere o usuario: "
set /p "senhaCadastrada=Crie/Altere a senha: "

if "%usuarioCadastrado%"=="" goto :ADM_INVALIDO
if "%senhaCadastrada%"=="" goto :ADM_INVALIDO

set "jaExisteCadastro=verdadeiro"
call :SALVAR_DB
echo Administrador configurado com sucesso!
echo Dados salvos no banco de dados.
pause
goto :MENU_ACESSO

:ADM_INVALIDO
echo Erro: usuario e senha sao obrigatorios!
pause
goto :MENU_ACESSO

:REMOVER_ADM
cls
echo ===== REMOVER CONTA ADMINISTRATIVA =====
if "!jaExisteCadastro!"=="falso" (
    echo Nao existe nenhuma conta cadastrada para remover.
    pause
    goto :MENU_ACESSO
)
echo Tem certeza que deseja deletar o administrador "!usuarioCadastrado!"?
set "confirmarRemover="
set /p "confirmarRemover=Digite S para Sim ou N para Nao: "

if /i "%confirmarRemover%"=="S" (
    set "jaExisteCadastro=falso"
    set "usuarioCadastrado="
    set "senhaCadastrada="
    call :SALVAR_DB
    echo Conta administrativa removida com sucesso do banco!
) else (
    echo Operacao cancelada.
)
pause
goto :MENU_ACESSO

:MENU_PRINCIPAL
cls
echo ====================================
echo        FERRIRAPLAS - GESTAO
echo ====================================
echo Usuario ativo: %usuarioCadastrado%
echo 1 - Funcionarios
echo 2 - Estoque
echo 3 - Caixa
echo 4 - Fazer logout
echo.
set "opcaoMenuPrincipal="
set /p "opcaoMenuPrincipal=Escolha uma opcao: "

if "%opcaoMenuPrincipal%"=="1" goto :MENU_FUNCIONARIOS
if "%opcaoMenuPrincipal%"=="2" goto :MENU_ESTOQUE
if "%opcaoMenuPrincipal%"=="3" goto :MENU_CAIXA
if "%opcaoMenuPrincipal%"=="4" (
    set "logado=falso"
    echo Logout realizado com sucesso!
    pause
    goto :MENU_ACESSO
)
echo Opcao invalida no menu principal!
pause
goto :MENU_PRINCIPAL

:MENU_FUNCIONARIOS
cls
echo ===== FUNCIONARIOS =====
echo 1 - Cadastrar/Alterar funcionario
echo 2 - Remover funcionario (Demitir)
echo 3 - Listar funcionários
echo 4 - Voltar
echo.
set "opcaoFuncionario="
set /p "opcaoFuncionario=Opcao: "

if "%opcaoFuncionario%"=="1" goto :CADASTRAR_FUNC
if "%opcaoFuncionario%"=="2" goto :REMOVER_FUNC
if "%opcaoFuncionario%"=="3" goto :LISTAR_FUNC
if "%opcaoFuncionario%"=="4" goto :MENU_PRINCIPAL
echo Opcao invalida!
pause
goto :MENU_FUNCIONARIOS

:CADASTRAR_FUNC
cls
echo === CADASTRAR / ALTERAR FUNCIONARIO ===
set "i="
set /p "i=Posicao de 1 a 5: "

if "%i%"=="" goto :FUNC_INVALIDO
if %i% lss 1 goto :FUNC_INVALIDO
if %i% gtr 5 goto :FUNC_INVALIDO

set "nomeTemp="
set "idadeTemp="
set "salarioTemp="
set /p "nomeTemp=Nome: "
set /p "idadeTemp=Idade: "
set /p "salarioTemp=Salario: R$ "

if "%nomeTemp%"=="" goto :DATOS_INVALIDOS
if %idadeTemp% lss 1 goto :DATOS_INVALIDOS
if %salarioTemp% lss 0 goto :DATOS_INVALIDOS

set "nomeFuncionarios[%i%]=%nomeTemp%"
set "idadeFuncionarios[%i%]=%idadeTemp%"
set "salarioFuncionarios[%i%]=%salarioTemp%"
set "cadastradoFuncionarios[%i%]=verdadeiro"

call :SALVAR_DB
echo Funcionario updated com sucesso e salvo no banco!
pause
goto :MENU_FUNCIONARIOS

:REMOVER_FUNC
cls
echo === REMOVER FUNCIONARIO ===
set "i="
set /p "i=Informe a posicao (1 a 5) para remover: "

if "%i%"=="" goto :FUNC_INVALIDO
if %i% lss 1 goto :FUNC_INVALIDO
if %i% gtr 5 goto :FUNC_INVALIDO

if "!cadastradoFuncionarios[%i%]!"=="falso" (
    echo Esta posicao ja esta vazia.
    pause
    goto :MENU_FUNCIONARIOS
)

set "cadastradoFuncionarios[%i%]=falso"
set "nomeFuncionarios[%i%]="
set "idadeFuncionarios[%i%]=0"
set "salarioFuncionarios[%i%]=0"

call :SALVAR_DB
echo Funcionario removido com sucesso do banco!
pause
goto :MENU_FUNCIONARIOS

:FUNC_INVALIDO
echo Erro: posicao invalida!
pause
goto :MENU_FUNCIONARIOS

:DATOS_INVALIDOS
echo Erro: dados invalidos!
pause
goto :MENU_FUNCIONARIOS

:LISTAR_FUNC
cls
echo ===== LISTA DE FUNCIONARIOS =====
for /l %%g in (1,1,5) do (
    if "!cadastradoFuncionarios[%%g]!"=="verdadeiro" (
        echo --------------------------------
        echo Posicao: %%g
        echo Nome: !nomeFuncionarios[%%g]!
        echo Idade: !idadeFuncionarios[%%g]!
        echo Salario: R$ !salarioFuncionarios[%%g]!,00
    ) else (
        echo Posicao %%g: VAZIA
    )
)
echo.
pause
goto :MENU_FUNCIONARIOS

:MENU_ESTOQUE
cls
echo ===== CONTROLE DE ESTOQUE =====
echo Quantidade atual: %qtdProdutos%
echo 1 - Entrada de produtos (Adicionar)
echo 2 - Baixa de produtos (Remover)
echo 3 - Voltar
echo.
set "opcaoEstoque="
set /p "opcaoEstoque=Opcao: "

if "%opcaoEstoque%"=="1" goto :ENTRADA_ESTOQUE
if "%opcaoEstoque%"=="2" goto :BAIXA_ESTOQUE
if "%opcaoEstoque%"=="3" goto :MENU_PRINCIPAL
echo Opcao invalida!
pause
goto :MENU_ESTOQUE

:ENTRADA_ESTOQUE
cls
echo === ENTRADA DE ESTOQUE ===
set "adicionarEstoque=0"
set /p "adicionarEstoque=Quantidade para adicionar: "
if %adicionarEstoque% lss 1 (
    echo Erro: informe uma quantidade positiva!
) else (
    set /a qtdProdutos=qtdProdutos+adicionarEstoque
    call :SALVAR_DB
    echo Entrada registrada com sucesso e alterada no banco!
    echo Estoque atual: %qtdProdutos%
)
pause
goto :MENU_ESTOQUE

:BAIXA_ESTOQUE
cls
echo === BAIXA DE ESTOQUE ===
set "removerEstoque=0"
set /p "removerEstoque=Quantidade para remover: "
if %removerEstoque% lss 1 (
    echo Erro: informe uma quantidade positiva!
) else (
    if %removerEstoque% gtr %qtdProdutos% (
        echo Erro: estoque insuficiente!
    ) else (
        set /a qtdProdutos=qtdProdutos-removerEstoque
        call :SALVAR_DB
        echo Baixa registrada com sucesso e alterada no banco!
        echo Estoque atual: %qtdProdutos%
    )
)
pause
goto :MENU_ESTOQUE

:MENU_CAIXA
cls
echo ===== FLUXO DE CAIXA =====
echo Saldo atual: R$ %saldoCaixa%,00
echo 1 - Registrar entrada (Adicionar)
echo 2 - Registrar pagamento (Remover)
echo 3 - Voltar
echo.
set "opcaoCaixa="
set /p "opcaoCaixa=Opcao: "

if "%opcaoCaixa%"=="1" goto :ENTRADA_CAIXA
if "%opcaoCaixa%"=="2" goto :SAIDA_CAIXA
if "%opcaoCaixa%"=="3" goto :MENU_PRINCIPAL
echo Opcao invalida!
pause
goto :MENU_CAIXA

:ENTRADA_CAIXA
cls
echo === ENTRADA DE CAIXA ===
set "valorMovimentado=0"
set /p "valorMovimentado=Valor da entrada: R$ "
if %valorMovimentado% lss 1 (
    echo Erro: o valor deve ser positivo!
) else (
    set /a saldoCaixa=saldoCaixa+valorMovimentado
    call :SALVAR_DB
    echo Entrada registrada e alterada no banco!
    echo Saldo atual: R$ %saldoCaixa%,00
)
pause
goto :MENU_CAIXA

:SAIDA_CAIXA
cls
echo === SAIDA DE CAIXA ===
set "valorMovimentado=0"
set /p "valorMovimentado=Valor do pagamento: R$ "
if %valorMovimentado% lss 1 (
    echo Erro: o valor deve ser positivo!
) else (
    if %valorMovimentado% gtr %saldoCaixa% (
        echo Erro: saldo insuficiente!
    ) else (
        set /a saldoCaixa=saldoCaixa-valorMovimentado
        call :SALVAR_DB
        echo Pagamento registrado e alterado no banco!
        echo Saldo atual: R$ %saldoCaixa%,00
    )
)
pause
goto :MENU_CAIXA

:ENCERRAR
cls
echo Encerrando o Ferriraplas...
echo Garantindo que todos os dados estao salvos...
call :SALVAR_DB
echo Ate logo!
timeout /t 3 >nul
exit

