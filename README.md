# Notice

Esta versão do SOL foi customizada para atender o Serviço Nacional de Aprendizagem Rural – SENAR.
O SENAR é composto por uma Administração Central e 27 Administrações Regionais. Assim, a ferramenta SOL customizada tem, potencialmente, 28 unidades de execução de certames.
Além disso, atualmente o SENAR é co-executor do Projeto FIP Paisagens Rurais, sendo responsável pelo Componente 2, e a Agência de Cooperação Alemã GIZ é a responsável pela execução dos demais componentes do Projeto FIP Paisagens Rurais. Além desse projeto, o SENAR é o executor principal do Projeto GEF Vertentes, atualmente em fase de preparação.

Customizações:

- Customização do ambiente desktop e aplicativo com a identidade visual do SENAR;
- Autonomia das unidades executoras;
- Cadastro de vários projetos, sendo que cada projeto terá um conjunto próprio de unidades executoras. Para lançar um certame, a unidade executora precisará estar vinculada a um ou mais projetos, devendo escolher o projeto específico ao qual o referido certame está relacionado;
- Cadastro da regra de aquisição que será aplicada no certame;
- Cadastro dos tipos de certames previstos;
- Cadastro dos fluxos dos certames;
- Cadastro das saídas para término do certame;
- Cadastro de Usuários:
    - Administrador do Certame;
    - Avaliador;
    - Fornecedores;
- Situação de Certame;
- Relatórios;

Essa versão do SOL foi customizada pela LRGE Systems.

# SOL API

Para que as associações e cooperativas realizem as licitações de aquisição de bens, serviços e obras relativas aos seus projetos, os Governos do Estado da Bahia e do Rio Grande do Norte desenvolveram e disponibilizaram o aplicativo de compras SOL (Solução Online de Licitações).

---

Este repositório contém toda a API necessária para demais aplicações:
- sol-admin-frontend;
- sol-cooperative-frontend;
- sol-supplier-frontend.

## Configuração inicial

O executável `setup` deve realizar todo o trabalho necessário, então apenas rode:

```
  bin/setup
```

Após a configuração inicial da aplicação, devemos rodar a task principal para configuração dos dados (`setup:load`).

**Obs:** Não esqueça de setar na aplicação que irá consultar a API os valores de `uid` e `secret` gerados pelo comando acima.

## Iniciando o servidor

O sistema conta com um Procfile e todos seus processos podem ser iniciados por um gerênciador de processos como o foreman, basta executar:

```
 bundle exec foreman start
```

## Testes

O projeto conta com a gem Guard que permite rodar os testes automaticamente ao editar um teste/arquivo, para isso basta executar:

```
 guard
```
