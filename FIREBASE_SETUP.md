# Configuração do Firebase para o Projeto Gestão Acadêmica

Este documento contém instruções detalhadas sobre como configurar o Firebase para este projeto Flutter.

## Passo 1: Criar um projeto no Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Clique em "Adicionar projeto"
3. Digite o nome do projeto (ex: "Gestão Acadêmica")
4. Siga as instruções para criar o projeto

## Passo 2: Configurar o Firebase para Android

1. No console do Firebase, clique no projeto que você acabou de criar
2. Clique no ícone do Android para adicionar um aplicativo Android
3. Preencha as informações:
   - Nome do pacote Android: `com.seu.nome.gestao_academica` (verifique o valor correto no arquivo `/android/app/build.gradle`)
   - Apelido do app (opcional): "Gestão Acadêmica"
4. Clique em "Registrar app"
5. Baixe o arquivo `google-services.json`
6. Coloque o arquivo `google-services.json` na pasta `/android/app/` do seu projeto Flutter
7. Siga as instruções para adicionar as dependências do Firebase ao seu projeto Android:

   No arquivo `/android/build.gradle`, adicione:
   ```gradle
   buildscript {
     dependencies {
       // ... outras dependências
       classpath 'com.google.gms:google-services:4.3.15'  // Google Services plugin
     }
   }
   ```
   
   No arquivo `/android/app/build.gradle`, adicione no final:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

## Passo 3: Configurar o Firebase para iOS (se aplicável)

1. No console do Firebase, clique no projeto
2. Clique no ícone do iOS para adicionar um aplicativo iOS
3. Preencha as informações:
   - Bundle ID do iOS: encontrado no arquivo `/ios/Runner.xcodeproj/project.pbxproj`
   - Apelido do app (opcional): "Gestão Acadêmica"
4. Clique em "Registrar app"
5. Baixe o arquivo `GoogleService-Info.plist`
6. Adicione o arquivo ao projeto iOS usando Xcode:
   - Abra `/ios/Runner.xcworkspace` com Xcode
   - Arraste o arquivo `GoogleService-Info.plist` para a pasta Runner no Xcode
   - Certifique-se de que "Copy items if needed" esteja marcado

## Passo 4: Habilitar os serviços do Firebase necessários

No console do Firebase, habilite os serviços que você vai usar:

1. **Authentication**:
   - Acesse "Authentication" > "Sign-in method"
   - Habilite "Email/Password"
   
2. **Cloud Firestore**:
   - Acesse "Firestore Database"
   - Clique em "Criar banco de dados"
   - Escolha o modo (produção ou teste)
   - Selecione a região mais próxima
   
3. **Configuração de regras de segurança**:
   
   Para Firestore, configure regras iniciais para desenvolvimento:
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

## Passo 5: Teste a integração

1. Execute seu aplicativo com `flutter run`
2. Verifique se o Firebase é inicializado corretamente (sem erros no console)
3. Teste a funcionalidade de autenticação e Firestore

## Solução de Problemas

- **Erro de inicialização do Firebase**: Verifique se você adicionou corretamente os arquivos de configuração e as dependências.
- **Erros de compilação**: Certifique-se de que todas as dependências do Firebase estão atualizadas no arquivo `pubspec.yaml`.
- **Firestore inacessível**: Verifique suas regras de segurança e se o usuário está autenticado quando necessário.

## Recursos Úteis

- [Documentação do FlutterFire](https://firebase.flutter.dev/docs/overview)
- [Documentação do Firebase](https://firebase.google.com/docs)
