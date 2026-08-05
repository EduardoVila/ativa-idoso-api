# Acesso sem CPF

Usuários podem acessar vídeos sem informar CPF. O frontend identifica a instalação do navegador por um UUID salvo no `localStorage`.

## 1. Criar ou recuperar sessão anônima

Ao iniciar a aplicação, recupere o `device_id` ou gere um novo:

```javascript
function getDeviceId() {
  let deviceId = localStorage.getItem('ativa_idoso_device_id');

  if (!deviceId) {
    deviceId = crypto.randomUUID();
    localStorage.setItem('ativa_idoso_device_id', deviceId);
  }

  return deviceId;
}
```

Envie o identificador para a API:

```http
POST /v1/anonymous_sessions
X-Device-ID: 9f8c7b6a-5d4e-4f3a-9b2c-1d0e8f7a6b5c
```

Exemplo:

```javascript
const deviceId = getDeviceId();

const sessionResponse = await fetch(`${API_URL}/v1/anonymous_sessions`, {
  method: 'POST',
  headers: {
    'X-Device-ID': deviceId,
  },
});

if (!sessionResponse.ok) {
  throw new Error('Não foi possível iniciar a sessão.');
}

const session = await sessionResponse.json();
localStorage.setItem('ativa_idoso_access_token', session.access_token);
```

Para o mesmo `device_id`, a API retorna o mesmo usuário e token. A primeira chamada retorna `201`; as seguintes retornam `200`.

Resposta:

```json
{
  "id": 12,
  "cpf": null,
  "name": "Usuário anônimo",
  "access_token": "TOKEN_DE_ACESSO",
  "status": "research_pending",
  "anonymous": true
}
```

## 2. Acessar vídeos

Use o token salvo no header `Authorization`, sem o prefixo `Bearer`:

```javascript
const accessToken = localStorage.getItem('ativa_idoso_access_token');

const response = await fetch(`${API_URL}/v1/videos?section=lower_limbs`, {
  headers: {
    Authorization: accessToken,
  },
});
```

O usuário anônimo pode acessar vídeos e registrar progresso normalmente.

## 3. Solicitar CPF para a pesquisa

Ao abrir a pesquisa de experiência, consulte:

```http
GET /v1/satisfaction_surveys
Authorization: TOKEN_DE_ACESSO
```

Se a sessão for anônima, a API retorna `403`. Nesse caso, exiba a tela de CPF e execute o fluxo atual de cadastro/autenticação:

```http
POST /v1/users
Content-Type: application/json

{
  "name": "Nome do usuário",
  "cpf": "000.000.000-00"
}
```

Depois use o `access_token` retornado pelo usuário identificado para consultar e enviar a pesquisa.

Se o CPF já estiver cadastrado, `POST /v1/users` retorna `200` e o usuário existente com o token atual. Se for um CPF novo, retorna `201` e cria o usuário.

Usuários anônimos não podem responder a pesquisa, mesmo que tentem chamar o endpoint diretamente.

## 4. Perda do histórico

O histórico ficará vinculado ao `device_id` e ao token salvo no navegador. Ele será perdido quando o usuário:

- limpar os dados do site;
- usar outro navegador ou dispositivo;
- acessar em uma janela anônima;
- perder o `localStorage`.

Isso é esperado neste fluxo.

## 5. Tratamento de erros

| Status | Situação |
| ---: | --- |
| 201 | Sessão anônima criada |
| 200 | Sessão existente recuperada |
| 401 | Token ausente ou inválido |
| 403 | Sessão anônima tentando responder pesquisa |
| 422 | `X-Device-ID` ausente ou inválido |
