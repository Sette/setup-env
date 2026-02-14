# Setup-env

Este repositório contém um conjunto de scripts e configurações para facilitar o setup de ambientes de desenvolvimento semelhantes ao Kaggle em diferentes distribuições Linux: Ubuntu, Fedora e Amazon Linux.

## Objetivo

Automatizar a preparação do ambiente de dados e ciência, instalando ferramentas essenciais como Python, Docker, Zsh (com plugins), entre outros, para que o usuário esteja pronto para iniciar trabalhos em Machine Learning e Ciência de Dados rapidamente.

## Estrutura do Projeto

- **ubuntu/**: Scripts para preparar ambiente Ubuntu (instalação de Docker, Python, Zsh, etc.).
- **fedora/**: Scripts para preparar ambiente Fedora (instalação de Docker, Python, Zsh, etc.).
- **amazon/**: Scripts para Amazon Linux (ex: configuração aprimorada do Zsh).
- **LICENSE**: Licença do projeto (MIT License).

## Como Usar

Escolha a pasta correspondente ao seu sistema operacional e execute os scripts conforme necessário. Por exemplo, para preparar o Zsh em Ubuntu:

```bash
cd ubuntu
chmod +x setup_zsh.sh
./setup_zsh.sh
```

Para instalar o docker no ubuntu (Depois disso, Faça logof para que as permissões surtam efeito):

```bash
cd ubuntu
chmod +x setup_docker.sh    # Exemplo para instalar Docker
./setup_docker.sh
```

Para instalar o python com o UV:

```bash
cd ubuntu
chmod +x setup_python.sh
./setup_python.sh
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

Criando uma .venv:

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
