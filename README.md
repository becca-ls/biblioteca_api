# Biblioteca API (Desafio V-LAB)

API RESTful para gerenciar materiais (livros, artigos, vídeos) e autores (pessoa/instituição).
Inclui autenticação por e-mail/senha (JWT), permissões (owner-only para editar/excluir),
busca com paginação e integração com OpenLibrary para ISBN.

## Stack
- Ruby 3.3.0 + Rails (API mode)
- PostgreSQL
- Devise + devise-jwt, Pundit, Pagy, Faraday
- ActiveModel::Serializers (ou Jbuilder)
- RSpec, FactoryBot, Shoulda Matchers, Faker, WebMock + VCR
- Rswag (Swagger UI)
