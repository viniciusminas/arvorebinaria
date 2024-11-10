# 🌳 Sistema de Gerenciamento de UFs e Municípios com Árvore Binária

Implementamos uma estrutura de **árvore binária** em Pascal. Este sistema organiza estados brasileiros (UFs) e permite inserir e remover municípios de cada estado, mantendo a organização de dados em árvore. Confira os detalhes abaixo para entender o funcionamento e os comandos disponíveis! 🚀

## 📋 Regras de Funcionamento

1. **Cadastro de UFs e Municípios**:
   - As UFs (estados) são cadastradas automaticamente quando o **primeiro município** é inserido.
   - A UF é organizada em uma **árvore binária** de forma que os estados são mantidos em **ordem alfabética**.

2. **Exclusão de UFs**:
   - Quando o **último município** de uma UF é removido, a UF também é **removida automaticamente** da árvore principal.
  
3. **Inserção e Remoção**:
   - Segue a regra da árvore binária: **menores à esquerda** e **maiores à direita** para organizar tanto as UFs quanto os municípios de cada UF.

## 📂 Estrutura dos Dados

Cada nó da árvore principal representa uma UF (estado) e contém:
   - Um ponteiro para a **subárvore à esquerda** 🌐
   - Um ponteiro para a **subárvore à direita** 🌐
   - A **sigla da UF** (ex: PR, SC, RS, etc) 🇧🇷
   - Um **endereço para uma árvore binária** de municípios daquela UF 🏙️

Os municípios em cada UF também são organizados em árvore binária alfabética.

## 🔧 Funcionalidades do Sistema

O sistema permite as seguintes operações:

1. **Incluir Município em uma UF** ➕
   - Caso a UF não exista, ela será criada automaticamente ao adicionar o primeiro município.

2. **Remover Município de uma UF** ➖
   - Caso a UF fique sem municípios, ela será automaticamente excluída da árvore principal.

3. **Mostrar Estados (UFs) Cadastrados** 🌎
   - Exibe todas as UFs em ordem alfabética.

4. **Mostrar Municípios de uma UF** 🏢
   - Exibe todos os municípios de uma UF específica em ordem alfabética.

5. **Contar Municípios por UF** 🔢
   - Exibe a quantidade de municípios cadastrados em cada UF.
