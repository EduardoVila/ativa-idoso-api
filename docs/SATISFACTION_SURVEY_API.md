# Pesquisa de experiência

O usuário pode responder uma única vez à pesquisa. Todas as perguntas usam uma escala de 1 a 5:

| Nota | Significado |
| ---: | --- |
| 1 | Muito difícil |
| 2 | Difícil |
| 3 | Regular |
| 4 | Fácil |
| 5 | Muito fácil |

## Autenticação

Enviar o token diretamente no header `Authorization`, sem o prefixo `Bearer`:

```http
Authorization: ACCESS_TOKEN_DO_USUARIO
```

## Consultar a pesquisa

```http
GET /v1/satisfaction_surveys
```

Resposta quando ainda não respondeu:

```json
{
  "submitted": false,
  "questions": [
    { "key": "platform_access_score", "description": "Foi fácil usar a plataforma Ativa Idoso?" },
    { "key": "qr_code_access_score", "description": "Foi fácil acessar os vídeos pelo QR Code?" },
    { "key": "videos_understanding_score", "description": "Os vídeos foram fáceis de entender?" },
    { "key": "videos_motivation_score", "description": "Os vídeos motivaram você a fazer os exercícios?" }
  ],
  "response": null
}
```

## Enviar respostas

```http
POST /v1/satisfaction_surveys
Content-Type: application/json
Authorization: ACCESS_TOKEN_DO_USUARIO
```

Body:

```json
{
  "platform_access_score": 5,
  "qr_code_access_score": 5,
  "videos_understanding_score": 4,
  "videos_motivation_score": 4
}
```

Exemplo:

```javascript
const response = await fetch(`${API_URL}/v1/satisfaction_surveys`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    Authorization: accessToken,
  },
  body: JSON.stringify({
    platform_access_score: platformAccessScore,
    qr_code_access_score: qrCodeAccessScore,
    videos_understanding_score: videosUnderstandingScore,
    videos_motivation_score: videosMotivationScore,
  }),
});
```

Resposta de sucesso: `201 Created`. Cada nota deve ser um número entre 1 e 5.

## Status de erro

| Status | Situação |
| ---: | --- |
| 400 | JSON inválido |
| 401 | Token ausente ou inválido |
| 409 | Usuário já respondeu |
| 422 | Nota inválida ou campo ausente |

Fluxo recomendado: chamar o `GET` ao abrir a tela; exibir o formulário somente quando `submitted` for `false`; enviar as quatro notas no `POST`; após `201` ou `409`, considerar a pesquisa concluída.
