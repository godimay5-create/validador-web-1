# Validador Tributário — versão web (Vercel)

Site do Validador Tributário. Os **cálculos são o mesmo Python do programa desktop** (`vt/servico.py`, `motor_sn.py`, `lp.py`, `importacao.py`…),
rodando dentro do navegador pelo [Pyodide](https://pyodide.org). As telas são HTML/JavaScript. Os dados ficam no **mesmo Supabase**
(carteira `companies` + nuvem `simples_dados`), no mesmo formato. Por isso o site e o .exe podem ser usados ao mesmo tempo.

Não há servidor próprio: o Vercel só entrega os arquivos desta pasta. Ninguém tem acesso aos dados sem login, porque as tabelas exigem
usuário autenticado (rode o `seguranca_supabase.sql` do projeto desktop, se ainda não rodou).

## O que já funciona no site
- Login com o usuário da nuvem (Supabase → Authentication → Users).
- **Tabela de empresas** em cima, com Situação, Receita, Tributos calculados, Declarado, Diferença, Fator R, RBT12, Faixa e Pendência.
  Tem filtros, busca, ordenação, totais, F8 (próxima pendente) e a divisória arrastável.
- **Empresa embaixo**:
  - **Resumo:** indicadores, pendências, histórico e trilha.
  - **Apuração em 5 etapas:**
    1. Arquivos: importa XML de NF-e, NFC-e e NFS-e, PDF do PGDAS-D e ZIP.
    2. Receitas do mês.
    3. RBT12 e folha mês a mês.
    4. Memória de cálculo.
    5. Validação: justificar, revisar, concluir, reabrir e imprimir relatório.
- Troca de competência e de regime, salvar apuração, relatório da carteira para imprimir/PDF.
- Barra fina com ‹ › nas abas de trabalho (Ctrl+T abre/recolhe a tabela), modo ampliado (F11) e tamanho do texto no menu ☰.
- Envio automático para a nuvem a cada alteração (indicador "Salvo na nuvem" no topo).

## Ainda só no programa desktop
- **Lucro Presumido:** a edição (receitas por atividade, tributos e retenções) e o IRPJ/CSLL trimestral. No site, o LP mostra a memória de cálculo e a validação do que já está na nuvem.
- Simulador, Notas, Obrigações, CND e Cadastro.
- Baixar NFS-e do Portal Nacional com certificado digital e baixar notas pelo Meu Danfe. O navegador não acessa o certificado instalado no Windows.

## Publicar no Vercel
O site é **estático e já está na raiz** (index.html, css/, js/, img/, motor.zip). Não tem build e não precisa configurar nada no Vercel.

### Enviar para o GitHub com um clique
Dê **dois cliques em `enviar_github.bat`**. É preciso ter o Git instalado ([git-scm.com](https://git-scm.com)).
O arquivo roda os comandos abaixo e envia tudo para `https://github.com/godimay5-create/validador-web-1`:
```bash
echo "# validador-web-1" >> README.md
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/godimay5-create/validador-web-1.git
git push -u origin main
```
Na primeira vez, o Git abre uma janela para você entrar na sua conta do GitHub. No Mac ou Linux, use `./enviar_github.sh`.

### Opção A — GitHub + Vercel (deploy automático) — pelo site do GitHub
1. No GitHub, crie um repositório **privado** (ex.: `validador-web`) e clique em **uploading an existing file**.
2. Abra a pasta do zip e **selecione TUDO o que está dentro dela**: `index.html`, `css`, `js`, `img`, `py`, `fonte`, `motor.zip`,
   `vercel.json` e `README.md`. Arraste para o GitHub e clique em **Commit changes**.
   Confira: o `index.html` tem que aparecer na **primeira tela** do repositório, e não dentro de uma pasta.
3. No Vercel, vá em **Add New… → Project → Import** e escolha o repositório.
   - **Framework Preset:** Other
   - **Root Directory:** `./` (deixe como está)
   - **Build and Output Settings:** não mexa (tudo desligado)

   Clique em **Deploy**.
4. No Supabase, em **Authentication → URL Configuration → Site URL**, coloque o endereço que o Vercel gerou.

### Opção B — direto do computador (sem GitHub)
Com o Node instalado, abra o terminal **dentro desta pasta** e rode:
```
npx vercel --prod
```
Responda às perguntas com Enter, aceitando os padrões.

### Se o Vercel mostrar 404 ou "No Output Directory"
O `index.html` não está na raiz do repositório porque a pasta subiu inteira, um nível abaixo. Corrija de um destes jeitos:
- Em **Vercel → Settings → Build and Deployment → Root Directory**, coloque o nome da pasta onde está o `index.html` e faça **Redeploy**.
- Ou suba de novo só o conteúdo da pasta, como no passo 2.

## Estrutura
```
index.html                 telas
css/app.css                visual
js/app.js                  login, Supabase, tabela, empresa, etapas
js/motor-worker.js         carrega o Pyodide e o motor sem travar a página
js/config.js               URL e chave pública do Supabase, versão do motor
motor.zip                  motor do desktop (gerado por fonte/tools/montar_motor.py)
py/pypdf-*.whl             leitor de PDF do PGDAS-D (instalado no navegador quando aparece um PDF)
fonte/py/web.py            ponte entre a tela e o motor (entra no motor.zip)
fonte/py/supabase_rest_web.py   substitui o cliente de rede do desktop (no site, o JavaScript fala com o Supabase)
vercel.json                só cabeçalhos de segurança e cache (sem build)
```

## Observações
- A primeira abertura baixa uns 10 MB (o Python do navegador). Das próximas vezes vem do cache e abre bem mais rápido.
- Na primeira vez, o navegador já deixa selecionadas as empresas que têm dados na nuvem. A seleção fica gravada neste navegador.
- Se duas pessoas mexerem na mesma empresa e competência ao mesmo tempo, vale a última gravação (é o mesmo comportamento do .exe).
