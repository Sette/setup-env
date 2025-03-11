curl -X POST http://chat.mp.datascience.legal:3000/api/chat/completions \
-H "Authorization: Bearer SUA_CHAVE_DE_API" \
-H "Content-Type: application/json" \
-d '{
      "model": "iara",
      "messages": [
        {"role": "user", "content": "Forneça insights sobre as perspectivas históricas cobertas na base de conhecimento."}
      ],
      "files": [
        {"type": "collection", "id": "id-da-sua-colecao"}
      ]
    }'