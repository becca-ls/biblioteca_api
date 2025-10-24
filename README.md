# 📚 Biblioteca API

**Biblioteca API** é uma aplicação desenvolvida em **Ruby on Rails (API mode)** que permite o **gerenciamento de materiais bibliográficos**, incluindo livros, artigos e vídeos, com suporte a autenticação JWT, controle de permissões e associação entre materiais e autores.

O projeto foi desenvolvido como parte de um **desafio técnico** com o objetivo de demonstrar boas práticas de arquitetura, modelagem de dados e organização de código em uma aplicação backend.

---

## 🧩 Sumário
- [Arquitetura e Tecnologias](#arquitetura-e-tecnologias)
- [Modelagem e Relacionamentos](#modelagem-e-relacionamentos)
- [Setup do Projeto](#setup-do-projeto)
- [Autenticação e Autorização](#autenticação-e-autorização)
- [Endpoints Principais](#endpoints-principais)
- [Exemplos de Requisições](#exemplos-de-requisições)
- [Paginação e Busca](#paginação-e-busca)
- [Validações e Regras de Negócio](#validações-e-regras-de-negócio)
- [Testes Automatizados](#testes-automatizados)
- [Possíveis Extensões Futuras](#possíveis-extensões-futuras)

---

## 🏗️ Arquitetura e Tecnologias

A aplicação segue o padrão MVC do **Rails 8 API mode**, utilizando as seguintes bibliotecas e práticas:

| Categoria | Tecnologia |
|------------|-------------|
| Linguagem | Ruby 3.x |
| Framework | Ruby on Rails 8.x (API) |
| Banco de Dados | PostgreSQL |
| Autenticação | Devise + JWT |
| Autorização | Pundit |
| Busca | Ransack |
| Paginação | Kaminari |
| HTTP Client | Faraday (para integração com OpenLibrary) |
| Testes | RSpec + FactoryBot + Shoulda Matchers |

---

## 🧱 Modelagem e Relacionamentos

- **User**
  - Autenticado via Devise/JWT.
  - É o **dono** dos materiais criados.

- **Material**
  - Modelo principal com *Single Table Inheritance (STI)*.
  - Subtipos: `Book`, `Article`, `Video`.
  - Cada material pertence a um usuário e possui vários autores (via `Authorship`).

- **Author**
  - Representa autores do tipo `person` ou `institution`.
  - Relacionamento N:N com `Material`.

- **Authorship**
  - Tabela intermediária com `role` (função do autor no material).

📊 **Diagrama simplificado:**

```
User (1) ──── (N) Material (N) ──── (N) Author
                  │
                  └── (N) Authorship
```

---

## ⚙️ Setup do Projeto

```bash
# Clonar o repositório
git clone https://github.com/SEU-USUARIO/biblioteca_api.git
cd biblioteca_api

# Instalar dependências
bundle install

# Criar e migrar banco de dados
rails db:create db:migrate

# Rodar o servidor
rails s

# Rodar testes
bundle exec rspec
```

---

## 🔐 Autenticação e Autorização

A autenticação é feita via **Devise + JWT**, com tokens válidos até logout.  
A autorização utiliza **Pundit**, garantindo:
- Usuário pode **editar/deletar** apenas materiais criados por ele.
- Materiais **publicados** são visíveis a todos.

### Endpoints de autenticação
| Método | Rota | Descrição |
|--------|-------|-----------|
| `POST` | `/signup` | Cria novo usuário |
| `POST` | `/login` | Retorna JWT válido |
| `DELETE` | `/logout` | Invalida o token |

---

## 📂 Endpoints Principais

| Método | Rota | Descrição |
|--------|-------|-----------|
| `GET` | `/materials` | Lista materiais com filtros e paginação |
| `GET` | `/materials/:id` | Detalha um material |
| `POST` | `/materials` | Cria novo material |
| `PATCH/PUT` | `/materials/:id` | Atualiza material |
| `DELETE` | `/materials/:id` | Remove material |

### Parâmetros aceitos no `POST /materials`

```json
{
  "material": {
    "type": "Book",
    "title": "Programming Ruby",
    "description": "Guia completo da linguagem",
    "status": "published",
    "isbn": "9781234567890",
    "pages": 200,
    "authorships_attributes": [
      { "author_id": 1, "role": "author" }
    ]
  }
}
```

---

## 🔎 Paginação e Busca

### Paginação
- Implementada com **Kaminari**.
- Parâmetros opcionais:  
  `?page=2&per=10`

### Busca
- Implementada com **Ransack**.
- Permite filtrar por título, descrição, autor, status:
  ```
  /materials?q[title_cont]=ruby
  /materials?q[authors_name_cont]=matz
  ```

### Resposta exemplo:
```json
{
  "data": [
    {
      "id": 1,
      "title": "Programming Ruby",
      "type": "Book",
      "status": "published",
      "authors": [
        { "id": 3, "name": "Yukihiro Matsumoto", "kind": "person" }
      ]
    }
  ],
  "meta": {
    "page": 1,
    "per": 10,
    "total_pages": 1,
    "total_count": 1
  }
}
```

---

## 🧮 Validações e Regras de Negócio

| Tipo | Validações e Regras |
|------|----------------------|
| **Book** | `isbn` com 13 dígitos, `pages` > 0 |
| **Article** | `doi` válido e `url` obrigatória |
| **Video** | `duration_minutes` > 0 e `url` obrigatória |
| **Author** | `kind` ∈ {person, institution}; `person` não pode ter `founded_year`; `institution` não pode ter `birth_date` |
| **Material** | Somente criador pode editar/excluir; `status` ∈ {draft, published, archived} |

---

## 🧪 Testes Automatizados

O projeto inclui **RSpec configurado com FactoryBot e Shoulda Matchers**.

### Cobertura atual:
- ✅ `Author`
  - Associações (has_many)
  - Enum string (`kind`)
  - Validações de integridade
  - Escopos (`.people`, `.institutions`)
- ⚙️ Estrutura pronta para incluir `Material` e `Policy` specs.

### Como rodar:
```bash
bundle exec rspec
```

Exemplo de saída:
```
.......
Finished in 0.20 seconds
7 examples, 0 failures
```

---

## 🌐 Possíveis Extensões Futuras
- Integração com **OpenLibrary API** (Faraday) para preencher automaticamente título e páginas de livros via ISBN.
- Documentação **OpenAPI/Swagger** gerada com Rswag.
- Testes de integração (Request Specs) para `/materials` e autenticação JWT.
- Deploy em ambiente containerizado (Docker + Heroku).

