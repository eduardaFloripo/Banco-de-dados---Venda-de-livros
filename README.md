# Banco-de-dados---Venda-de-livros

# 📚 Sistema de Vendas de Livros — Banco de Dados 2 (Oracle)

## 📌 Sobre o projeto
Este repositório contém o projeto desenvolvido na disciplina de **Banco de Dados 2**, com foco na modelagem e manipulação de um **banco de dados relacional (Oracle)** no domínio de um **sistema de vendas de livros**.

O trabalho parte de um modelo físico e implementa a base completa no Oracle, incluindo tabelas, relacionamentos, restrições (constraints) e consultas SQL para análise e relatórios.

---

## 🧩 O que foi implementado
- **Modelagem relacional** para simular uma livraria (clientes, produtos, pedidos, entregas, fornecedores, etc.)
- **Criação das tabelas** com chaves primárias e estrangeiras
- **Regras de integridade**, como:
  - hierarquia de categorias (categoria pai e subcategoria)
  - separação de cliente em **Pessoa Física** e **Pessoa Jurídica**
  - tabela associativa para relacionamento N:N entre produto e fornecedor
- **Carga de dados** para popular as tabelas e permitir testes
- **Consultas SQL** com relatórios (ex.: clientes por região, top produtos mais vendidos, pedidos mais caros, entregas, etc.)

---

## 📂 Arquivos 
- `trabalho.sql` → criação das tabelas + constraints + inserts (popular a base)
- `consultas.sql` → consultas SQL desenvolvidas para atender os requisitos do trabalho

---

## 🛠️ Tecnologias
- **Oracle Database**
- **SQL**

