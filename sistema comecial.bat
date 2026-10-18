@echo off
setlocal enabledelayedexpansion
title FERRIRAPLAS COMERCIAL - GESTAO

set "jaExisteCadastro=falso"
set "logado=falso"
set /a qtdProdutos=0
set /a saldoCaixa=0

for /l %%i in (1,1,5) do (
    set "cadastradoFuncionarios[%%i]=falso"
    set "nomeFuncionarios[%%i]="
    set "idadeFuncionarios[%%i]=0"
    set "salarioFuncionarios[%%i]=0"
)

:MENU_ACESSO
cls
echo ====================================
echo        FERRIRAPLAS COMERCIAL
echo ====================================
echo 1 - Fazer login
echo 2 - Criar conta administrativa
echo 3 - Desligar sistema
echo.
set "opcaoAcesso="
set /p "opcaoAcesso=Escolha uma opcao: "

if "%opcaoAcesso%"=="1" goto :LOGIN
if "%opcaoAcesso%"=="2" goto :CADASTRO_ADM
if "%opcaoAcesso%"=="3" goto :ENCERRAR
echo Opcao invalida!
pause
goto :MENU_ACESSO

:LOGIN
cls
echo ========== LOGIN ==========
if "%jaExisteCadastro%"=="falso" (
    echo Nenhum administrador cadastrado.
    echo Cadastre uma conta primeiro.
    pause
    goto :MENU_ACESSO
)
set "usuarioTentativa="
set "senhaTentativa="
set /p "usuarioTentativa=Usuario: "
set /p "senhaTentativa=Senha: "

if "%usuarioTentativa%"=="%usuarioCadastrado%" (
    if "%senhaTentativa%"=="%senhaCadastrada%" (
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
if "%jaExisteCadastro%"=="verdadeiro" (
    echo Ja existe um administrador cadastrado.
    echo Nao e permitido substituir a conta.
    pause
    goto :MENU_ACESSO
)
set "usuarioCadastrado="
set "senhaCadastrada="
set /p "usuarioCadastrado=Crie um usuario: "
set /p "senhaCadastrada=Crie uma senha: "

if "%usuarioCadastrado%"=="" goto :ADM_INVALIDO
if "%senhaCadastrada%"=="" goto :ADM_INVALIDO

set "jaExisteCadastro=verdadeiro"
echo Administrador cadastrado com sucesso!
echo Agora faca login.
pause
goto :MENU_ACESSO

:ADM_INVALIDO
echo Erro: usuario e senha sao obrigatorios!
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
echo 1 - Cadastrar funcionario
echo 2 - Listar funcionarios
echo 3 - Voltar
echo.
set "opcaoFuncionario="
set /p "opcaoFuncionario=Opcao: "

if "%opcaoFuncionario%"=="1" goto :CADASTRAR_FUNC
if "%opcaoFuncionario%"=="2" goto :LISTAR_FUNC
if "%opcaoFuncionario%"=="3" goto :MENU_PRINCIPAL
echo Opcao invalida!
pause
goto :MENU_FUNCIONARIOS

:CADASTRAR_FUNC
cls
echo === CADASTRAR FUNCIONARIO ===
set "i="
set /p "i=Posicao de 1 a 5: "

if "%i%"=="" goto :FUNC_INVALIDO
if %i% lss 1 goto :FUNC_INVALIDO
if %i% gtr 5 goto :FUNC_INVALIDO

if "!cadastradoFuncionarios[%i%]!"=="verdadeiro" (
    echo Erro: vaga ocupada!
    pause
    goto :MENU_FUNCIONARIOS
)

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
echo Funcionario cadastrado com sucesso!
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
echo 1 - Entrada de produtos
echo 2 - Baixa de produtos
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
    echo Entrada registrada com sucesso!
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
        echo Baixa registrada com sucesso!
        echo Estoque atual: %qtdProdutos%
    )
)
pause
goto :MENU_ESTOQUE

:MENU_CAIXA
cls
echo ===== FLUXO DE CAIXA =====
echo Saldo atual: R$ %saldoCaixa%,00
echo 1 - Registrar entrada
echo 2 - Registrar pagamento
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
    echo Entrada registrada!
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
        echo Pagamento registrado!
        echo Saldo atual: R$ %saldoCaixa%,00
    )
)
pause
goto :MENU_CAIXA

:ENCERRAR
cls
echo Encerrando o Ferriraplas...
echo Ate logo!
timeout /t 3 >nul
exit
