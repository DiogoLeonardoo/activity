# Atividade de Gestão Acadêmica com Firebase

Este é um projeto desenvolvido para a disciplina de Tópicos Especiais II do curso de Análise e Desenvolvimento de Sistemas do Instituto Federal de Sergipe (IFS).

## Sobre o Projeto

O sistema consiste em um gerenciador de atividades acadêmicas com autenticação e armazenamento no Firebase que permite:
- Autenticação de usuários com email e senha
- Autenticação com Google
- Cada usuário ter acesso somente às suas próprias matérias e atividades
- Adicionar e gerenciar atividades
- Cadastrar convidados/participantes
- Gerenciar matérias e suas respectivas atividades
- Editar perfil de usuário
- Visualizar informações do perfil do Google

## Equipe de Desenvolvimento

- Aline Ferreira dos Santos
- Diogo Leonardo Lima e Silva
- Gheizla Raissa Passos Santos

## Tecnologias Utilizadas

Este projeto foi desenvolvido utilizando:
- Flutter - Framework UI multiplataforma
- Firebase - Plataforma de desenvolvimento para backend
  - Firebase Authentication - Para autenticação de usuários
  - Cloud Firestore - Banco de dados NoSQL em tempo real
  - Firebase Crashlytics - Monitoramento e relatório de erros

## Configuração do Firebase

Este projeto utiliza o Firebase como backend. Para configurá-lo em seu ambiente de desenvolvimento, consulte o arquivo [FIREBASE_SETUP.md](FIREBASE_SETUP.md) para instruções detalhadas.

## Estrutura do Projeto

```
lib/
├── main.dart            # Ponto de entrada do aplicativo
├── models/              # Classes de modelo de dados
│   ├── atividade.dart   # Modelo de Atividade
│   ├── convidado.dart   # Modelo de Convidado
│   └── materia.dart     # Modelo de Matéria
├── screens/             # Telas da aplicação
├── services/            # Serviços para comunicação com o Firebase
│   ├── auth_service.dart     # Serviço de autenticação
│   └── firestore_service.dart # Serviço do Firestore
├── utils/               # Utilitários e helpers
└── widgets/             # Widgets reutilizáveis
```

## Como Executar

1. Clone este repositório
2. Execute `flutter pub get` para instalar as dependências
3. Configure o Firebase seguindo as instruções em [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
4. Execute o aplicativo com `flutter run`

## Autenticação e Acesso a Dados

O aplicativo implementa um sistema de autenticação completo:

1. Cada usuário registra-se com email, senha e nome
2. Os dados do usuário são armazenados com segurança no Firebase Authentication e Firestore
3. Após autenticação, cada usuário tem acesso somente às suas próprias matérias e atividades
4. Os dados são organizados hierarquicamente no Firestore:
   - `users/{userId}/materias/{materiaId}`
   - `users/{userId}/materias/{materiaId}/atividades/{atividadeId}`

## Recursos de Usuário

- **Perfil de Usuário**: Visualização e edição das informações do perfil
- **Login/Logout**: Sistema completo de autenticação
- **Proteção de Dados**: Isolamento de dados por usuário
2. Configure o Firebase seguindo as instruções no arquivo FIREBASE_SETUP.md
3. Execute `flutter pub get` para instalar as dependências
4. Execute `flutter run` para iniciar a aplicação