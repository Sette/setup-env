# Setup-env

Este repositório contém um conjunto de scripts e configurações para facilitar o setup de ambientes de desenvolvimento semelhantes ao Kaggle em diferentes distribuições Linux: Ubuntu, Fedora e Amazon Linux.

## Objetivo

Automatizar a preparação do ambiente de dados e ciência, instalando ferramentas essenciais como Python, Docker, Zsh (com plugins), entre outros, para que o usuário esteja pronto para iniciar trabalhos em Machine Learning e Ciência de Dados rapidamente.

## Estrutura do Projeto

- install.sh: Script para preparar ambiente Linux (instalação de Docker, Python, Zsh, etc.).
- **LICENSE**: Licença do projeto (MIT License).

## Como Usar

O script principal `install.sh` permite instalar múltiplos componentes de uma só vez utilizando flags.

### Opções Disponíveis

- `-n`: **Modo Não-interativo**. Assume "sim" (yes) para todas as confirmações durante a instalação.
- `-z`: **Instalar ZSH**. Configura o ZSH com Oh My Zsh e plugins (syntax highlighting, autosuggestions).
- `-p`: **Instalar Python**. Instala as dependências do sistema e o gerenciador `uv` com a versão global do Python.
- `-d`: **Instalar Docker**. Realiza a instalação e configuração do Docker no sistema.
- `-h`: **Ajuda**. Exibe a mensagem de ajuda com todas as opções.

### Exemplos

Para instalar tudo (Zsh, Python e Docker) no modo silencioso:
```bash
sh <(wget -qO - https://raw.githubusercontent.com/Sette/setup-env/refs/heads/main/install.sh) -z -p -d -n
```

Para instalar apenas o Zsh e Python:
```bash
sh <(wget -qO - https://raw.githubusercontent.com/Sette/setup-env/refs/heads/main/install.sh) -z -p -n
```

Recarregue seu interpretador rodando:

Caso use o zsh, rode:
```bash
source ~/.zshrc
```

Caso use o bash, rode:
```bash
source ~/.bashrc
```

(Optional) (Python) Criando uma .venv:

```bash
uv venv
```

Ativando a .venv:

```bash
source .venv/bin/activate
```

Recomendações para desenvolvimento python no VScode:

https://code.visualstudio.com/docs/python/linting

Siga as instruções de cada script, pois podem exigir permissões de administrador (sudo).

## Pré-requisitos

- Permissão de superusuário (sudo)
- Conexão com internet
- Git instalado (para alguns scripts e plugins)

## Observações

- Os scripts podem ser adaptados conforme sua necessidade.
- Verifique o conteúdo de cada script antes de rodar para entender suas ações e dependências.

## Licença

Este projeto está licenciado sob a Licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---

Colabore sugerindo melhorias e relatando problemas.

##
